import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/utils/math/SafeMath.sol";
//SPDX-License-Identifier: MIT
pragma solidity ^0.8.11;

contract DaMiToken is ERC20, Ownable {

    using SafeMath for uint256;

    //项目方地址
    address public projectAddress;
    //手续费千分比 txFeeRatio/1000
    uint256 public txFeeRatio;
    //销毁千分比 burnRatio/1000
    uint256 public burnRatio;


    /**
     * - 阅读 openzeppelin 中的 ERC20 源码，在标准 ERC20 基础上，开发以下功能的 ERC20 合约：
     * - 支持项目方增发的功能
     * - 支持销毁的功能
     * - 支持交易收取手续费至项目方配置的地址
     */
    constructor(
        string memory name_,
        string memory symbol_
    ) ERC20(name_, symbol_) {
    }

    //增发代币功能,空投
    function mint(address _account ,uint256 _amount) public onlyOwner {
        //新增多少的数量，进行相加
        _mint(_account, _amount);
    }

    //销毁代币
    function burn(uint256 _amount) public {
        require(balanceOf(msg.sender) >= _amount,"burn amount exceeds  balances");
        _burn(msg.sender, _amount);
    }

    //交易收取手续费至项目方配置的地址
    function transfer(address _to, uint256 _amount) public virtual override returns (bool) {
        //交易数量
        uint256 txFee = _amount.mul(txFeeRatio).div(1000);
        //燃烧掉的数量
        uint256 burnAmount = _amount.mul(burnRatio).div(1000);
        uint256 amount = _amount.sub(txFee).sub(burnAmount);
        //给项目方设置的地址转交易费
        _transfer(msg.sender,projectAddress ,txFee);
        _transfer(msg.sender, _to,amount);
        if (burnAmount > 0) {
            _burn(msg.sender, burnAmount);
        }
        return true;
    }

    //设置地址和交易费比例
    function setProjectAddress(address _projectWallet, uint256 _txFeeRatio,uint256 _burnRatio)
        external
        onlyOwner
    {
        projectAddress = _projectWallet;
        txFeeRatio = _txFeeRatio;
        burnRatio = _burnRatio;
    }
}
