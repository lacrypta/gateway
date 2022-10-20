// SPDX-License-Identifier: AGPL-3.0-or-later
pragma solidity ^0.8.17;

import {IGateway} from "./IGateway.sol";

interface IERC20Gateway is IGateway {
    /**
     * Retrieve the address of the underlying ERC20 token
     *
     * @return _erc20Token  The address of the underlying ERC20 token
     */
    function token() external view returns (address _erc20Token);

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

    /**
     * Build a TransferFromVoucher from the given parameters
     *
     * @param nonce  Nonce to use
     * @param deadline  Voucher deadline to use
     * @param from  Transfer origin to use
     * @param to  Transfer destination to use
     * @param amount  Transfer amount to use
     * @param metadata  Voucher metadata to use
     * @return voucher  The generated voucher
     */
    function buildTransferFromVoucher(uint256 nonce, uint256 deadline, address from, address to, uint256 amount, bytes calldata metadata) external view returns (Voucher memory voucher);

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
    function buildTransferFromVoucher(uint256 nonce, address from, address to, uint256 amount, bytes calldata metadata) external view returns (Voucher memory voucher);

    /**
     * Build a TransferFromVoucher from the given parameters
     *
     * @param nonce  Nonce to use
     * @param deadline  Voucher deadline to use
     * @param from  Transfer origin to use
     * @param to  Transfer destination to use
     * @param amount  Transfer amount to use
     * @return voucher  The generated voucher
     */
    function buildTransferFromVoucher(uint256 nonce, uint256 deadline, address from, address to, uint256 amount) external view returns (Voucher memory voucher);

    /**
     * Build a TransferFromVoucher from the given parameters
     *
     * @param nonce  Nonce to use
     * @param from  Transfer origin to use
     * @param to  Transfer destination to use
     * @param amount  Transfer amount to use
     * @return voucher  The generated voucher
     */
    function buildTransferFromVoucher(uint256 nonce, address from, address to, uint256 amount) external view returns (Voucher memory voucher);
}
