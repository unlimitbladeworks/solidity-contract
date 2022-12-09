pragma solidity ^0.8.11;
//SPDX-License-Identifier: MIT
import "@openzeppelin/contracts/utils/Counters.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/token/ERC721/extensions/ERC721Enumerable.sol";
import "@openzeppelin/contracts/utils/cryptography/ECDSA.sol";

contract NFTAllowlist is ERC721Enumerable, Ownable {
    using Counters for Counters.Counter;
    
    Counters.Counter private _tokenIds;

    // Signature tracker
    mapping(bytes => bool) public signatureUsed;
    
    constructor() ERC721("YeePay's NFT PASS ", "YNP") {
    }

    // Allowlist addresses
    function recoverSigner(bytes32 hash, 
                                                     bytes memory signature) 
                         public pure returns (address) {
            bytes32 messageDigest = keccak256(
            abi.encodePacked(
              "\x19Ethereum Signed Message:\n32", 
            hash
            )
            );
            return ECDSA.recover(messageDigest, signature);
        }

    // Airdrop mint
    function claimAirdrop(uint _count, bytes32 hash, bytes memory signature) public {
        require(recoverSigner(hash, signature) == owner(), "Address is not allowlisted");
        require(!signatureUsed[signature], "Signature has already been used.");

        for (uint i = 0; i < _count; i++) {
            _mintSingleNFT();
        }

        signatureUsed[signature] = true;
    }
    
    function _mintSingleNFT() private {
        uint newTokenID = _tokenIds.current();
        _safeMint(msg.sender, newTokenID);
        _tokenIds.increment();
    }
}