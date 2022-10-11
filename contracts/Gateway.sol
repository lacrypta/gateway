// SPDX-License-Identifier: AGPL-3.0-or-later
pragma solidity ^0.8.17;

import {Context} from "@openzeppelin/contracts/utils/Context.sol";
import {ERC165} from "@openzeppelin/contracts/utils/introspection/ERC165.sol";
import {SignatureChecker} from "@openzeppelin/contracts/utils/cryptography/SignatureChecker.sol";

import {Multicall} from "@openzeppelin/contracts/utils/Multicall.sol";
import {ReentrancyGuard} from "@openzeppelin/contracts/security/ReentrancyGuard.sol";

import "./Strings.sol";

import "./IGateway.sol";

abstract contract Gateway is Context, ERC165, IGateway, Multicall, ReentrancyGuard {
    /**
     * Structure used to keep track of handling functions
     *
     * @custom:member message  The user-readable message-generating function
     * @custom:member signer  The signer-extractor function
     * @custom:member execute  The execution function
     */
    struct HandlerEntry {
        function(Voucher memory) view returns (string memory) message;
        function(Voucher memory) view returns (address) signer;
        function(Voucher memory) execute;
    }

    // Mapping from voucher tag to handling entry
    mapping(uint32 => HandlerEntry) private voucherHandler;

    // typehash associated to the gateway Voucher itself
    //
    // This is computed using the "encodeType" convention laid out in <https://eips.ethereum.org/EIPS/eip-712#definition-of-encodetype>.
    bytes32 public constant override VOUCHER_TYPEHASH =
        keccak256("Voucher(uint32 tag,uint256 nonce,uint256 deadline,bytes payload,bytes metadata)");

    // Set of voucher hashes served
    mapping(bytes32 => bool) public override voucherServed;

    /**
     * Implementation of the IERC165 interface
     *
     * @param interfaceId  Interface ID to check against
     * @return  Whether the provided interface ID is supported
     */
    function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
        return interfaceId == type(IGateway).interfaceId || super.supportsInterface(interfaceId);
    }

    /**
     * Return the voucher hash associated to the given voucher
     *
     * @param voucher  The voucher to retrieve the hash for
     * @return voucherHash  The voucher hash associated to the given voucher
     */
    function hashVoucher(Voucher memory voucher) external view override returns (bytes32 voucherHash) {
        voucherHash = _hashVoucher(voucher);
    }

    /**
     * Return the string representation to be signed for a given Voucher
     *
     * @param voucher  The voucher to stringify
     * @return voucherString  The string representation to be signed of the given voucher
     */
    function stringifyVoucher(Voucher memory voucher) external view override returns (string memory voucherString) {
        voucherString = _stringifyVoucher(voucher);
    }

    /**
     * Validate the given voucher against the given signature
     *
     * @param voucher  The voucher to validate
     * @param signature  The associated voucher signature
     */
    function validateVoucher(Voucher memory voucher, bytes memory signature) external view override {
        _validateVoucher(voucher, signature);
    }

    /**
     * Serve the given voucher, by forwarding to the appropriate handler for the voucher's tag
     *
     * @param voucher  The voucher to serve
     * @param signature  The associated voucher signature
     * @custom:emit  VoucherServed
     */
    function serveVoucher(Voucher memory voucher, bytes memory signature) external override nonReentrant {
        _serveVoucher(voucher, signature);
    }

    // --- Protected handling ---------------------------------------------------------------------------------------------------------------------------------

    /**
     * Add the given pair of signer and serving functions to the tag map
     *
     * @param tag  The tag to add the mapping for
     * @param entry  The handling entry instance
     */
    function _addHandler(uint32 tag, HandlerEntry memory entry) internal {
        voucherHandler[tag] = entry;
    }

    /**
     * Add the given pair of signer and serving functions to the tag map
     *
     * @param tag  The tag to remove the mapping for
     * @return entry  The previous entry
     */
    function _removeHandler(uint32 tag) internal returns (HandlerEntry memory entry) {
        entry = voucherHandler[tag];
        delete voucherHandler[tag];
    }

    // --- Protected utilities --------------------------------------------------------------------------------------------------------------------------------

    /**
     * Return the user-readable message for the given voucher
     *
     * @param voucher  Voucher to obtain the user-readable message for
     * @return message  The voucher's user-readable message
     */
    function _message(Voucher memory voucher) internal view returns (string memory message) {
        message = voucherHandler[voucher.tag].message(voucher);
    }

    /**
     * Retrieve the signer of the given Voucher
     *
     * @param voucher  Voucher to retrieve the signer of
     * @return signer  The voucher's signer
     */
    function _signer(Voucher memory voucher) internal view returns (address signer) {
        signer = voucherHandler[voucher.tag].signer(voucher);
    }

    /**
     * Execute the given Voucher
     *
     * @param voucher  Voucher to execute
     */
    function _execute(Voucher memory voucher) internal {
        voucherHandler[voucher.tag].execute(voucher);
    }

    /**
     * Actually return the string representation to be signed for a given Voucher
     *
     * @param voucher  The voucher to stringify
     * @return voucherString  The string representation to be signed of the given voucher
     */
    function _stringifyVoucher(Voucher memory voucher) internal view returns (string memory voucherString) {
        voucherString = string.concat(
            string.concat(_message(voucher), "\n"),
            "---\n",
            string.concat("tag: ", toString(voucher.tag), "\n"),
            string.concat("nonce: ", toString(voucher.nonce), "\n"),
            string.concat("deadline: ", toIso8601(Epoch.wrap(uint40(voucher.deadline))), "\n"),
            string.concat("payload: ", toString(voucher.payload), "\n"),
            string.concat("metadata: ", toString(voucher.metadata))
        );
    }

    /**
     * Actually return the voucher hash associated to the given voucher
     *
     * @param voucher  The voucher to retrieve the hash for
     * @return voucherHash  The voucher hash associated to the given voucher
     */
    function _hashVoucher(Voucher memory voucher) internal view returns (bytes32 voucherHash) {
        voucherHash = keccak256(bytes(_stringifyVoucher(voucher)));
    }

    /**
     * Validate the given voucher against the given signature, by the given signer
     *
     * @param voucher  The voucher to validate
     * @param signature  The associated voucher signature
     */
    function _validateVoucher(Voucher memory voucher, bytes memory signature) internal view {
        require(SignatureChecker.isValidSignatureNow(_signer(voucher), _hashVoucher(voucher), signature), "Gateway: invalid voucher signature");
        require(block.timestamp <= voucher.deadline, "Gateway: expired deadline");
    }

    /**
     * Mark the given voucher hash as served, and emit the corresponding event
     *
     * @param voucher  The voucher hash to serve
     * @param signature  The associated voucher signature
     * @custom:emit  VoucherServed
     */
    function _serveVoucher(Voucher memory voucher, bytes memory signature) internal {
        _validateVoucher(voucher, signature);

        bytes32 voucherHash = _hashVoucher(voucher);
        require(voucherServed[voucherHash] == false, "Gateway: voucher already served");
        voucherServed[voucherHash] = true;

        _execute(voucher);

        emit VoucherServed(voucherHash, _msgSender());
    }
}
