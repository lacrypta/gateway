// SPDX-License-Identifier: AGPL-3.0-or-later
pragma solidity ^0.8.17;

import {IERC20Permit} from "@openzeppelin/contracts/token/ERC20/extensions/draft-IERC20Permit.sol";
import {IERC20Metadata} from "@openzeppelin/contracts/token/ERC20/extensions/IERC20Metadata.sol";
import {SafeERC20} from "@openzeppelin/contracts/token/ERC20/utils/SafeERC20.sol";

import {ERC20Gateway} from "./ERC20Gateway.sol";
import {IERC20PermitGateway} from "./IERC20PermitGateway.sol";

import "./Strings.sol";

abstract contract ERC20PermitGateway is ERC20Gateway, IERC20PermitGateway {
    using SafeERC20 for IERC20Permit;

    // Tag associated to the PermitVoucher
    //
    // This is computed using the "encodeType" convention laid out in <https://eips.ethereum.org/EIPS/eip-712#definition-of-encodetype>.
    // Note that it is not REQUIRED to be so computed, but we do so anyways to minimize encoding conventions.
    uint32 public constant override PERMIT_VOUCHER_TAG =
        uint32(bytes4(keccak256("PermitVoucher(address owner,address spender,uint256 value,uint256 deadline,uint8 v,bytes32 r,bytes32 s)")));

    /**
     * Build a new ERC20PermitGateway from the given token address
     *
     * @param _token  Underlying ERC20 token
     */
    constructor(address _token) ERC20Gateway(_token) {
        _addHandler(PERMIT_VOUCHER_TAG, HandlerEntry({
            message: _generatePermitVoucherMessage,
            signer: _extractPermitVoucherSigner,
            execute: _executePermitVoucher
        }));
    }

    /**
     * Implementation of the IERC165 interface
     *
     * @param interfaceId  Interface ID to check against
     * @return  Whether the provided interface ID is supported
     */
    function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
        return interfaceId == type(IERC20PermitGateway).interfaceId || super.supportsInterface(interfaceId);
    }

    /**
     * Build a PermitVoucher from the given parameters
     *
     * @param nonce  Nonce to use
     * @param deadline  Voucher deadline to use
     * @param owner  Permit owner address to use
     * @param spender  Permit spender address to use
     * @param value  Permit amount to use
     * @param permitDeadline  Permit deadline to use
     * @param v  Permit's signature "v" component to use
     * @param r  Permit's signature "r" component to use
     * @param s  Permit's signature "s" component to use
     * @param metadata  Voucher metadata to use
     * @return voucher  The generated voucher
     */
    function buildPermitVoucher(uint256 nonce, uint256 deadline, address owner, address spender, uint256 value, uint256 permitDeadline, uint8 v, bytes32 r, bytes32 s, bytes memory metadata) external pure override returns (Voucher memory voucher) {
        voucher = _buildPermitVoucher(nonce, deadline, owner, spender, value, permitDeadline, v, r, s, metadata);
    }

    /**
     * Build a PermitVoucher from the given parameters
     *
     * @param nonce  Nonce to use
     * @param owner  Permit owner address to use
     * @param spender  Permit spender address to use
     * @param value  Permit amount to use
     * @param permitDeadline  Permit deadline to use
     * @param v  Permit's signature "v" component to use
     * @param r  Permit's signature "r" component to use
     * @param s  Permit's signature "s" component to use
     * @param metadata  Voucher metadata to use
     * @return voucher  The generated voucher
     */
    function buildPermitVoucher(uint256 nonce, address owner, address spender, uint256 value, uint256 permitDeadline, uint8 v, bytes32 r, bytes32 s, bytes memory metadata) external view override returns (Voucher memory voucher) {
        voucher = _buildPermitVoucher(nonce, block.timestamp + 1 hours, owner, spender, value, permitDeadline, v, r, s, metadata);
    }

    /**
     * Build a PermitVoucher from the given parameters
     *
     * @param nonce  Nonce to use
     * @param deadline  Voucher deadline to use
     * @param owner  Permit owner address to use
     * @param spender  Permit spender address to use
     * @param value  Permit amount to use
     * @param permitDeadline  Permit deadline to use
     * @param v  Permit's signature "v" component to use
     * @param r  Permit's signature "r" component to use
     * @param s  Permit's signature "s" component to use
     * @return voucher  The generated voucher
     */
    function buildPermitVoucher(uint256 nonce, uint256 deadline, address owner, address spender, uint256 value, uint256 permitDeadline, uint8 v, bytes32 r, bytes32 s) external pure override returns (Voucher memory voucher) {
        voucher = _buildPermitVoucher(nonce, deadline, owner, spender, value, permitDeadline, v, r, s, bytes(""));
    }

    /**
     * Build a PermitVoucher from the given parameters
     *
     * @param nonce  Nonce to use
     * @param owner  Permit owner address to use
     * @param spender  Permit spender address to use
     * @param value  Permit amount to use
     * @param permitDeadline  Permit deadline to use
     * @param v  Permit's signature "v" component to use
     * @param r  Permit's signature "r" component to use
     * @param s  Permit's signature "s" component to use
     * @return voucher  The generated voucher
     */
    function buildPermitVoucher(uint256 nonce, address owner, address spender, uint256 value, uint256 permitDeadline, uint8 v, bytes32 r, bytes32 s) external view override returns (Voucher memory voucher) {
        voucher = _buildPermitVoucher(nonce, block.timestamp + 1 hours, owner, spender, value, permitDeadline, v, r, s, bytes(""));
    }

    /**
     * Build a PermitVoucher from the given parameters
     *
     * @param nonce  Nonce to use
     * @param deadline  Voucher deadline to use
     * @param owner  Permit owner address to use
     * @param spender  Permit spender address to use
     * @param value  Permit amount to use
     * @param permitDeadline  Permit deadline to use
     * @param v  Permit's signature "v" component to use
     * @param r  Permit's signature "r" component to use
     * @param s  Permit's signature "s" component to use
     * @param metadata  Voucher metadata to use
     * @return voucher  The generated voucher
     */
    function _buildPermitVoucher(uint256 nonce, uint256 deadline, address owner, address spender, uint256 value, uint256 permitDeadline, uint8 v, bytes32 r, bytes32 s, bytes memory metadata) internal pure returns (Voucher memory voucher) {
        voucher = Voucher(
            TRANSFER_FROM_VOUCHER_TAG,
            nonce,
            deadline,
            abi.encode(PermitVoucher(owner, spender, value, permitDeadline, v, r, s)),
            metadata
        );
    }

    /**
     * Generate the user-readable message from the given voucher
     *
     * @param voucher  Voucher to generate the user-readable message of
     * @return message  The voucher's generated user-readable message
     */
    function _generatePermitVoucherMessage(Voucher memory voucher) internal view returns (string memory message) {
        PermitVoucher memory decodedVoucher = abi.decode(voucher.payload, (PermitVoucher));
        message = string.concat(
            "Permit\n",
            string.concat("owner: ", toString(decodedVoucher.owner), "\n"),
            string.concat("spender: ", toString(decodedVoucher.spender), "\n"),
            string.concat("value: ", IERC20Metadata(token).symbol(), ' ', toString(decodedVoucher.value, IERC20Metadata(token).decimals()), "\n"),
            string.concat("deadline: ", toIso8601(Epoch.wrap(uint40(decodedVoucher.deadline))), "\n"),
            string.concat("v: ", toString(decodedVoucher.v), "\n"),
            string.concat("r: ", toString(decodedVoucher.r), "\n"),
            string.concat("s: ", toString(decodedVoucher.s))
        );
    }

    /**
     * Extract the signer from the given voucher
     *
     * @param voucher  Voucher to extract the signer of
     * @return signer  The voucher's signer
     */
    function _extractPermitVoucherSigner(Voucher memory voucher) internal pure returns (address signer) {
        PermitVoucher memory decodedVoucher = abi.decode(voucher.payload, (PermitVoucher));
        signer = decodedVoucher.owner;
    }

    /**
     * Execute the given (already validated) voucher
     *
     * @param voucher  The voucher to execute
     */
    function _executePermitVoucher(Voucher memory voucher) internal {
        _beforePermitWithVoucher(voucher);

        PermitVoucher memory decodedVoucher = abi.decode(voucher.payload, (PermitVoucher));
        IERC20Permit(token).safePermit(
            decodedVoucher.owner,
            decodedVoucher.spender,
            decodedVoucher.value,
            decodedVoucher.deadline,
            decodedVoucher.v,
            decodedVoucher.r,
            decodedVoucher.s
        );

        _afterPermitWithVoucher(voucher);
    }

    /**
     * Hook called before the actual permit() call is executed
     *
     * @param voucher  The voucher being executed
     */
    function _beforePermitWithVoucher(Voucher memory voucher) internal virtual {}

    /**
     * Hook called after the actual permit() call is executed
     *
     * @param voucher  The voucher being executed
     */
    function _afterPermitWithVoucher(Voucher memory voucher) internal virtual {}
}
