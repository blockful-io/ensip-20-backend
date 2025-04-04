// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import {Script, console} from "forge-std/Script.sol";
import {IGatewayVerifier} from "@unruggable/gateways/IGatewayVerifier.sol";
import {L1Resolver} from "../../src/optimism/L1Resolver.sol";

contract OPResolverScript is Script {

    function run() external {
        IGatewayVerifier verifier =
            IGatewayVerifier(0x5F1681D608e50458D96F43EbAb1137bA1d2A2E4D);

        vm.broadcast();
        new L1Resolver(verifier, 0x3fb3230d65DA8F2Ce71B1b7c5C9E56bdFfC2c40a);
    }

}
