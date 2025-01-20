// SPDX-License-Identifier: MIT
pragma solidity ^0.8.17;

import {INameWrapper} from "@ens-contracts/wrapper/INameWrapper.sol";
import {Resolver} from "@ens-contracts/resolvers/Resolver.sol";
import {BytesUtils} from "@ens-contracts/utils/BytesUtils.sol";
import {IERC165} from "@openzeppelin/contracts/utils/introspection/IERC165.sol";

import {ENSHelper} from "../script/ENSHelper.sol";
import {
    OffchainRegister,
    OffchainRegisterParams
} from "./interfaces/WildcardWriting.sol";

contract SubdomainController is
    IERC165,
    OffchainRegister,
    OffchainRegisterParams,
    ENSHelper
{

    using BytesUtils for bytes;

    uint256 public price;
    uint256 public commitTime;
    INameWrapper nameWrapper;

    constructor(
        address _nameWrapperAddress,
        uint256 _price,
        uint256 _commitTime
    ) {
        commitTime = _commitTime;
        price = _price;
        nameWrapper = INameWrapper(_nameWrapperAddress);
    }

    function registerParams(
        bytes calldata, /* name */
        uint256 /* duration */
    )
        external
        view
        returns (uint256, uint256, bytes memory)
    {
        return (price, commitTime, "");
    }

    function register(
        bytes calldata name,
        address owner,
        uint256 duration,
        bytes32, /* secret */
        address resolver,
        bytes[] calldata data,
        bool, /* reverseRecord */
        uint16 fuses,
        bytes memory /* extraData */
    )
        external
        payable
        override
    {
        bytes32 node = name.namehash(0);
        string memory label = _getLabel(name);

        (, uint256 offset) = name.readLabel(0);
        bytes32 parentNode = name.namehash(offset);

        require(
            nameWrapper.ownerOf(uint256(node)) == address(0),
            "domain already registered"
        );
        require(msg.value >= price, "insufficient funds");

        nameWrapper.setSubnodeRecord(
            parentNode, label, owner, resolver, 0, fuses, uint64(duration)
        );

        if (data.length > 0) {
            Resolver(resolver).multicallWithNodeCheck(node, data);
        }
    }

    function _getLabel(bytes calldata name)
        private
        pure
        returns (string memory)
    {
        uint256 labelLength = uint256(uint8(name[0]));
        if (labelLength == 0) return "";
        return string(name[1:labelLength + 1]);
    }

    function supportsInterface(bytes4 interfaceId) public pure returns (bool) {
        return interfaceId == type(IERC165).interfaceId
            || interfaceId == type(OffchainRegister).interfaceId
            || interfaceId == type(OffchainRegisterParams).interfaceId;
    }

}
