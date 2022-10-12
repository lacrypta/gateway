// SPDX-License-Identifier: AGPL-3.0-or-later
pragma solidity ^0.8.17;

import {Context} from "@openzeppelin/contracts/utils/Context.sol";
import {ERC165} from "@openzeppelin/contracts/utils/introspection/ERC165.sol";
import {SignatureChecker} from "@openzeppelin/contracts/utils/cryptography/SignatureChecker.sol";

import {Multicall} from "@openzeppelin/contracts/utils/Multicall.sol";
import {ReentrancyGuard} from "@openzeppelin/contracts/security/ReentrancyGuard.sol";

import {ToString} from "./ToString.sol";
import {Epoch} from "./DateTime.sol";

import "./IGateway.sol";

abstract contract Gateway is Context, ERC165, IGateway, Multicall, ReentrancyGuard {
    using ToString for Epoch;
    using ToString for bytes;
    using ToString for uint32;
    using ToString for uint256;

    /**
     * Structure used to keep track of handling functions
     *
     * @custom:member message  The user-readable message-generating function
     * @custom:member signer  The signer-extractor function
     * @custom:member execute  The execution function
     */
    struct HandlerEntry {
        function(Voucher calldata) view returns (string memory) message;
        function(Voucher calldata) view returns (address) signer;
        function(Voucher calldata) execute;
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
    function hashVoucher(Voucher calldata voucher) external view override returns (bytes32 voucherHash) {
        voucherHash = _hashVoucher(voucher);
    }

    /**
     * Return the string representation to be signed for a given Voucher
     *
     * @param voucher  The voucher to stringify
     * @return voucherString  The string representation to be signed of the given voucher
     */
    function stringifyVoucher(Voucher calldata voucher) external view override returns (string memory voucherString) {
        voucherString = _stringifyVoucher(voucher);
    }

    /**
     * Validate the given voucher against the given signature
     *
     * @param voucher  The voucher to validate
     * @param signature  The associated voucher signature
     */
    function validateVoucher(Voucher calldata voucher, bytes calldata signature) external view override {
        _validateVoucher(voucher, signature);
    }

    /**
     * Validate the given voucher against the given signature, by the given signer
     *
     * @param voucher  The voucher to validate
     * @param r  The "r" component of the associated voucher signature
     * @param s  The "s" component of the associated voucher signature
     * @param v  The "v" component of the associated voucher signature
     */
    function validateVoucher(Voucher calldata voucher, bytes32 r, bytes32 s, uint8 v) external view override {
        _validateVoucher(voucher, _joinSignatureParts(r, s, v));
    }

    /**
     * Serve the given voucher, by forwarding to the appropriate handler for the voucher's tag
     *
     * @param voucher  The voucher to serve
     * @param signature  The associated voucher signature
     * @custom:emit  VoucherServed
     */
    function serveVoucher(Voucher calldata voucher, bytes calldata signature) external override nonReentrant {
        _serveVoucher(voucher, signature);
    }

    /**
     * Serve the given voucher, by forwarding to the appropriate handler for the voucher's tag
     *
     * @param voucher  The voucher to serve
     * @param r  The "r" component of the associated voucher signature
     * @param s  The "s" component of the associated voucher signature
     * @param v  The "v" component of the associated voucher signature
     * @custom:emit  VoucherServed
     */
    function serveVoucher(Voucher calldata voucher, bytes32 r, bytes32 s, uint8 v) external override nonReentrant {
        _serveVoucher(voucher, _joinSignatureParts(r, s, v));
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
    function _message(Voucher calldata voucher) internal view returns (string memory message) {
        message = voucherHandler[voucher.tag].message(voucher);
    }

    /**
     * Retrieve the signer of the given Voucher
     *
     * @param voucher  Voucher to retrieve the signer of
     * @return signer  The voucher's signer
     */
    function _signer(Voucher calldata voucher) internal view returns (address signer) {
        signer = voucherHandler[voucher.tag].signer(voucher);
    }

    /**
     * Execute the given Voucher
     *
     * @param voucher  Voucher to execute
     */
    function _execute(Voucher calldata voucher) internal {
        voucherHandler[voucher.tag].execute(voucher);
    }

    /**
     * Actually return the string representation to be signed for a given Voucher
     *
     * @param voucher  The voucher to stringify
     * @return voucherString  The string representation to be signed of the given voucher
     */
    function _stringifyVoucher(Voucher calldata voucher) internal view returns (string memory voucherString) {
        voucherString = string.concat(
            string.concat(_message(voucher), "\n"),
            "---\n",
            string.concat("tag: ", voucher.tag.toString(), "\n"),
            string.concat("nonce: ", voucher.nonce.toString(), "\n"),
            string.concat("deadline: ", Epoch.wrap(uint40(voucher.deadline)).toString(), "\n"),
            string.concat("payload: ", voucher.payload.toString(), "\n"),
            string.concat("metadata: ", voucher.metadata.toString())
        );
    }

    /**
     * Actually return the voucher hash associated to the given voucher
     *
     * @param voucher  The voucher to retrieve the hash for
     * @return voucherHash  The voucher hash associated to the given voucher
     */
    function _hashVoucher(Voucher calldata voucher) internal view returns (bytes32 voucherHash) {
        voucherHash = keccak256(bytes(_stringifyVoucher(voucher)));
    }

    /**
     * Validate the given voucher against the given signature, by the given signer
     *
     * @param voucher  The voucher to validate
     * @param signature  The associated voucher signature
     */
    function _validateVoucher(Voucher calldata voucher, bytes memory signature) internal view {
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
    function _serveVoucher(Voucher calldata voucher, bytes memory signature) internal {
        _validateVoucher(voucher, signature);

        bytes32 voucherHash = _hashVoucher(voucher);
        require(voucherServed[voucherHash] == false, "Gateway: voucher already served");
        voucherServed[voucherHash] = true;

        _execute(voucher);

        emit VoucherServed(voucherHash, _msgSender());
    }

    // --- Private Utilities ----------------------------------------------------------------------------------------------------------------------------------

    /**
     * Join the "r", "s", and "v" components of a signature into a single bytes structure
     *
     * @param r  The "r" component of the signature
     * @param s  The "s" component of the signature
     * @param v  The "v" component of the signature
     * @return signature  The joint signature
     */
    function _joinSignatureParts(bytes32 r, bytes32 s, uint8 v) private pure returns (bytes memory signature) {
        signature = bytes.concat(r, s, bytes1(v));
    }
}
