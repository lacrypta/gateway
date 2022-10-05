// SPDX-License-Identifier: AGPL-3.0-or-later
pragma solidity ^0.8.17;

import {IGateway} from "./IGateway.sol";

interface IERC20Gateway is IGateway {
    /**
     * Retrieve the address of the underlying ERC20 token
     *
     * @return  The address of the underlying ERC20 token
     */
    function token() external view returns (address);

    /**
     * transferFrom() voucher
     *
     * @custom:member from  The address from which to transfer funds
     * @custom:member to  The address to which to transfer funds
     * @custom:member amount  The number of tokens to transfer
     */
    struct TransferFromVoucher {
        address from;
        address to;
        uint256 amount;
    }

    /**
     * Return the tag associated to the TransferFromVoucher voucher itself
     *
     * @return  The tag associated to the TransferFromVoucher voucher itself
     */
    function TRANSFER_FROM_VOUCHER_TAG() external view returns (uint32);
}
