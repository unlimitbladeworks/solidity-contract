// SPDX-License-Identifier: MIT
pragma solidity ^0.8.12;

import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/utils/cryptography/MerkleProof.sol";
import "@openzeppelin/contracts/utils/Strings.sol";
import "erc721a/contracts/ERC721A.sol";

contract reepz is Ownable, ERC721A {
    using Strings for uint;

    enum Step {
        Before,
        WhitelistSale,
        PublicSale,
        SoldOut
    }

    string public baseURI;

    Step public sellingStep;

    uint public MAX_SUPPLY = 5000;
    uint public MAX_TOTAL_PUBLIC = 5000;
    uint public MAX_TOTAL_WL = 5000;

    uint public MAX_PER_WALLET_PUBLIC = 50;
    uint public MAX_PER_WALLET_WL = 25;

    uint public wlSalePrice = 0.0000123 ether;
    uint public publicSalePrice = 0.0000123 ether;

    bytes32 public merkleRootWL;

    mapping(address => uint) public amountNFTsperWalletPUBLIC;
    mapping(address => uint) public amountNFTsperWalletWL;
    address payable private _treasury;

    event TreasuryChanged(
        address indexed previousTreasury,
        address indexed newTreasury
    );

    constructor() ERC721A("reepz", "reepz") {
        _treasury = payable(msg.sender);
    }

    modifier callerIsUser() {
        require(tx.origin == msg.sender, "The caller is another contract");
        _;
    }

    function priceWHITELIST(
        address _account,
        uint _quantity
    ) public view returns (uint256) {
        if (amountNFTsperWalletWL[_account] == 0) {
            return wlSalePrice * (_quantity - 1);
        }
        return wlSalePrice * _quantity;
    }

    function whitelistMint(
        address _account,
        uint _quantity,
        bytes32[] calldata _proof
    ) external payable callerIsUser {
        require(
            sellingStep == Step.WhitelistSale,
            "Whitelist sale is not activated"
        );
        require(msg.sender == _account, "Mint with your own wallet.");
        require(isWhiteListed(msg.sender, _proof), "Not whitelisted");
        require(
            amountNFTsperWalletWL[msg.sender] + _quantity <= MAX_PER_WALLET_WL,
            "Max per wallet limit reached"
        );
        require(
            totalSupply() + _quantity <= MAX_TOTAL_WL,
            "Max supply exceeded"
        );
        require(totalSupply() + _quantity <= MAX_SUPPLY, "Max supply exceeded");
        require(_quantity > 0, "Mint at least one NFT.");
        require(
            msg.value >= priceWHITELIST(_account, _quantity),
            "Not enought funds"
        );
        amountNFTsperWalletWL[msg.sender] += _quantity;
        _safeMint(_account, _quantity);
    }

    function publicSaleMint(
        address _account,
        uint _quantity
    ) external payable callerIsUser {
        require(msg.sender == _account, "Mint with your own wallet.");
        require(sellingStep == Step.PublicSale, "Public sale is not activated");
        require(
            totalSupply() + _quantity <= MAX_TOTAL_PUBLIC,
            "Max supply exceeded"
        );
        require(totalSupply() + _quantity <= MAX_SUPPLY, "Max supply exceeded");
        require(
            amountNFTsperWalletPUBLIC[msg.sender] + _quantity <=
                MAX_PER_WALLET_PUBLIC,
            "Max per wallet limit reached"
        );
        require(_quantity > 0, "Mint at least one NFT.");
        require(msg.value >= publicSalePrice * _quantity, "Not enought funds");
        amountNFTsperWalletPUBLIC[msg.sender] += _quantity;
        _safeMint(_account, _quantity);
    }

    function gift(address _to, uint _quantity) external onlyOwner {
        require(totalSupply() + _quantity <= MAX_SUPPLY, "Reached max Supply");
        _safeMint(_to, _quantity);
    }

    function lowerSupply(uint _MAX_SUPPLY) external onlyOwner {
        require(_MAX_SUPPLY < MAX_SUPPLY, "Cannot increase supply!");
        MAX_SUPPLY = _MAX_SUPPLY;
    }

    function setMaxTotalPUBLIC(uint _MAX_TOTAL_PUBLIC) external onlyOwner {
        MAX_TOTAL_PUBLIC = _MAX_TOTAL_PUBLIC;
    }

    function setMaxTotalWL(uint _MAX_TOTAL_WL) external onlyOwner {
        MAX_TOTAL_WL = _MAX_TOTAL_WL;
    }

    function setMaxPerWalletWL(uint _MAX_PER_WALLET_WL) external onlyOwner {
        MAX_PER_WALLET_WL = _MAX_PER_WALLET_WL;
    }

    function setMaxPerWalletPUBLIC(
        uint _MAX_PER_WALLET_PUBLIC
    ) external onlyOwner {
        MAX_PER_WALLET_PUBLIC = _MAX_PER_WALLET_PUBLIC;
    }

    function setWLSalePrice(uint _wlSalePrice) external onlyOwner {
        wlSalePrice = _wlSalePrice;
    }

    function setPublicSalePrice(uint _publicSalePrice) external onlyOwner {
        publicSalePrice = _publicSalePrice;
    }

    function setBaseUri(string memory _baseURI) external onlyOwner {
        baseURI = _baseURI;
    }

    function setStep(uint _step) external onlyOwner {
        sellingStep = Step(_step);
    }

    function tokenURI(
        uint _tokenId
    ) public view virtual override returns (string memory) {
        require(_exists(_tokenId), "URI query for nonexistent token");

        return string(abi.encodePacked(baseURI, _tokenId.toString(), ".json"));
    }

    //Whitelist
    function setMerkleRootWL(bytes32 _merkleRootWL) external onlyOwner {
        merkleRootWL = _merkleRootWL;
    }

    function isWhiteListed(
        address _account,
        bytes32[] calldata _proof
    ) internal view returns (bool) {
        return _verifyWL(leaf(_account), _proof);
    }

    function leaf(address _account) internal pure returns (bytes32) {
        return keccak256(abi.encodePacked(_account));
    }

    function _verifyWL(
        bytes32 _leaf,
        bytes32[] memory _proof
    ) internal view returns (bool) {
        return MerkleProof.verify(_proof, merkleRootWL, _leaf);
    }

    function withdraw() public onlyOwner {
        require(msg.sender == _treasury, "Caller is not the treasury");
        (bool success, ) = _treasury.call{value: address(this).balance}("");
        require(success, "Transfer failed.");
    }

    function setTreasury(address payable newTreasury) public onlyOwner {
        require(
            newTreasury != address(0),
            "Cannot set treasury to the zero address"
        );
        address oldTreasury = _treasury;
        _treasury = newTreasury;
        emit TreasuryChanged(oldTreasury, newTreasury);
    }
}
