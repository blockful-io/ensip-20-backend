// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

import {
    GatewayFetcher,
    GatewayRequest
} from "@unruggable/gateways/GatewayFetcher.sol";
import {GatewayFetchTarget} from "@unruggable/gateways/GatewayFetchTarget.sol";
import {IGatewayVerifier} from "@unruggable/gateways/IGatewayVerifier.sol";
import {AddrResolver} from "@ens-contracts/resolvers/profiles/AddrResolver.sol";
import {IAddrResolver} from
    "@ens-contracts/resolvers/profiles/IAddrResolver.sol";
import {IAddressResolver} from
    "@ens-contracts/resolvers/profiles/IAddressResolver.sol";
import {TextResolver} from "@ens-contracts/resolvers/profiles/TextResolver.sol";
import {ContentHashResolver} from
    "@ens-contracts/resolvers/profiles/ContentHashResolver.sol";
import {IMulticallable} from "@ens-contracts/resolvers/IMulticallable.sol";
import {IERC165} from "@openzeppelin/contracts/utils/introspection/IERC165.sol";
import {IExtendedResolver} from
    "@ens-contracts/resolvers/profiles/IExtendedResolver.sol";

import {
    OffchainRegister,
    RegisterRequest
} from "../interfaces/WildcardWriting.sol";
import {OperationRouter} from "../interfaces/OperationRouter.sol";
import {ENSIP16} from "../ENSIP16.sol";

contract L1Resolver is
    IERC165,
    GatewayFetchTarget,
    IExtendedResolver,
    AddrResolver,
    TextResolver,
    ContentHashResolver,
    IMulticallable,
    OperationRouter,
    OffchainRegister,
    ENSIP16
{

    using GatewayFetcher for GatewayRequest;

    /// CONSTANTS
    uint256 constant COIN_TYPE_ETH = 60;
    uint256 constant RECORD_VERSIONS_SLOT = 0;
    uint256 constant VERSIONABLE_ADDRESSES_SLOT = 2;
    uint256 constant VERSIONABLE_HASHES_SLOT = 3;
    uint256 constant VERSIONABLE_TEXTS_SLOT = 10;
    uint256 constant PRICE_SLOT = 0;

    // Contract targets
    address public targetResolver;
    address public targetRegistrar;
    // id of chain that is storing the domains
    uint256 public immutable chainId;

    IGatewayVerifier immutable _verifier;

    constructor(
        IGatewayVerifier verifier,
        address _targetResolver,
        address _targetRegistrar,
        uint256 _chainId,
        string memory _metadataUrl
    )
        ENSIP16(_metadataUrl)
    {
        chainId = _chainId;

        _verifier = verifier;
        targetResolver = _targetResolver;
        targetRegistrar = _targetRegistrar;
    }

    function isAuthorised(bytes32 /*node*/ )
        internal
        pure
        override
        returns (bool)
    {
        return true;
    }

    /* EIP Operation Router */

    /**
     * @notice Validates and processes write parameters for deferred storage mutations
     * @param data The encoded data to be written
     * @dev This function reverts with OperationHandledOnchain error to indicate L2 deferral
     */
    function getOperationHandler(bytes calldata data) public view override {
        bytes4 selector = bytes4(data);

        if (selector == OffchainRegister.register.selector) {
            _offChainStorage(targetRegistrar);
        }

        if (
            selector == bytes4(keccak256("setAddr(bytes32,address)"))
                || selector == bytes4(keccak256("setAddr(bytes32,uint256,bytes)"))
                || selector == TextResolver.setText.selector
                || selector == ContentHashResolver.setContenthash.selector
                || selector == IMulticallable.multicall.selector
                || selector == IMulticallable.multicallWithNodeCheck.selector
        ) _offChainStorage(targetResolver);

        revert FunctionNotSupported();
    }

    function resolve(
        bytes calldata, /* name */
        bytes calldata data
    )
        external
        view
        returns (bytes memory result)
    {
        bytes4 selector = bytes4(data);

        if (selector == IAddrResolver.addr.selector) {
            bytes32 node = abi.decode(data[4:], (bytes32));
            addr(node);
        }
        if (selector == IAddressResolver.addr.selector) {
            (bytes32 node, uint256 cointype) =
                abi.decode(data[4:], (bytes32, uint256));
            return addr(node, cointype);
        }
        if (selector == TextResolver.text.selector) {
            (bytes32 node, string memory key) =
                abi.decode(data[4:], (bytes32, string));
            return bytes(text(node, key));
        }
        if (selector == ContentHashResolver.contenthash.selector) {
            bytes32 node = abi.decode(data[4:], (bytes32));
            return contenthash(node);
        }
        if (selector == this.getOperationHandler.selector) {
            (bytes memory _data) = abi.decode(data[4:], (bytes));
            this.getOperationHandler(_data);
        }
    }

    function register(RegisterRequest calldata) external payable {
        getOperationHandler(msg.data);
    }

    function registerParams(
        bytes calldata,
        uint256
    )
        external
        view
        returns (RegisterParams memory)
    {
        getOperationHandler(msg.data);
    }

    /* ERC-7884 */

    /**
     * @notice Builds an OperationHandledOnchain error.
     */
    function _offChainStorage(address target) internal view {
        revert OperationHandledOnchain(chainId, target);
    }

    function setAddr(
        bytes32, /* name */
        address /* a */
    )
        external
        view
        override
    {
        _offChainStorage(targetResolver);
    }

    function addr(bytes32 node)
        public
        view
        override
        returns (address payable)
    {
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

    function setAddr(
        bytes32, /* name */
        uint256, /* coinType */
        bytes memory /* a */
    )
        public
        view
        override
    {
        _offChainStorage(targetResolver);
    }

    function addr(
        bytes32 node,
        uint256 coinType
    )
        public
        view
        override
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
        return abi.encode(values[0]);
    }

    function setText(
        bytes32, /* name */
        string calldata, /* key */
        string calldata /* value */
    )
        external
        view
        override
    {
        _offChainStorage(targetResolver);
    }

    function text(
        bytes32 node,
        string memory key
    )
        public
        view
        override
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
        return abi.encode(string(values[0]));
    }

    function setContenthash(
        bytes32, /* name */
        bytes calldata /* hash */
    )
        external
        view
        override
    {
        _offChainStorage(targetResolver);
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

    function multicall(bytes[] calldata /* data */ )
        external
        view
        returns (bytes[] memory)
    {
        _offChainStorage(targetResolver);
    }

    function multicallWithNodeCheck(
        bytes32, /* nodehash */
        bytes[] calldata /* data */
    )
        external
        view
        returns (bytes[] memory)
    {
        _offChainStorage(targetResolver);
    }

    /* ERC-165 */

    function supportsInterface(bytes4 interfaceID)
        public
        view
        override(ENSIP16, IERC165, AddrResolver, TextResolver, ContentHashResolver)
        returns (bool)
    {
        return interfaceID == type(OperationRouter).interfaceId
            || interfaceID == type(IERC165).interfaceId
            || interfaceID == type(ENSIP16).interfaceId
            || interfaceID == type(AddrResolver).interfaceId
            || interfaceID == type(TextResolver).interfaceId
            || interfaceID == type(ContentHashResolver).interfaceId
            || interfaceID == type(IMulticallable).interfaceId
            || interfaceID == type(OffchainRegister).interfaceId
            || interfaceID == type(IExtendedResolver).interfaceId
            || super.supportsInterface(interfaceID);
    }

}
