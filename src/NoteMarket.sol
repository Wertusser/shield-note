// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import {Verifier} from "./Verifier.sol";

contract NoteMarket is Verifier {
    uint8 constant NOT_EXIST = 0;
    uint8 constant IN_PROGRESS = 1;
    uint8 constant COMPLETED = 3;

    struct RequestData {
        uint8 status;
        uint256 amountPaid;
        uint256[2] senderKey;
        uint256[2] proverKey;
        uint256[2] response;
    }

    event Request(address sender, uint256 preimage, uint256[2] senderKey);
    event Close(address sender, uint256 preimage);
    event Fulfill(
        address sender,
        address prover,
        uint256 preimage,
        uint256[2] proverKey,
        uint256[2] response
    );

    mapping(address => mapping(uint256 => RequestData)) public requests;

    function getStatus(address sender, uint256 preimage)
        public
        view
        returns (uint8 status)
    {
        status = requests[sender][preimage].status;
    }

    function getResult(address sender, uint256 preimage)
        public
        view
        returns (uint256[2][2] memory response)
    {
        response[0] = requests[sender][preimage].proverKey;
        response[1] = requests[sender][preimage].response;
    }

    function setFee(uint256 newNumber) external {}

    function request(uint256 preimage, uint256[2] calldata senderKey)
        external
        payable
    {
        RequestData storage req = requests[msg.sender][preimage];
        require(
            req.status == NOT_EXIST,
            "request is already exists, check requests(address, uint256)"
        );

        req.status = IN_PROGRESS;
        req.senderKey = senderKey;
        req.amountPaid = msg.value;

        emit Request(msg.sender, preimage, senderKey);
    }

    function close(uint256 preimage) external {
        RequestData storage req = requests[msg.sender][preimage];
        require(
            req.status == IN_PROGRESS,
            "request is already processed or not exists, check requests(address, uint256)"
        );

        req.status = NOT_EXIST;
        req.senderKey = [0, 0];
        req.amountPaid = 0;

        transferReward(msg.sender, req.amountPaid);
        emit Close(msg.sender, preimage);
    }

    function fulfill(
        Proof calldata proof,
        uint256 preimage,
        address sender,
        uint256[2] calldata proverKey,
        uint256[2] calldata output
    ) external {
        RequestData storage req = requests[sender][preimage];
        require(
            req.status == IN_PROGRESS,
            "request not in progress, check requests(address, uint256)"
        );
        uint256[2] memory senderKey = req.senderKey;
        uint256[7] memory payload = [
            proverKey[0],
            proverKey[1],
            senderKey[0],
            senderKey[1],
            preimage,
            output[0],
            output[1]
        ];
        require(verifyTx(proof, payload), "Proof is not valid");

        req.status = COMPLETED;
        req.proverKey = proverKey;
        req.response = output;

        transferReward(msg.sender, req.amountPaid);

        emit Fulfill(sender, msg.sender, preimage, proverKey, output);
    }

    function transferReward(address recepient, uint256 amount) internal {
        uint256 currentBalance = address(this).balance;
        uint256 amountPaid = currentBalance < amount ? currentBalance : amount;

        payable(recepient).transfer(amountPaid);
    }
}
