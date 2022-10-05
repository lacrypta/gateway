// SPDX-License-Identifier: AGPL-3.0-or-later
pragma solidity ^0.8.17;

import {IERC165} from "@openzeppelin/contracts/utils/introspection/IERC165.sol";
import {IERC20Permit} from "@openzeppelin/contracts/token/ERC20/extensions/draft-IERC20Permit.sol";

import {ERC20Gateway} from "./ERC20Gateway.sol";
import {IERC20PermitGateway} from "./IERC20PermitGateway.sol";

import {Strings} from "./Strings.sol";

abstract contract ERC20PermitGateway is ERC20Gateway, IERC20PermitGateway {
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
     * Generate the user-readable message from the given voucher
     *
     * @param voucher  Voucher to generate the user-readable message of
     * @return message  The voucher's generated user-readable message
     */
    function _generatePermitVoucherMessage(Voucher memory voucher) private pure returns (string memory message) {
        PermitVoucher memory decodedVoucher = abi.decode(voucher.payload, (PermitVoucher));
        message = string.concat(
            "Permit", "\n",
            "owner: ", Strings.toString(decodedVoucher.owner), "\n",
            "spender: ", Strings.toString(decodedVoucher.spender), "\n",
            "value: ", Strings.toString(decodedVoucher.value), "\n",
            "deadline: ", Strings.toIso8601(Strings.Epoch.wrap(decodedVoucher.deadline)), "\n",
            "v: ", Strings.toString(decodedVoucher.v), "\n",
            "r: ", Strings.toString(decodedVoucher.r), "\n",
            "s: ", Strings.toString(decodedVoucher.s)
        );
    }

    /**
     * Extract the signer from the given voucher
     *
     * @param voucher  Voucher to extract the signer of
     * @return signer  The voucher's signer
     */
    function _extractPermitVoucherSigner(Voucher memory voucher) private pure returns (address signer) {
        PermitVoucher memory decodedVoucher = abi.decode(voucher.payload, (PermitVoucher));
        signer = decodedVoucher.owner;
    }

    /**
     * Execute the given (already validated) voucher
     *
     * @param voucher  The voucher to execute
     */
    function _executePermitVoucher(Voucher memory voucher) private {
        _beforePermitWithVoucher(voucher);

        PermitVoucher memory decodedVoucher = abi.decode(voucher.payload, (PermitVoucher));
        IERC20Permit(token).permit(
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
