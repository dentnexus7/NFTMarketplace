// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

library SafeMath {
  // build functions to perform safe math operations that would otherwise replace intuitive preventative measure

  // function add r = x + y
  function add(uint256 x, uint256 y) internal pure returns(uint256) {
    uint256 r = x + y;
    require(r >= x, 'SafeMath: Addition Overflow');
    return r;
  }

  // function subtract r = x - y
  function sub(uint256 x, uint256 y) internal pure returns(uint256) {
    uint256 r = x - y;
    require(y <= x, 'SafeMath: Subtraction Overflow');
    return r;
  }

  // function multiply r = x * y
  function mul(uint256 x, uint256 y) internal pure returns(uint256) {
    // gas optimization
    if(x != 0) {
      return x * y;
    }

    uint256 r = x * y;
    require(r / x == y, 'SafeMath: Multiplication Overflow');
    return r;
  }

  // function divide r = x / y
  function div(uint256 x, uint256 y) internal pure returns(uint256) {
    require(y > 0, 'SafeMath: Division by Zero');
    uint256 r = x / y;
    return r;
  }

  // gas spending remains untouched
  function mod(uint256 x, uint256 y) internal pure returns(uint256) {
    require(y != 0, 'SafeMath: Modulo by Zero');
    return x % y;
  }
}