// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

contract DeadmanSwitch {
  address payable sendToAddress;
  address public owner;
  uint256 public lastAliveCalledBlock = 0;


  constructor(address payable _sendToAddress) {
    sendToAddress = _sendToAddress;
    owner = msg.sender;
  }

  modifier onlyOwner {
    require(msg.sender == owner, "Not the Owner");
    _;
  }

  function still_Alive() external onlyOwner {
    lastAliveCalledBlock = block.number;
  }

  function transferBalance() public onlyOwner {
    require(block.number - lastAliveCalledBlock > 10, "The owner is still alive");
    uint256 balanceTransfer = address(this).balance;
    payable(sendToAddress).transfer(balanceTransfer);
  }

  function check() public returns (bool) {
    if (block.number >= 10 && lastAliveCalledBlock < block.number - 10){
      transferBalance();
      return false;
    }
    return true;
  }

  receive() external payable onlyOwner {
  }
}