// SPDX-License-Identifier: MIT
pragma solidity 0.8.17;

import "hardhat/console.sol";

contract MoonSent {
    uint256 transactionCount;

    event transaction(
        address from,
        address to,
        uint256 amount,
        string message,
        string keyword,
        uint256 timestamp
    );

    struct transactionStruct {
        address sender;
        address receiver;
        uint256 amount;
        string message;
        string keyword;
        uint256 timestamp;
    }

    transactionStruct[] transactions;

    modifier onlyEOA() {
        tx.origin == msg.sender;
        _;
    }

    function sendEther(
        address payable to,
        uint256 amount,
        string memory message,
        string memory keyword
    ) public onlyEOA {
        transactionCount++;
        transactions.push(
            transactionStruct(
                msg.sender,
                to,
                amount,
                message,
                keyword,
                block.timestamp
            )
        );

        emit transaction(
            msg.sender,
            to,
            amount,
            message,
            keyword,
            block.timestamp
        );
    }

    function getAllTransactions()
        public
        view
        onlyEOA
        returns (transactionStruct[] memory)
    {
        return transactions;
    }

    function getTransactionCount() public view onlyEOA returns (uint256) {
        return transactionCount;
    }
}
