// SPDX-License-Identifier: MIT
pragma solidity ^0.8.12;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

contract Dragon is ERC20, Ownable {
    constructor() ERC20("Dragon City", "DRAGON") {
        _mint(msg.sender, 1_000_000_000_000 * 1e18);
    }
}