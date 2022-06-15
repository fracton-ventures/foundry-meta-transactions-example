// SPDX-License-Identifier: MIT
pragma solidity 0.8.13;

import {console} from "forge-std/console.sol";
import {stdStorage, StdStorage, Test} from "forge-std/Test.sol";

import {Utils} from "./utils/Utils.sol";
import {MetaCoin} from "../MetaCoin.sol";

import {MinimalForwarder} from "openzeppelin-contracts/metatx/MinimalForwarder.sol";

contract BaseSetup is MetaCoin, MinimalForwarder, Test {
    Utils internal utils;
    address payable[] internal users;

    address internal alice;
    address internal bob;

    ForwardRequest internal forwardRequest;
    bytes internal signature; 

    constructor() MetaCoin(address(this)) {}

    function setUp() public virtual {
        utils = new Utils();
        users = utils.createUsers(2);

        alice = users[0];
        vm.label(alice, "Alice");
        bob = users[1];
        vm.label(bob, "Bob");

        forwardRequest = ForwardRequest(alice, bob, 1000000, 1000000, 1, "0x");
        signature = "0x";
    }
}

contract WhenTransferringTokens is BaseSetup {
    uint256 internal maxTransferAmount = 12e18;

    function setUp() public virtual override {
        BaseSetup.setUp();
        console.log("When transferring tokens");
    }

    function testVerify() public {
        verify(forwardRequest, signature);
    }
}
