// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import {IGatewayVerifier} from "@unruggable/gateways/IGatewayVerifier.sol";
import {L1Resolver} from "../../../src/optimism/L1Resolver.sol";
import {DeployHelper} from "../../DeployHelper.sol";

contract OPResolverScript is DeployHelper {

    function run() external {
        IGatewayVerifier verifier =
            IGatewayVerifier(0x5F1681D608e50458D96F43EbAb1137bA1d2A2E4D);

        address resolver =
            getContractAddress("L1Resolver", "PublicResolver", 11155420);
        address registrar = getContractAddress("SubdomainController", 11155420);
        string memory metadataUrl = vm.envString("METADATA_URL");

        vm.broadcast();
        new L1Resolver(
            verifier, resolver, registrar, block.chainid, metadataUrl
        );
    }

}
