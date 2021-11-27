// SPDX-License-Identifier: UNLICENSED

pragma solidity ^0.8.0;

import "hardhat/console.sol";

contract RespectPortal {
    uint256 totalRespect;

    event NewRespectMessage(address indexed from, uint256 timestamp, string message);
    /*
     * We will be using this below to help generate a random number
     */
    uint256 private seed;
    /*
     * A struct is basically a custom datatype where we can customize what we want to hold inside it.
    */
    struct RespectMessage {
        address sender; // The address of the user who waved.
        string message; // The message the user sent.
        uint256 timestamp; // The timestamp when the user waved.
    }

    /*
     * I declare a variable waves that lets me store an array of structs.
     * This is what lets me hold all the waves anyone ever sends to me!
     */
    RespectMessage[] respectMessages;
    
    /*
     * This is an address => uint mapping, meaning I can associate an address with a number!
     * In this case, I'll be storing the address with the last time the user sent a mesaage at us.
     */
    mapping(address => uint256) public lastSentAt;

    constructor() payable {
        console.log("Hi, i am a contract");
        seed = (block.timestamp + block.difficulty) % 100;
    }

    function sendRespect(string memory _message) public {
        /*
         * We need to make sure the current timestamp is at least 15-minutes bigger than the last timestamp we stored
         */
        require(
            lastSentAt[msg.sender] + 15 minutes < block.timestamp,
            "Wait 15m"
        );

        /*
         * Update the current timestamp we have for the user
         */
        lastSentAt[msg.sender] = block.timestamp;
        totalRespect += 1;
        console.log("%s has waved", msg.sender);

        respectMessages.push(RespectMessage(msg.sender, _message, block.timestamp));

        /*
         * Generate a new seed for the next user that sends a wave
         */
        seed = (block.difficulty + block.timestamp + seed) % 100;

        if (seed <= 50) {
            console.log("%s won!", msg.sender);
            uint256 prizeAmount = 0.0001 ether;
            require(
                prizeAmount <= address(this).balance,
                "Trying to withdraw more money than the contract has."
            );
            (bool success, ) = (msg.sender).call{value: prizeAmount}("");
            require(success, "Failed to withdraw money from contract.");
        }
        emit NewRespectMessage(msg.sender, block.timestamp, _message);

    }

    /*
     * I added a function getAllWaves which will return the struct array, waves, to us.
     * This will make it easy to retrieve the waves from our website!
     */
    function getAllRespectMessages() public view returns (RespectMessage[] memory) {
        return respectMessages;
    }

    function getTotalRespect() public view returns (uint256) {
        console.log("We have a total of %d respect", totalRespect);
        return totalRespect;
    }
}