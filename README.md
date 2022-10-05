# Feeless Payment Gateway

This is [La Crypta](jttps://www.lacrypta.com.ar)'s _feeless payment gateway_.
It provides the building blocks for constructing a MATIC-less payment infrastructure via the usage of _vouchers_.

A _voucher_ is nothing more than a signed request, from an owner, to the infrastructure, of a method call.

Thus, a voucher may indicate something along the lines of _"please transfer this many tokens from this address to this recipient"_.
The infrastructure should then make this voucher public and have someone pay the MATIC cost of _serving_ said voucher.

Of course, one can do this out of the goodness of one's heart, or some form of incentive may be provided.
The current implementation is _agnostic_ to these details, but provides a `metadata` field specifically to separate the voucher serving data (ie. the `payload` field) from the infrastructure policies.

## Anatomy of a Voucher

A voucher consists of the following fields:

- `tag`: a 32-bit number identifying what _kind_ of voucher this is (it is constructed by truncating the keccak of the voucher's type).
- `nonce`: a random 256-bit value, used for collision avoidance and tracking only.
- `deadline`: a point in time up to which this voucher will be considered valid.
- `payload`: an `abi.encode()`-ed payload data, opaque to the main dispatch mechanism, used for serving the call proper.
- `metadata`: an `abi.encode()`-ed metadata data, opaque to the main dispatch mechanism, used for applying policies on the actual serving of the call.

Upon serving a voucher, the `tag` is used by the main gateway implementation to dispatch the call to the actual handler, who's free to interpret the `payload` and `metadata` fields as they see fit.

## Usage

The current implementation consists of:

- `IGateway.sol`/`Gateway.sol`: the abstract base contract for all Gateways, it implements a crude form of voucher [_dynamic dispatch_](https://en.wikipedia.org/wiki/Dynamic_dispatch) by `abi.encode()`-ing and `abi.decode()`-ing the voucher's payload, dispatching based off of the voucher's _tag_.
- `IERC20Gateway.sol`/`ERC20Gateway.sol`: an abstract contract serving the voucher for an ERC20 `transferFrom()` call.
- `IERC20PermitGateway.sol`/`ERC20PermitGateway.sol`: an abstract contract serving the voucher for an ERC20 `permit()` call (with embedded `v/r/s` signature).

Creating a new Gateway capable of dealing with a new voucher type is extremely simple, you merely need to:

1. Create a new contract and inherit from the Gateway of your choice (so as to support ERC20 or ERC20-Permit vouchers as well, or none of them and have a simpler interface).
2. Define the tags your new contract will be handling. This is straightforward and can be done simply by `uint32(bytes4(keccak256(bytes("..."))))`, where `"..."` will be something along the lines of `"MyVoucher(primitiveType1 fieldName1,primitiveType2 fieldName2,...,primitiveTypeN fieldNameN)"`.
3. In your `constructor` call the `_addHandler()` method to register the tag you generated as being handled by using the given methods (three are needed: one to extract a _user-readable_ string from the voucher, another one to determine the signer from the voucher's payload, and yet another one to actually execute the call).

As many tags as desired can be handled within the same contract, since each `_addHandler` call assigns a pair of handling methods to a tag.
