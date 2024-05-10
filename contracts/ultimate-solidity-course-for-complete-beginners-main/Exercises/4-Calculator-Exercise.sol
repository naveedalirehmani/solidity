// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

// 1️⃣ Make a contract called Calculator
// 2️⃣ Create Result variable to store result
// 3️⃣ Create functions to add, subtract, and multiply to result
// 4️⃣ Create a function to get result

contract Calculator {
    uint256 result = 0;

    function add(uint256 number) public {
        result += number;
    }

    function subtract (uint256 number) public {
        result -= number;
    }

    function multiply (uint256 number) public {
        result *= number;
    }

    function get () public view returns(uint256){
        return result;
    }

}
