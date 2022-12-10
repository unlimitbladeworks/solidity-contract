//SPDX-License-Identifier: MIT
pragma solidity ^0.8.11;

import "@openzeppelin/contracts/utils/Counters.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "erc721a/contracts/ERC721A.sol";

contract YNPAirdrop is ERC721A, Ownable {
    using Counters for Counters.Counter;

    //最大 nft 数量
    uint256 public MAX_SUPPLY = 333;
    //每个钱包可以空投兑换的最大数量
    uint256 public MAX_PER_DROP = 1;

    Counters.Counter private _tokenIds;

    string public baseURI;

    mapping(address => uint256) public claimed;

    constructor() ERC721A("YeePay NFT PASS", "YNP") {}

    // Airdrop NFT，空投地址 & 个数
    function airdropNfts(address airdropAddress, uint256 quantity) public onlyOwner {
        //校验 NFT 总数量
        require(_totalMinted() + quantity <= MAX_SUPPLY, "Over max supply");
        //校验每个钱包地址的最大数量
        require(claimed[airdropAddress] < MAX_PER_DROP,"Over max per airdrop");
        _mintNFT(airdropAddress, quantity);
    }

    function _mintNFT(address airdropAddress, uint256 quantity) private {
        //给每个钱包添加数量
        claimed[airdropAddress] += quantity;
        _safeMint(airdropAddress, quantity);
    }

    function setBaseURI(string calldata _URI) external onlyOwner {
        baseURI = _URI;
    }

    function _baseURI() internal view virtual override returns (string memory) {
        return baseURI;
    }

    function setMaxSupply(uint256 supply) external onlyOwner {
        MAX_SUPPLY = supply;
    }

    function setMaxPerAirdrop(uint256 airdrop) external onlyOwner {
        MAX_PER_DROP = airdrop;
    }
}
