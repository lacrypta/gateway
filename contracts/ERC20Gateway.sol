// SPDX-License-Identifier: AGPL-3.0-or-later
pragma solidity ^0.8.17;

import {IERC20} from "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import {IERC20Metadata} from "@openzeppelin/contracts/token/ERC20/extensions/IERC20Metadata.sol";
import {SafeERC20} from "@openzeppelin/contracts/token/ERC20/utils/SafeERC20.sol";

import {Gateway} from "./Gateway.sol";
import {IERC20Gateway} from "./IERC20Gateway.sol";

import {ToString} from "./ToString.sol";

abstract contract ERC20Gateway is Gateway, IERC20Gateway {
    using SafeERC20 for IERC20;
    using ToString for address;
    using ToString for uint256;

    // address of the underlying ERC20 token
    address internal immutable _token;

    // Tag associated to the TransferFromVoucher
    //
    // This is computed using the "encodeType" convention laid out in <https://eips.ethereum.org/EIPS/eip-712#definition-of-encodetype>.
    // Note that it is not REQUIRED to be so computed, but we do so anyways to minimize encoding conventions.
    uint32 public constant TRANSFER_FROM_VOUCHER_TAG =
        uint32(bytes4(keccak256("TransferFromVoucher(address from,address to,uint256 amount)")));

    /**
     * Build a new ERC20Gateway from the given token address
     *
     * @param theToken  Underlying ERC20 token
     */
    constructor(address theToken) {
        _token = theToken;
        _addHandler(TRANSFER_FROM_VOUCHER_TAG, HandlerEntry({
            message: _generateTransferFromVoucherMessage,
            signer: _extractTransferFromVoucherSigner,
            execute: _executeTransferFromVoucher
        }));
    }

    /**
     * Retrieve the address of the underlying ERC20 token
     *
     * @return _erc20Token  The address of the underlying ERC20 token
     */
    function token() external view virtual returns (address _erc20Token) {
        _erc20Token = _token;
    }

    /**
     * Implementation of the IERC165 interface
     *
     * @param interfaceId  Interface ID to check against
     * @return  Whether the provided interface ID is supported
     */
    function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
        return interfaceId == type(IERC20Gateway).interfaceId || super.supportsInterface(interfaceId);
    }

    /**
     * Build a TransferFromVoucher from the given parameters
     *
     * @param nonce  Nonce to use
     * @param validSince  Voucher validSince to use
     * @param validUntil  Voucher validUntil to use
     * @param from  Transfer origin to use
     * @param to  Transfer destination to use
     * @param amount  Transfer amount to use
     * @param metadata  Voucher metadata to use
     * @return voucher  The generated voucher
     */
    function buildTransferFromVoucher(uint256 nonce, uint256 validSince, uint256 validUntil, address from, address to, uint256 amount, bytes calldata metadata) external pure override returns (Voucher memory voucher) {
        voucher = _buildTransferFromVoucher(nonce, validSince, validUntil, from, to, amount, metadata);
    }

    /**
     * Build a TransferFromVoucher from the given parameters
     *
     * @param nonce  Nonce to use
     * @param validUntil  Voucher validUntil to use
     * @param from  Transfer origin to use
     * @param to  Transfer destination to use
     * @param amount  Transfer amount to use
     * @param metadata  Voucher metadata to use
     * @return voucher  The generated voucher
     */
    function buildTransferFromVoucher(uint256 nonce, uint256 validUntil, address from, address to, uint256 amount, bytes calldata metadata) external view override returns (Voucher memory voucher) {
        voucher = _buildTransferFromVoucher(nonce, block.timestamp, validUntil, from, to, amount, metadata);
    }

    /**
     * Build a TransferFromVoucher from the given parameters
     *
     * @param nonce  Nonce to use
     * @param from  Transfer origin to use
     * @param to  Transfer destination to use
     * @param amount  Transfer amount to use
     * @param metadata  Voucher metadata to use
     * @return voucher  The generated voucher
     */
    function buildTransferFromVoucher(uint256 nonce, address from, address to, uint256 amount, bytes calldata metadata) external view override returns (Voucher memory voucher) {
        voucher = _buildTransferFromVoucher(nonce, block.timestamp, block.timestamp + 1 hours, from, to, amount, metadata);
    }

    /**
     * Build a TransferFromVoucher from the given parameters
     *
     * @param nonce  Nonce to use
     * @param validSince  Voucher validSince to use
     * @param validUntil  Voucher validUntil to use
     * @param from  Transfer origin to use
     * @param to  Transfer destination to use
     * @param amount  Transfer amount to use
     * 0@return voucher  The generated voucher
     */
    function buildTransferFromVoucher(uint256 nonce, uint256 validSince, uint256 validUntil, address from, address to, uint256 amount) external pure returns (Voucher memory voucher) {
        voucher = _buildTransferFromVoucher(nonce, validSince, validUntil, from, to, amount, bytes(""));
    }

    /**
     * Build a TransferFromVoucher from the given parameters
     *
     * @param nonce  Nonce to use
     * @param validUntil  Voucher validUntil to use
     * @param from  Transfer origin to use
     * @param to  Transfer destination to use
     * @param amount  Transfer amount to use
     * @return voucher  The generated voucher
     */
    function buildTransferFromVoucher(uint256 nonce, uint256 validUntil, address from, address to, uint256 amount) external view override returns (Voucher memory voucher) {
        voucher = _buildTransferFromVoucher(nonce, block.timestamp, validUntil, from, to, amount, bytes(""));
    }

    /**
     * Build a TransferFromVoucher from the given parameters
     *
     * @param nonce  Nonce to use
     * @param from  Transfer origin to use
     * @param to  Transfer destination to use
     * @param amount  Transfer amount to use
     * @return voucher  The generated voucher
     */
    function buildTransferFromVoucher(uint256 nonce, address from, address to, uint256 amount) external view override returns (Voucher memory voucher) {
        voucher = _buildTransferFromVoucher(nonce, block.timestamp, block.timestamp + 1 hours, from, to, amount, bytes(""));
    }

    /**
     * Build a Voucher from the given parameters
     *
     * @param nonce  Nonce to use
     * @param validSince  Voucher validSince to use
     * @param validUntil  Voucher validUntil to use
     * @param from  Transfer origin to use
     * @param to  Transfer destination to use
     * @param amount  Transfer amount to use
     * @param metadata  Voucher metadata to use
     * @return voucher  The generated voucher
     */
    function _buildTransferFromVoucher(uint256 nonce, uint256 validSince, uint256 validUntil, address from, address to, uint256 amount, bytes memory metadata) internal pure returns (Voucher memory voucher) {
        voucher = Voucher(
            TRANSFER_FROM_VOUCHER_TAG,
            nonce,
            validSince,
            validUntil,
            abi.encode(TransferFromVoucher(from, to, amount)),
            metadata
        );
    }

    /**
     * Generate the user-readable message from the given voucher
     *
     * @param voucher  Voucher to generate the user-readable message of
     * @return message  The voucher's generated user-readable message
     */
    function _generateTransferFromVoucherMessage(Voucher calldata voucher) internal view returns (string memory message) {
        TransferFromVoucher memory decodedVoucher = abi.decode(voucher.payload, (TransferFromVoucher));
        message = string.concat(
            "TransferFrom\n",
            string.concat("from: ", decodedVoucher.from.toString(), "\n"),
            string.concat("to: ", decodedVoucher.to.toString(), "\n"),
            string.concat("amount: ", IERC20Metadata(_token).symbol(), " ", decodedVoucher.amount.toString(IERC20Metadata(_token).decimals()))
        );
    }

    /**
     * Extract the signer from the given voucher
     *
     * @param voucher  Voucher to extract the signer of
     * @return signer  The voucher's signer
     */
    function _extractTransferFromVoucherSigner(Voucher calldata voucher) internal pure returns (address signer) {
        TransferFromVoucher memory decodedVoucher = abi.decode(voucher.payload, (TransferFromVoucher));
        signer = decodedVoucher.from;
    }

    /**
     * Execute the given (already validated) voucher
     *
     * @param voucher  The voucher to execute
     */
    function _executeTransferFromVoucher(Voucher calldata voucher) internal {
        _beforeTransferFromWithVoucher(voucher);

        TransferFromVoucher memory decodedVoucher = abi.decode(voucher.payload, (TransferFromVoucher));
        IERC20(_token).safeTransferFrom(decodedVoucher.from, decodedVoucher.to, decodedVoucher.amount);

        _afterTransferFromWithVoucher(voucher);
    }

    /**
     * Hook called before the actual transferFrom() call is executed
     *
     * @param voucher  The voucher being executed
     */
    function _beforeTransferFromWithVoucher(Voucher calldata voucher) internal virtual {}

    /**
     * Hook called after the actual transferFrom() call is executed
     *
     * @param voucher  The voucher being executed
     */
    function _afterTransferFromWithVoucher(Voucher calldata voucher) internal virtual {}
}
