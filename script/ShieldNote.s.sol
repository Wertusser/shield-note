// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import "forge-std/Script.sol";
import "forge-std/console2.sol";

import {Verifier as FulfillVerifier} from "../src/verifiers/fulfill.sol";
import {Verifier as RedeemVerifier} from "../src/verifiers/redeem.sol";
import "../src/ShieldNote.sol";

contract ShieldNoteScript is Script {
    function run() public {
        FulfillVerifier fulfillContract = new FulfillVerifier();

        RedeemVerifier redeemContract = new RedeemVerifier();

        ShieldNote shieldNoteContract = new ShieldNote(
            fulfillContract,
            redeemContract
        );
        console2.log("fulfill: ", address(fulfillContract));
        console2.log("redeem: ", address(redeemContract));
        console2.log("shield-note: ", address(shieldNoteContract));
    }
}
