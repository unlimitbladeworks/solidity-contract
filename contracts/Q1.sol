// 阅读以下代码，尝试将合约中的所有资金取出：
// SPDX-License-Identifier: GPL-3.0
pragma solidity ^0.8;
import "@openzeppelin/contracts/access/Ownable.sol";

contract VIPChecker is Ownable {
    uint32 triedNumber;

    modifier counter() {
        triedNumber++; 
        _;
    }

    function check(bytes32 key) counter public {
        uint16 mask = uint16(uint160(msg.sender) >> 144);
        require(mask == 0, "You are not vip");
        uint160 shortKey = uint160(uint256(key));   
        require(uint160(msg.sender) & shortKey == 0x0, "Not the right key");  
        payable(msg.sender).transfer(address(this).balance);
    }
    
    function depositByOwner() payable onlyOwner public {
    }
}