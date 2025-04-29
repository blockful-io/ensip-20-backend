// SPDX-License-Identifier: MIT
pragma solidity ^0.8.17;

import {INameWrapper} from "@ens-contracts/wrapper/INameWrapper.sol";
import {ENSRegistry} from "@ens-contracts/registry/ENSRegistry.sol";
import {Resolver} from "@ens-contracts/resolvers/Resolver.sol";
import {BytesUtils} from "@ens-contracts/utils/BytesUtils.sol";
import {IERC165} from "@openzeppelin/contracts/utils/introspection/IERC165.sol";

import {ENSHelper} from "../script/ENSHelper.sol";
import {
    OffchainRegister, RegisterRequest
} from "./interfaces/WildcardWriting.sol";

contract SubdomainController is IERC165, OffchainRegister, ENSHelper {

    using BytesUtils for bytes;

    uint256 public price;
    INameWrapper nameWrapper;

    address public admin;
    uint256 public prepaidBalance;

    // Allowing only one registration per wallet
    mapping(address => bool) public hasRegistered;

    constructor(address _nameWrapperAddress, uint256 _price) payable {
        price = _price;
        nameWrapper = INameWrapper(_nameWrapperAddress);
        admin = msg.sender;
        prepaidBalance = msg.value;
    }

    function deposit() external payable {
        require(msg.value > 0, "Must deposit some ETH");
        prepaidBalance += msg.value;
    }

    function withdraw(uint256 amount) external {
        require(msg.sender == admin, "Only admin can withdraw");
        require(amount <= prepaidBalance, "Insufficient balance");
        prepaidBalance -= amount;
        (bool success,) = payable(admin).call{value: amount}("");
        require(success, "Transfer failed");
    }

    function registerParams(
        bytes calldata name,
        uint256 /* duration */
    )
        external
        view
        override
        returns (RegisterParams memory)
    {
        return RegisterParams({
            price: price,
            available: nameWrapper.ownerOf(uint256(name.namehash(0))) == address(0),
            token: 0xEeeeeEeeeEeEeeEeEeEeeEEEeeeeEeeeeeeeEEeE, // EIP-7528 ETH
            commitTime: 0,
            extraData: ""
        });
    }

    function register(RegisterRequest calldata request)
        external
        payable
        override
    {
        bytes calldata name = request.name;
        bytes32 node = name.namehash(0);
        string memory label = _getLabel(name);

        (, uint256 offset) = name.readLabel(0);
        bytes32 parentNode = name.namehash(offset);

        require(
            nameWrapper.ownerOf(uint256(node)) == address(0),
            "domain already registered"
        );

        if (!hasRegistered[msg.sender] && prepaidBalance >= price) {
            prepaidBalance -= price;
            hasRegistered[msg.sender] = true;

            // Refund any ETH sent when registration gets funded
            if (msg.value > 0) {
                (bool success,) = payable(msg.sender).call{value: msg.value}("");
                require(success, "Refund failed");
            }
        } else {
            require(msg.value >= price, "Insufficient funds sent");
        }

        nameWrapper.setSubnodeRecord(
            parentNode,
            label,
            request.owner,
            request.resolver,
            0,
            0,
            uint64(request.duration)
        );
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
            || interfaceId == type(OffchainRegister).interfaceId;
    }

}
