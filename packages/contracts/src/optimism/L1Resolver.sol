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
        GatewayRequest memory r = GatewayFetcher.newRequest(2).setTarget(
            targetResolver
        ).setSlot(RECORD_VERSIONS_SLOT).push(node).follow().read().setOutput(0)
            .pushOutput(0).setSlot(VERSIONABLE_ADDRESSES_SLOT).follow().push(node)
            .follow().push(COIN_TYPE_ETH).follow().readBytes().setOutput(1);

        string[] memory urls = new string[](0);
        fetch(_verifier, r, this.addrCallback.selector, abi.encode(true), urls);
    }

    function addrCallback(
        bytes[] calldata values,
        uint8
    )
        external
        pure
        returns (bytes memory)
    {
        return abi.encode(address(bytes20(values[1])));
    }

    function addr(
        bytes32 node,
        uint256 coinType
    )
        internal
        view
        returns (bytes memory)
    {
        GatewayRequest memory r = GatewayFetcher.newRequest(2).setTarget(
            targetResolver
        ).setSlot(RECORD_VERSIONS_SLOT).push(node).follow().read().setOutput(0)
            .pushOutput(0).setSlot(VERSIONABLE_ADDRESSES_SLOT).follow().push(node)
            .follow().push(coinType).follow().readBytes().setOutput(1);

        string[] memory urls = new string[](0);
        fetch(_verifier, r, this.addrCallback.selector, abi.encode(true), urls);
    }

    function trimLeadingZeros(bytes memory data)
        public
        pure
        returns (bytes memory)
    {
        uint256 startIndex = 0;
        uint256 length = data.length;
        // Find the first non-zero byte
        while (startIndex < length && data[startIndex] == 0) startIndex++;
        // If all bytes are zero, return an empty bytes array
        if (startIndex == length) return new bytes(0);
        // Copy the trimmed data into a new bytes array
        bytes memory trimmed = new bytes(length - startIndex);
        for (uint256 i = startIndex; i < length; i++) {
            trimmed[i - startIndex] = data[i];
        }
        return trimmed;
    }

    function addrCoinCallback(
        bytes[] calldata values,
        uint8
    )
        external
        pure
        returns (bytes memory)
    {
        return abi.encode(values[1]);
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

    function contenthash(bytes32 node) public view returns (bytes memory) {
        // Create a gateway request to read profile data
        GatewayRequest memory r = GatewayFetcher.newRequest(2).setTarget(
            targetResolver
        ).setSlot(1).push(node).follow().read()
            // Start at slot 1 (nodeProfiles)
            // Read the profileId for the node
            .setOutput(0);
        // Push the profileId back onto the stack
        r = r.pushOutput(0).setSlot(0).follow().offset(5).readBytes()
            // Get the Profile assigned to that ID
            // Offset to the contenthash record
            .setOutput(1);

        // Fetch the data using the gateway
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
        return values[1];
    }

}
