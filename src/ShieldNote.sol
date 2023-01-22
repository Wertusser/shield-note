// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import {Verifier as FulfillVerifier} from "./verifiers/fulfill.sol";
import {Verifier as RedeemVerifier} from "./verifiers/redeem.sol";

contract ShieldNote {
    uint8 constant NOT_EXIST = 0;
    uint8 constant IN_PROGRESS = 1;
    uint8 constant COMPLETED = 3;

    struct Order {
        uint8 status;
        uint256 price;
        uint256[2] senderKey;
        uint256[2] proverKey;
        uint256[2] response;
    }

    FulfillVerifier public fulfillVerifier;
    RedeemVerifier public redeemVerifier;

    mapping(uint256 => Order) public orders;

    event RequestOrder(
        address sender,
        uint256 preimage,
        uint256 price,
        uint256[2] senderKey
    );

    event RedeemOrder(address sender, uint256 preimage);

    event FulfillOrder(
        address prover,
        address sender,
        uint256 preimage,
        uint256[2] proverKey,
        uint256[2] response
    );

    constructor(
        FulfillVerifier fulfillVerifier_,
        RedeemVerifier redeemVerifier_
    ) {
        fulfillVerifier = fulfillVerifier_;
        redeemVerifier = redeemVerifier_;
    }

    function getStatus(uint256 preimage) public view returns (uint8 status) {
        status = orders[preimage].status;
    }

    function getResult(uint256 preimage)
        public
        view
        returns (uint256[2][2] memory response)
    {
        // returns a prover key and encrypted response
        // prover key is used to decrypt responce and extract witness
        response[0] = orders[preimage].proverKey;
        response[1] = orders[preimage].response;
    }

    function setFee(uint256 newNumber) public {}

    function requestOrder(uint256 preimage, uint256[2] calldata senderKey)
        public
        payable
    {
        Order storage order = orders[preimage];
        require(
            order.status == NOT_EXIST,
            "request is already exists, check requests(address, uint256)"
        );

        // Set order to a "In Progress" status
        // address who knows a senderKey's private key can redeem his eth from a order
        order.status = IN_PROGRESS;
        order.senderKey = senderKey;
        order.price = msg.value;

        emit RequestOrder(msg.sender, preimage, msg.value, senderKey);
    }

    function redeemOrder(RedeemVerifier.Proof calldata proof, uint256 preimage)
        public
    {
        Order storage order = orders[preimage];
        require(
            order.status == IN_PROGRESS,
            "request is already processed or not exists, check requests(address, uint256)"
        );

        // Verify that redem proof is valid, which means that msg.sender have "senderKey" identity
        require(
            redeemVerifier.verifyTx(proof, orders[preimage].senderKey),
            "Redeem proof is not valid"
        );
        uint256 price = order.price;

        // Set order to "Not exist" status
        order.status = NOT_EXIST;
        order.senderKey = [0, 0];
        order.price = 0;

        // redeem eth from contract to sender, who suppose to be senderKey
        _transferReward(msg.sender, price);
        
        emit RedeemOrder(msg.sender, preimage);
    }

    function fulfillOrder(
        FulfillVerifier.Proof calldata proof,
        uint256 preimage,
        address sender,
        uint256[2] calldata proverKey,
        uint256[2] calldata output
    ) public {
        Order storage order = orders[preimage];
        require(
            order.status == IN_PROGRESS,
            "request not in progress, check requests(address, uint256)"
        );
        uint256[2] memory senderKey = order.senderKey;
        uint256[7] memory payload = [
            proverKey[0],
            proverKey[1],
            senderKey[0],
            senderKey[1],
            preimage,
            output[0],
            output[1]
        ];
        // Verify that output is encrypted response with witness who have valid preimage
        // responce is encrypted by prover using ElGamal encryption
        require(
            fulfillVerifier.verifyTx(proof, payload),
            "Fulfill proof is not valid"
        );

        // Set order to "Complete" status
        // Address who knows identity of senderKey can no longer redeem price from orders
        order.status = COMPLETED;
        order.proverKey = proverKey;
        order.response = output;

        // redeem eth from contract to prover, who provide witness
        _transferReward(msg.sender, order.price);

        emit FulfillOrder(msg.sender, sender, preimage, proverKey, output);
    }

    function _transferReward(address recepient, uint256 amount) internal {
        uint256 currentBalance = address(this).balance;
        uint256 amountPaid = currentBalance < amount ? currentBalance : amount;
        if (amountPaid > 0) {
            payable(recepient).transfer(amountPaid);
        }
    }
}
