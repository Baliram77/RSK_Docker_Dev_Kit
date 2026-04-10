// SPDX-License-Identifier: MIT
pragma solidity ^0.8.28;

import {Script} from "forge-std/Script.sol";
import {console2} from "forge-std/console2.sol";
import {MintableERC20} from "src/MintableERC20.sol";
import {MintableERC721} from "src/MintableERC721.sol";

contract Deploy is Script {
    function run() public {
        uint256 pk = vm.envUint("PRIVATE_KEY");
        address deployer = vm.addr(pk);

        vm.startBroadcast(pk);

        MintableERC20 token = new MintableERC20("DevToken", "DVT", deployer);
        token.mint(deployer, 1_000_000e18);

        MintableERC721 nft = new MintableERC721("DevNFT", "DNFT", deployer);
        nft.mint(deployer, 1);

        vm.stopBroadcast();

        console2.log("MintableERC20:", address(token));
        console2.log("MintableERC721:", address(nft));
    }
}

