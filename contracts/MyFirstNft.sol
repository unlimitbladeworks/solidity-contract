// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/token/ERC721/extensions/ERC721Enumerable.sol";
import "@openzeppelin/contracts/token/ERC721/extensions/ERC721URIStorage.sol";
import "@openzeppelin/contracts/access/Ownable.sol";


contract MyFirstNft is ERC721, ERC721Enumerable, ERC721URIStorage, Ownable {
    uint256 MAX_SUPPLY = 100000;
    address payable private _treasury;
    uint256 public wlPrice = 0.0001 ether;
    uint256 public publicPrice = 0.0005 ether;
    bool public wlMintStatus = false;
    bool public publicMintStatus = false;

    constructor() ERC721("suyu's nft", "SY NFT") {
        _treasury = payable(msg.sender);
    }

    function wlMint(uint256 quantity) external payable {
        require(wlMintStatus, "Not mintable during wl");
        require(totalSupply() + quantity <= MAX_SUPPLY, "Over max supply");
        uint256 totalPrice = quantity * wlPrice;
        require(msg.value >= totalPrice, "Wrong amount of ETH sent.");
        _safeMint(msg.sender, quantity);
    }

    function publicMint(uint256 quantity) external payable {
        require(publicMintStatus, "Not mintable during public");
        require(totalSupply() + quantity <= MAX_SUPPLY, "Over max supply");
        uint256 totalPrice = quantity * publicPrice;
        require(msg.value >= totalPrice, "Wrong amount of ETH sent.");
        _safeMint(msg.sender, quantity);
    }

    function _beforeTokenTransfer(
        address from,
        address to,
        uint256 tokenId,
        uint256 batchSize
    ) internal override(ERC721, ERC721Enumerable) {
        super._beforeTokenTransfer(from, to, tokenId, batchSize);
    }

    function _burn(uint256 tokenId)
        internal
        override(ERC721, ERC721URIStorage)
    {
        super._burn(tokenId);
    }

    function withdraw() public onlyOwner {
        require(msg.sender == _treasury, "Caller is not the treasury");
        (bool success, ) = _treasury.call{value: address(this).balance}("");
        require(success, "Transfer failed.");
    }

    function tokenURI(uint256 tokenId)
        public
        view
        override(ERC721, ERC721URIStorage)
        returns (string memory)
    {
        return super.tokenURI(tokenId);
    }

    function supportsInterface(bytes4 interfaceId)
        public
        view
        override(ERC721, ERC721Enumerable)
        returns (bool)
    {
        return super.supportsInterface(interfaceId);
    }

    function setWlStatus(bool _status) public onlyOwner {
        wlMintStatus = _status;
    }

    function setPublicStatus(bool _status) public onlyOwner {
        publicMintStatus = _status;
    }

}
