// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

import {
    GatewayFetcher,
    GatewayRequest
} from "@unruggable/gateways/GatewayFetcher.sol";
import {GatewayFetchTarget} from "@unruggable/gateways/GatewayFetchTarget.sol";
import {IGatewayVerifier} from "@unruggable/gateways/IGatewayVerifier.sol";

import {IAddrResolver} from
    "@ens-contracts/resolvers/profiles/IAddrResolver.sol";
import {ITextResolver} from
    "@ens-contracts/resolvers/profiles/ITextResolver.sol";
import {IContentHashResolver} from
    "@ens-contracts/resolvers/profiles/IContentHashResolver.sol";

contract L1Resolver is
    GatewayFetchTarget,
    IAddrResolver,
    ITextResolver,
    IContentHashResolver
{

    using GatewayFetcher for GatewayRequest;

    /// CONSTANTS
    uint256 constant COIN_TYPE_ETH = 60;
    uint256 constant RECORD_VERSIONS_SLOT = 0;
    uint256 constant VERSIONABLE_ADDRESSES_SLOT = 2;
    uint256 constant VERSIONABLE_HASHES_SLOT = 3;
    uint256 constant VERSIONABLE_TEXTS_SLOT = 10;
    uint256 constant PRICE_SLOT = 0;

    /// Contract targets
    address public targetResolver;
    // address public targetRegistrar;
    // address public targetNameWrapper;

    IGatewayVerifier immutable _verifier;

    constructor(IGatewayVerifier verifier, address _target_resolver) 
    // address _target_registrar,
    // address _target_nameWrapper
    {
        _verifier = verifier;
        targetResolver = _target_resolver;
        // targetRegistrar = _target_registrar;
        // targetNameWrapper = _target_nameWrapper;
    }

    function addr(bytes32 node) public view returns (address payable) {
        GatewayRequest memory r = GatewayFetcher.newRequest(1).setTarget(
            targetResolver
        ).setSlot(RECORD_VERSIONS_SLOT).push(node).follow().read().dup().setSlot(
            VERSIONABLE_ADDRESSES_SLOT
        ).follow().push(node).follow().push(COIN_TYPE_ETH).follow().readBytes()
            .setOutput(0);

        fetch(_verifier, r, this.addrCallback.selector);
    }

    function addrCallback(
        bytes[] calldata values,
        uint8,
        bytes calldata
    )
        external
        pure
        returns (address payable)
    {
        return payable(address(bytes20(values[0])));
    }

    function addr(
        bytes32 node,
        uint256 coinType
    )
        public
        view
        returns (bytes memory)
    {
        GatewayRequest memory r = GatewayFetcher.newRequest(1).setTarget(
            targetResolver
        ).setSlot(RECORD_VERSIONS_SLOT).push(node).follow().read().dup().setSlot(
            VERSIONABLE_ADDRESSES_SLOT
        ).follow().push(node).follow().push(coinType).follow().readBytes()
            .setOutput(0);

        fetch(_verifier, r, this.addrCoinCallback.selector);
    }

    function addrCoinCallback(
        bytes[] calldata values,
        uint8,
        bytes calldata
    )
        external
        pure
        returns (bytes memory)
    {
        return values[0];
    }

    function text(
        bytes32 node,
        string memory key
    )
        public
        view
        returns (string memory)
    {
        GatewayRequest memory r = GatewayFetcher.newRequest(1).setTarget(
            targetResolver
        ).setSlot(RECORD_VERSIONS_SLOT).push(node).follow().read().dup().setSlot(
            VERSIONABLE_TEXTS_SLOT
        ).follow().push(node).follow().push(key).follow().readBytes().setOutput(
            0
        );

        fetch(_verifier, r, this.textCallback.selector);
    }

    function textCallback(
        bytes[] calldata values,
        uint8,
        bytes calldata
    )
        external
        pure
        returns (bytes memory)
    {
        return values[0];
    }

    function contenthash(bytes32 node)
        public
        view
        override
        returns (bytes memory)
    {
        GatewayRequest memory r = GatewayFetcher.newRequest(1).setTarget(
            targetResolver
        ).setSlot(RECORD_VERSIONS_SLOT).push(node).follow().read().dup().setSlot(
            VERSIONABLE_HASHES_SLOT
        ).follow().push(node).follow().readBytes().setOutput(0);

        fetch(_verifier, r, this.contenthashCallback.selector);
    }

    function contenthashCallback(
        bytes[] calldata values,
        uint8,
        bytes calldata
    )
        external
        pure
        returns (bytes memory)
    {
        return values[0];
    }

}
