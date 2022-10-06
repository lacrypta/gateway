// SPDX-License-Identifier: AGPL-3.0-or-later
pragma solidity ^0.8.17;

import {IERC20} from "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import {IERC20Metadata} from "@openzeppelin/contracts/token/ERC20/extensions/IERC20Metadata.sol";
import {SafeERC20} from "@openzeppelin/contracts/token/ERC20/utils/SafeERC20.sol";

import {Gateway} from "./Gateway.sol";
import {IERC20Gateway} from "./IERC20Gateway.sol";

import "./Strings.sol";

abstract contract ERC20Gateway is Gateway, IERC20Gateway {
    using SafeERC20 for IERC20;

    // address of the underlying ERC20 token
    address public immutable override token;

    // Tag associated to the TransferFromVoucher
    //
    // This is computed using the "encodeType" convention laid out in <https://eips.ethereum.org/EIPS/eip-712#definition-of-encodetype>.
    // Note that it is not REQUIRED to be so computed, but we do so anyways to minimize encoding conventions.
    uint32 public constant TRANSFER_FROM_VOUCHER_TAG =
        uint32(bytes4(keccak256("TransferFromVoucher(address from,address to,uint256 amount)")));

    /**
     * Build a new ERC20Gateway from the given token address
     *
     * @param _token  Underlying ERC20 token
     */
    constructor(address _token) {
        token = _token;
        _addHandler(TRANSFER_FROM_VOUCHER_TAG, HandlerEntry({
            message: _generateTransferFromVoucherMessage,
            signer: _extractTransferFromVoucherSigner,
            execute: _executeTransferFromVoucher
        }));
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
     * Generate the user-readable message from the given voucher
     *
     * @param voucher  Voucher to generate the user-readable message of
     * @return message  The voucher's generated user-readable message
     */
    function _generateTransferFromVoucherMessage(Voucher memory voucher) internal view returns (string memory message) {
        TransferFromVoucher memory decodedVoucher = abi.decode(voucher.payload, (TransferFromVoucher));
        message = string.concat(
            "TransferFrom", "\n",
            "from: ", toString(decodedVoucher.from), "\n",
            "to: ", toString(decodedVoucher.to), "\n",
            "amount: ", IERC20Metadata(token).symbol(), ' ', toString(decodedVoucher.amount, IERC20Metadata(token).decimals())
        );
    }

    /**
     * Extract the signer from the given voucher
     *
     * @param voucher  Voucher to extract the signer of
     * @return signer  The voucher's signer
     */
    function _extractTransferFromVoucherSigner(Voucher memory voucher) internal pure returns (address signer) {
        TransferFromVoucher memory decodedVoucher = abi.decode(voucher.payload, (TransferFromVoucher));
        signer = decodedVoucher.from;
    }

    /**
     * Execute the given (already validated) voucher
     *
     * @param voucher  The voucher to execute
     */
    function _executeTransferFromVoucher(Voucher memory voucher) internal {
        _beforeTransferFromWithVoucher(voucher);

        TransferFromVoucher memory decodedVoucher = abi.decode(voucher.payload, (TransferFromVoucher));
        IERC20(token).safeTransferFrom(decodedVoucher.from, decodedVoucher.to, decodedVoucher.amount);

        _afterTransferFromWithVoucher(voucher);
    }

    /**
     * Hook called before the actual transferFrom() call is executed
     *
     * @param voucher  The voucher being executed
     */
    function _beforeTransferFromWithVoucher(Voucher memory voucher) internal virtual {}

    /**
     * Hook called after the actual transferFrom() call is executed
     *
     * @param voucher  The voucher being executed
     */
    function _afterTransferFromWithVoucher(Voucher memory voucher) internal virtual {}
}
