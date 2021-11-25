// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

//Contracts
import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/token/ERC721/extensions/ERC721Enumerable.sol";
//Libraries
import "@openzeppelin/contracts/utils/Counters.sol";


contract Punks is ERC721("NilsonPunks", "NPKS"), ERC721Enumerable {
  using Counters for Counters.Counter;
  Counters.Counter private _tokenId;

  uint public limitSupply; 

  constructor(uint _limitSupply){
    limitSupply = _limitSupply;
  }

  function mintToken() public {
    uint currTokenId = _tokenId.current();
    require(currTokenId < 100, "No NilsonPunks Left, sory :( not sory :3");

    _safeMint(msg.sender, currTokenId);

    _tokenId.increment();
  }


  //Override for implementation of ERC721Enumerable
  function _beforeTokenTransfer(address _from, address _to, uint _tokenIdToTransfer) internal override(ERC721, ERC721Enumerable) {
    super._beforeTokenTransfer(_from, _to, _tokenIdToTransfer);
  }

  function supportsInterface(bytes4 interfaceId) public view override(ERC721,ERC721Enumerable) returns(bool){
    return super.supportsInterface(interfaceId);
  }

}
