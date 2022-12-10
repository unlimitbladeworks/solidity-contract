//SPDX-License-Identifier: MIT
pragma solidity ^0.8.11;

import "@openzeppelin/contracts/access/Ownable.sol";
import "erc721a/contracts/ERC721A.sol";

contract YNPAirdrop is ERC721A, Ownable {
    
    struct MintConfig {
        //nft基础图片 uri
        string baseTokenURI;
        //每个钱包最大空投的数量限制，初次设置可为 1
        uint32 maxPerAddress;
        //最大流动的 NFT 数量，初次设置可为 333
        uint256 maxSupply;
    }

    MintConfig public config;
    //记录已经空投过的数量
    mapping(address => uint256) public claimed;

    constructor() ERC721A("YeePay NFT PASS", "YNP") {}

    // Airdrop NFT，空投地址 & 个数
    function airdropNfts(address airdropAddress, uint256 quantity) public onlyOwner {
        //校验 NFT 总数量
        require(_totalMinted() + quantity <= config.maxSupply, "Over max supply");
        //校验每个钱包地址的最大数量
        require(claimed[airdropAddress] < config.maxPerAddress, "Over max per airdrop");
        _mintNFT(airdropAddress, quantity);
    }

    function setConfig(
        string memory baseTokenURI,
        uint32 maxPerAddress,
        uint256 maxSupply
    ) external onlyOwner {
        config.baseTokenURI = baseTokenURI;
        config.maxPerAddress = maxPerAddress;
        config.maxSupply = maxSupply;
    }

    function setBaseURI(string calldata baseURI) external onlyOwner {
        config.baseTokenURI = baseURI;
    }

    function _mintNFT(address airdropAddress, uint256 quantity) private {
        //给每个钱包添加数量
        claimed[airdropAddress] += quantity;
        _safeMint(airdropAddress, quantity);
    }

    function _baseURI() internal view virtual override returns (string memory) {
        return config.baseTokenURI;
    }
}
