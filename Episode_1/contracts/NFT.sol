// SPDX-License-Identifier: MIT

pragma solidity >=0.7.0 <0.9.0;

import "@openzeppelin/contracts/token/ERC721/extensions/ERC721Enumerable.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "hardhat/console.sol";

contract NFT is ERC721Enumerable, Ownable {
    using Strings for uint256;

    string baseURI;
    string public notRevealedBaseURI;
    uint256 public cost = 0.05 ether;
    uint256 public maxSupply = 50;
    uint256 public maxMintSupply = 5;
    bool public pause = false;
    bool public revealed = false;
    string public baseExtension = '.json';

    constructor(
        string memory _name,
        string memory _symbol,
        string memory _initBaseURI,
        string memory _initNotRevealedURI
    ) ERC721(_name, _symbol) {
        setBaseURI(_initBaseURI);
        setNotRevealedURI(_initNotRevealedURI);
        console.log(
            "The contract has been deployed - say hi to the NFT space %s",
            _name
        );
    }

    function _baseURI() internal view virtual override returns (string memory) {
        return baseURI;
    }

    function setBaseURI(string memory _newBaseURI) public onlyOwner {
        baseURI = _newBaseURI;
    }

    function setNotRevealedURI(string memory _notRevealedURI) public onlyOwner {
        notRevealedBaseURI = _notRevealedURI;
    }

    function walletOfOwner(address _owner) public view returns (uint256[] memory) {
        uint256 ownerTokenCount = balanceOf(_owner);
        uint256[] memory tokenIds = new uint256[](ownerTokenCount);
        for (uint256 i; i< ownerTokenCount; i++) {
            tokenIds[i] = tokenOfOwnerByIndex(_owner, i);
        }
        return tokenIds;
    }

    function mint(uint256 _mintAmount) public payable {
        uint256 supply = totalSupply();

        require(!pause);
        require(_mintAmount > 0);
        require(_mintAmount <= maxMintSupply);
        require(supply + _mintAmount <= maxSupply);

        // if we are not the owner we charge
        if (msg.sender != owner()) {
            require(msg.value >= cost * _mintAmount);
        }

        for (uint256 i = 1; i <= _mintAmount; i++) {
            _safeMint(msg.sender, supply + i);
            console.log(
                "Congratulations on minting an NFT, the id of it is: %s",
                supply + i
            );
        }
    }

    // We need to create a function to set our Token URI
    function tokenURI(uint256 tokenID) public view virtual override returns(string memory){
        require(_exists(tokenID), "The URI does not exist for this NFT");

        if (revealed == false) {
            return notRevealedBaseURI;
        }

        string memory currentBaseURI = _baseURI(); 
        // this needs to be a URL
        return bytes(currentBaseURI).length > 0 ? string(abi.encodePacked(currentBaseURI, tokenID.toString(), baseExtension)) : "";
    }

    // Owner functions for post deployment
    function reveal() public onlyOwner {
        revealed = true;
    }

    function paused(bool _toPause) public onlyOwner {
        pause = _toPause;
    }

    function setCost(uint256 _newCost) public onlyOwner{
        cost = _newCost;
    } 

    function withdraw() public payable onlyOwner {
        (bool os, ) = payable(owner()).call{value: address(this).balance}("");
        require(os);
    }

    function setMaxMintSupply(uint256 _newMaxMintSupply) public onlyOwner {
        maxMintSupply = _newMaxMintSupply;  
    }
}
