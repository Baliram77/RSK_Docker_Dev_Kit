// SPDX-License-Identifier: MIT
pragma solidity ^0.8.28;

import {Test} from "forge-std/Test.sol";
import {MintableERC721} from "src/MintableERC721.sol";

contract MintableERC721Test is Test {
    MintableERC721 private nft;

    function setUp() public {
        nft = new MintableERC721("DevNFT", "DNFT", address(this));
    }

    function test_MintAndTransfer() public {
        nft.mint(address(this), 1);
        assertEq(nft.ownerOf(1), address(this));
        assertEq(nft.balanceOf(address(this)), 1);

        nft.transferFrom(address(this), address(0xBEEF), 1);
        assertEq(nft.ownerOf(1), address(0xBEEF));
    }

    function test_Mint_RevertsIfNotOwner() public {
        vm.prank(address(0xBEEF));
        vm.expectRevert(MintableERC721.NotOwner.selector);
        nft.mint(address(0xBEEF), 1);
    }

    function test_Approve_AllowsApprovedSpenderTransfer() public {
        nft.mint(address(this), 1);

        nft.approve(address(0xBEEF), 1);

        vm.prank(address(0xBEEF));
        nft.transferFrom(address(this), address(0xCAFE), 1);

        assertEq(nft.ownerOf(1), address(0xCAFE));
    }

    function test_SetApprovalForAll_AllowsOperatorTransfer() public {
        nft.mint(address(this), 1);
        nft.setApprovalForAll(address(0xBEEF), true);

        vm.prank(address(0xBEEF));
        nft.transferFrom(address(this), address(0xCAFE), 1);

        assertEq(nft.ownerOf(1), address(0xCAFE));
    }
}

