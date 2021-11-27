// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

//Contracts
import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/token/ERC721/extensions/ERC721Enumerable.sol";
import "./CrazyPunksDNA.sol";
//Libraries
import "@openzeppelin/contracts/utils/Counters.sol";
import "./Base64.sol";
  

contract Punks is ERC721("CrazyPunks", "NPKS"), ERC721Enumerable, CrazyPunksDNA {
  using Counters for Counters.Counter;
  Counters.Counter private _tokenId;

  uint public limitSupply; 

  constructor(uint _limitSupply){
    limitSupply = _limitSupply;
  }

  function mintToken() public {
    uint currTokenId = _tokenId.current();
    require(currTokenId < 100, "No CrazyPunks Left, sory :( not sory :3");

    _safeMint(msg.sender, currTokenId);

    _tokenId.increment();
  }
  //ERC721 Metadata
  function tokenURI(uint tokenId) public view override returns(string memory){
    require(_exists(tokenId), "ERC71 Metadata: URI query for nonexistent token");

    //URI on-chain
    string memory jsonBase64 = Base64.encode(abi.encodePacked(
      '{ "name": "CrazyPunk #',
      tokenId, 
      '","description": "CrazyPunks are randomized Avataaars stored on chain in order to learn DApp development",'
      '"image":"',
      "TODO: Add image",
      '"}'
    ));

    return string(abi.encodePacked("data:application/json;base64,",jsonBase64));
  }



  //Override for implementation of ERC721Enumerable
  function _beforeTokenTransfer(address _from, address _to, uint _tokenIdToTransfer) internal override(ERC721, ERC721Enumerable) {
    super._beforeTokenTransfer(_from, _to, _tokenIdToTransfer);
  }

  function supportsInterface(bytes4 interfaceId) public view override(ERC721,ERC721Enumerable) returns(bool){
    return super.supportsInterface(interfaceId);
  }

}
