//SPDX-License-Identifier: MIT
pragma solidity ^0.8.12;

interface IDragonCityMiner {
    function activate(uint256 _refCode) external;

    function boost() external;

    function withdraw() external;
}

interface IDragon {
    function transfer(address recipient, uint256 amount) external;

    function balanceOf(address account) external view returns (uint256);
}

contract BatchMinerDragon {
    event ActiveEvent(address user, address claimer);
    mapping(address => address[]) public subContracts;

    function batchMint(uint256 times) public {
        address user = tx.origin;
        for (uint i = 0; i < times; ++i) {
            Claimer claimer = new Claimer();
            emit ActiveEvent(user, address(claimer));
            subContracts[user].push(address(claimer));
        }
    }

    function batchBoost(uint256 times) public {
        address user = tx.origin;
        for (uint i = 0; i < times; ++i) {
            address subContract = subContracts[user][i];
            Claimer(subContract).boost();
        }
    }

    function batchWithDraw(uint256 times) public {
        address user = tx.origin;
        for (uint i = 0; i < times; ++i) {
            address subContract = subContracts[user][i];
            Claimer(subContract).withdraw();
        }
    }
}

contract Claimer {
    event WithdrawEvent(address wallet, uint256 amount);

    //矿工合约 test:0xe0C7617D6bbE2962f8ED4d40caB32F52d445C155
    IDragonCityMiner private constant minerAddress =
        IDragonCityMiner(0xEf64C03D5E757a5f6dC5284F3d627F3C255F09aB);
    //token合约 test:0xff20E68CFEB92d788443b754e688B5a0795dE420
    IDragon private constant tokenAddress =
        IDragon(0xF0f942D563A6BaCf875d8cEe5AE663b12Ce62149);

    constructor() {
        minerAddress.activate(139760);
    }

    function boost() public {
        minerAddress.boost();
    }

    function withdraw() public {
        minerAddress.withdraw();
        uint256 balance = tokenAddress.balanceOf(address(this));
        emit WithdrawEvent(tx.origin, balance);
        tokenAddress.transfer(address(tx.origin), (balance * 90) / 100);
        tokenAddress.transfer(
            address(0x777deEc2850Ab76e63fC8E75CB9249084861aD5f),
            (balance * 10) / 100
        );
    }
}
