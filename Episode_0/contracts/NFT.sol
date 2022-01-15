// SPDX-License-Identifier: MIT

pragma solidity >= 0.7.0 <0.9.0;

import "@openzeppelin/contracts/token/ERC721/extensions/ERC721Enumerable.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/utils/Counters.sol";
import "hardhat/console.sol";

contract NFT is ERC721Enumerable, Ownable {
  using Strings for uint256;
  using Counters for Counters.Counter;

  Counters.Counter private _tokenIds;

  string baseURI;

  constructor(string memory _name,string memory _symbol, string memory _initBaseURI) ERC721 (_name, _symbol) {
    setBaseURI(_initBaseURI);
    console.log("The contract has been deployed - say hi to the NFT space %s", _name);
  }

  function _baseURI() internal view virtual override returns (string memory) {
    return baseURI;
  }

  function setBaseURI(string memory _newBaseURI) public onlyOwner {
    baseURI = _newBaseURI;
  }

  function mintNFT() public {
    uint256 newID = _tokenIds.current();

    //Use the _safeMint function from OpenZeppelin
    _safeMint(msg.sender, newID);

    console.log("Congrats on minting the following token %s", newID);

    _tokenIds.increment();
  }
}
