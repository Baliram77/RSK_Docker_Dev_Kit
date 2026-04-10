// SPDX-License-Identifier: MIT
pragma solidity ^0.8.28;

import {Test} from "forge-std/Test.sol";
import {MintableERC20} from "src/MintableERC20.sol";

contract MintableERC20Test is Test {
    MintableERC20 private token;

    function setUp() public {
        token = new MintableERC20("DevToken", "DVT", address(this));
    }

    function test_MintAndTransfer() public {
        token.mint(address(this), 100e18);
        assertEq(token.totalSupply(), 100e18);
        assertEq(token.balanceOf(address(this)), 100e18);

        bool ok = token.transfer(address(0xBEEF), 1e18);
        assertTrue(ok);
        assertEq(token.balanceOf(address(0xBEEF)), 1e18);
    }

    function test_Mint_RevertsIfNotOwner() public {
        vm.prank(address(0xBEEF));
        vm.expectRevert(MintableERC20.NotOwner.selector);
        token.mint(address(0xBEEF), 1);
    }

    function test_ApproveAndTransferFrom() public {
        token.mint(address(this), 10e18);

        bool okApprove = token.approve(address(0xBEEF), 3e18);
        assertTrue(okApprove);
        assertEq(token.allowance(address(this), address(0xBEEF)), 3e18);

        vm.prank(address(0xBEEF));
        bool okTf = token.transferFrom(address(this), address(0xCAFE), 2e18);
        assertTrue(okTf);

        assertEq(token.balanceOf(address(0xCAFE)), 2e18);
        assertEq(token.allowance(address(this), address(0xBEEF)), 1e18);
    }
}

