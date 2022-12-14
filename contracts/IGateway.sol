// SPDX-License-Identifier: AGPL-3.0-or-later
pragma solidity ^0.8.17;

interface IGateway {
    /**
     * Raised upon encountering a voucher that is not yet active
     *
     * @param validSince  The minimum block timestamp this voucher will be valid since
     */
    error NotYetActive(uint256 validSince);

    /**
     * Raised upon encountering a voucher that has already expired
     *
     * @param validUntil  The maximum block timestamp this voucher was valid until
     */
    error Expired(uint256 validUntil);

    /**
     * Raised upon encountering an already served voucher
     *
     */
    error AlreadyServed();

    /**
     * Raised upon encountering a voucher with an invalid signature
     *
     */
    error InvalidSignature();

    /**
     * Voucher --- tagged union used for specific vouchers' implementation
     *
     * @custom:member tag  An integer representing the type of voucher this particular voucher is
     * @custom:member nonce  The voucher nonce to use
     * @custom:member validSince  The minimum block timestamp this voucher is valid since
     * @custom:member validUntil  The maximum block timestamp this voucher is valid until
     * @custom:member payload  Actual abi.encode()-ed payload (used for serving the call proper)
     * @custom:member metadata  Additional abi.encode()-ed metadata (used for administrative tasks)
     */
    struct Voucher {
        uint32 tag;
        //
        uint256 nonce;
        uint256 validSince;
        uint256 validUntil;
        //
        bytes payload;
        bytes metadata;
    }

    /**
     * Emitted upon a voucher being served
     *
     * @param voucherHash  The voucher hash served
     * @param delegate  The delegate serving the voucher
     */
    event VoucherServed(bytes32 indexed voucherHash, address delegate);

    /**
     * Return the typehash associated to the Gateway Voucher itself
     *
     * @return  The typehash associated to the gateway Voucher itself
     */
    function VOUCHER_TYPEHASH() external view returns (bytes32);

    /**
     * Determine whether the given voucher hash has been already served
     *
     * @param voucherHash  The voucher hash to check
     * @return served  True whenever the given voucher hash has already been served
     */
    function voucherServed(bytes32 voucherHash) external view returns (bool served);

    /**
     * Return the voucher hash associated to the given voucher
     *
     * @param voucher  The voucher to retrieve the hash for
     * @return voucherHash  The voucher hash associated to the given voucher
     */
    function hashVoucher(Voucher calldata voucher) external view returns (bytes32 voucherHash);

    /**
     * Return the string representation to be signed for a given Voucher
     *
     * @param voucher  The voucher to stringify
     * @return voucherString  The string representation to be signed of the given voucher
     */
    function stringifyVoucher(Voucher calldata voucher) external view returns (string memory voucherString);

    /**
     * Validate the given voucher against the given signature, by the given signer
     *
     * @param voucher  The voucher to validate
     * @param signature  The associated voucher signature
     */
    function validateVoucher(Voucher calldata voucher, bytes memory signature) external view;

    /**
     * Validate the given voucher against the given signature, by the given signer
     *
     * @param voucher  The voucher to validate
     * @param r  The "r" component of the associated voucher signature
     * @param s  The "s" component of the associated voucher signature
     * @param v  The "v" component of the associated voucher signature
     */
    function validateVoucher(Voucher calldata voucher, bytes32 r, bytes32 s, uint8 v) external view;

    /**
     * Serve the given voucher, by forwarding to the appropriate handler for the voucher's tag
     *
     * @param voucher  The voucher to serve
     * @param signature  The associated voucher signature
     * @custom:emit  VoucherServed
     */
    function serveVoucher(Voucher calldata voucher, bytes calldata signature) external;

    /**
     * Serve the given voucher, by forwarding to the appropriate handler for the voucher's tag
     *
     * @param voucher  The voucher to serve
     * @param r  The "r" component of the associated voucher signature
     * @param s  The "s" component of the associated voucher signature
     * @param v  The "v" component of the associated voucher signature
     * @custom:emit  VoucherServed
     */
    function serveVoucher(Voucher calldata voucher, bytes32 r, bytes32 s, uint8 v) external;
}
