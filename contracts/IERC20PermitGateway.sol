// SPDX-License-Identifier: AGPL-3.0-or-later
pragma solidity ^0.8.17;

import {IGateway} from "./IGateway.sol";

interface IERC20PermitGateway is IGateway {
    /**
     * Retrieve the address of the underlying ERC20 token
     *
     * @return  The address of the underlying ERC20 token
     */
    function token() external view returns (address);

    /**
     * permit() voucher
     *
     * @custom:member owner  The address of the owner of the funds
     * @custom:member spender  The address of the spender being permitted to move the funds
     * @custom:member value  The number of tokens to allow transfer of
     * @custom:member v  The permit's signature "v" value
     * @custom:member r  The permit's signature "r" value
     * @custom:member s  The permit's signature "s" value
     */
    struct PermitVoucher {
        address owner;
        address spender;
        uint256 value;
        uint256 deadline;
        uint8 v;
        bytes32 r;
        bytes32 s;
    }

    /**
     * Return the tag associated to the PermitVoucher voucher itself
     *
     * @return  The tag associated to the PermitVoucher voucher itself
     */
    function PERMIT_VOUCHER_TAG() external view returns (uint32);

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
    function buildPermitVoucher(uint256 nonce, uint256 deadline, address owner, address spender, uint256 value, uint256 permitDeadline, uint8 v, bytes32 r, bytes32 s, bytes calldata metadata) external view returns (Voucher memory voucher);

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
    function buildPermitVoucher(uint256 nonce, address owner, address spender, uint256 value, uint256 permitDeadline, uint8 v, bytes32 r, bytes32 s, bytes calldata metadata) external view returns (Voucher memory voucher);

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
    function buildPermitVoucher(uint256 nonce, uint256 deadline, address owner, address spender, uint256 value, uint256 permitDeadline, uint8 v, bytes32 r, bytes32 s) external view returns (Voucher memory voucher);

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
    function buildPermitVoucher(uint256 nonce, address owner, address spender, uint256 value, uint256 permitDeadline, uint8 v, bytes32 r, bytes32 s) external view returns (Voucher memory voucher);
}
