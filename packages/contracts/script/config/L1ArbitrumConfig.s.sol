// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import {Script, console} from "forge-std/Script.sol";

import {ENSRegistry} from "@ens-contracts/registry/ENSRegistry.sol";
import {IRollupCore} from "@nitro-contracts/src/rollup/IRollupCore.sol";
import {ReverseRegistrar} from
    "@ens-contracts/reverseRegistrar/ReverseRegistrar.sol";
import {NameWrapper} from "@ens-contracts/wrapper/NameWrapper.sol";
import {UniversalResolver} from "@ens-contracts/utils/UniversalResolver.sol";

import {ENSHelper} from "../ENSHelper.sol";
import {DeployHelper} from "../DeployHelper.sol";

contract L1ArbitrumConfig is Script, ENSHelper, DeployHelper {

    NetworkConfig public activeNetworkConfig;

    struct NetworkConfig {
        ENSRegistry registry;
        IRollupCore rollup;
        uint256 targetChainId;
        address l2Resolver;
        address l2Registrar;
        address l2NameWrapper;
    }

    constructor(uint256 chainId, address sender) {
        if (chainId == 11155111) activeNetworkConfig = _getSepoliaConfig();
        else if (chainId == 1) activeNetworkConfig = _getMainnetConfig();
        else activeNetworkConfig = _getAnvilConfig(sender);
    }

    function _getMainnetConfig() private view returns (NetworkConfig memory) {
        return NetworkConfig({
            registry: ENSRegistry(0x00000000000C2E074eC69A0dFb2997BA6C7d2e1e),
            rollup: IRollupCore(0x5eF0D09d1E6204141B4d37530808eD19f60FBa35),
            targetChainId: 42161,
            l2Resolver: getContractAddress(
                "L2ArbitrumResolver", "PublicResolver", 42161
            ),
            l2Registrar: getContractAddress("SubdomainController", 42161),
            l2NameWrapper: getContractAddress("NameWrapper", 42161)
        });
    }

    function _getSepoliaConfig() private view returns (NetworkConfig memory) {
        return NetworkConfig({
            registry: ENSRegistry(0x00000000000C2E074eC69A0dFb2997BA6C7d2e1e),
            rollup: IRollupCore(0xd80810638dbDF9081b72C1B33c65375e807281C8),
            targetChainId: 421614,
            l2Resolver: getContractAddress(
                "L2ArbitrumResolver", "PublicResolver", 421614
            ),
            l2Registrar: getContractAddress("SubdomainController", 421614),
            l2NameWrapper: getContractAddress("NameWrapper", 421614)
        });
    }

    function _getAnvilConfig(address sender)
        private
        returns (NetworkConfig memory)
    {
        if (address(activeNetworkConfig.registry) != address(0)) {
            return activeNetworkConfig;
        }

        vm.startBroadcast(sender);
        ENSRegistry registry = new ENSRegistry();

        string[] memory urls = new string[](0);
        UniversalResolver universalResolver =
            new UniversalResolver(address(registry), urls);

        ReverseRegistrar registrar = new ReverseRegistrar(registry);

        // .reverse
        registry.setSubnodeOwner(rootNode, labelhash("reverse"), sender);
        // addr.reverse
        registry.setSubnodeOwner(
            namehash("reverse"), labelhash("addr"), address(registrar)
        );

        // .reverse
        registry.setSubnodeOwner(rootNode, labelhash("eth"), sender);

        vm.stopBroadcast();

        console.log("Registry deployed at", address(registry));
        console.log("UniversalResolver deployed at", address(universalResolver));

        return NetworkConfig({
            registry: registry,
            rollup: IRollupCore(0x3fC2B5464aD073036fEA6e396eC2Ac0406A3b058),
            targetChainId: 31337,
            l2Resolver: getContractAddress(
                "L2ArbitrumResolver", "PublicResolver", 31337
            ),
            l2Registrar: getContractAddress(
                "L2ArbitrumResolver", "SubdomainController", 31337
            ),
            l2NameWrapper: getContractAddress("NameWrapper", 31337)
        });
    }

}
