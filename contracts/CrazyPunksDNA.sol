//SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract CrazyPunksDNA {
    string[] private _accessoriesType = [
        "Blank",
        "Kurt",
        "Prescription01",
        "Prescription02",
        "Round",
        "Sunglasses",
        "Wayfarers"
    ];

    string[] private _clotheColor = [
        "Black",
        "Blue01",
        "Blue02",
        "Blue03",
        "Gray01",
        "Gray02",
        "Heather",
        "PastelBlue",
        "PastelGreen",
        "PastelOrange",
        "PastelRed",
        "PastelYellow",
        "Pink",
        "Red",
        "White"
    ];

    string[] private _clotheType = [
        "BlazerShirt",
        "BlazerSweater",
        "CollarSweater",
        "GraphicShirt",
        "Hoodie",
        "Overall",
        "ShirtCrewNeck",
        "ShirtScoopNeck",
        "ShirtVNeck"
    ];

    string[] private _eyeType = [
        "Close",
        "Cry",
        "Default",
        "Dizzy",
        "EyeRoll",
        "Happy",
        "Hearts",
        "Side",
        "Squint",
        "Surprised",
        "Wink",
        "WinkWacky"
    ];

    string[] private _eyebrowType = [
        "Angry",
        "AngryNatural",
        "Default",
        "DefaultNatural",
        "FlatNatural",
        "RaisedExcited",
        "RaisedExcitedNatural",
        "SadConcerned",
        "SadConcernedNatural",
        "UnibrowNatural",
        "UpDown",
        "UpDownNatural"
    ];

    string[] private _facialHairColor = [
        "Auburn",
        "Black",
        "Blonde",
        "BlondeGolden",
        "Brown",
        "BrownDark",
        "Platinum",
        "Red"
    ];

    string[] private _facialHairType = [
        "Blank",
        "BeardMedium",
        "BeardLight",
        "BeardMagestic",
        "MoustacheFancy",
        "MoustacheMagnum"
    ];

    string[] private _hairColor = [
        "Auburn",
        "Black",
        "Blonde",
        "BlondeGolden",
        "Brown",
        "BrownDark",
        "PastelPink",
        "Platinum",
        "Red",
        "SilverGray"
    ];

    string[] private _hatColor = [
        "Black",
        "Blue01",
        "Blue02",
        "Blue03",
        "Gray01",
        "Gray02",
        "Heather",
        "PastelBlue",
        "PastelGreen",
        "PastelOrange",
        "PastelRed",
        "PastelYellow",
        "Pink",
        "Red",
        "White"
    ];

    string[] private _graphicType = [
        "Bat",
        "Cumbia",
        "Deer",
        "Diamond",
        "Hola",
        "Pizza",
        "Resist",
        "Selena",
        "Bear",
        "SkullOutline",
        "Skull"
    ];

    string[] private _mouthType = [
        "Concerned",
        "Default",
        "Disbelief",
        "Eating",
        "Grimace",
        "Sad",
        "ScreamOpen",
        "Serious",
        "Smile",
        "Tongue",
        "Twinkle",
        "Vomit"
    ];

    string[] private _skinColor = [
        "Tanned",
        "Yellow",
        "Pale",
        "Light",
        "Brown",
        "DarkBrown",
        "Black"
    ];

    string[] private _topType = [
        "NoHair",
        "Eyepatch",
        "Hat",
        "Hijab",
        "Turban",
        "WinterHat1",
        "WinterHat2",
        "WinterHat3",
        "WinterHat4",
        "LongHairBigHair",
        "LongHairBob",
        "LongHairBun",
        "LongHairCurly",
        "LongHairCurvy",
        "LongHairDreads",
        "LongHairFrida",
        "LongHairFro",
        "LongHairFroBand",
        "LongHairNotTooLong",
        "LongHairShavedSides",
        "LongHairMiaWallace",
        "LongHairStraight",
        "LongHairStraight2",
        "LongHairStraightStrand",
        "ShortHairDreads01",
        "ShortHairDreads02",
        "ShortHairFrizzle",
        "ShortHairShaggyMullet",
        "ShortHairShortCurly",
        "ShortHairShortFlat",
        "ShortHairShortRound",
        "ShortHairShortWaved",
        "ShortHairSides",
        "ShortHairTheCaesar",
        "ShortHairTheCaesarSidePart"
    ];

  uint8 private DNA_PIECE_SIZE = 2;

  //Pseudo-random number but deterministic, shouldn't be used in production 
  function generatePseudoRandomDNA(uint _tokenId, address _minter) public pure returns(uint){
    uint combinedParams = _tokenId + uint160(_minter);
    bytes32 dnaHash = keccak256(abi.encodePacked(combinedParams));

    return uint(dnaHash);
  }


  function _getDnaPiece(uint _dna, uint8 _discardRight) private view  returns (uint8) {
    
    return uint8((_dna % (1 * 10 ** (_discardRight + DNA_PIECE_SIZE))) / (1 * 10 ** _discardRight));
  }

  function getAccessoriesType(uint _dna) public view returns(string memory){
    return _accessoriesType[_getDnaPiece(_dna, 0) % _accessoriesType.length];
  } 

  function getClotheColor(uint _dna) public view returns(string memory){
    return _clotheColor[_getDnaPiece(_dna, 2) % _clotheColor.length];
  } 

  function getClotheType(uint _dna) public view returns(string memory){
    return _clotheType[_getDnaPiece(_dna, 4) % _clotheType.length];
  } 

  function getEyeType(uint256 _dna) public view returns (string memory) {
      uint256 dnaSection = _getDnaPiece(_dna, 6);
      return _eyeType[dnaSection % _eyeType.length];
    }

  function getEyeBrowType(uint256 _dna) public view returns (string memory) {
      uint256 dnaSection = _getDnaPiece(_dna, 8);
      return _eyebrowType[dnaSection % _eyebrowType.length];
    }

  function getFacialHairColor(uint256 _dna)
      public
      view
      returns (string memory)
  {
      uint256 dnaSection = _getDnaPiece(_dna, 10);
      return _facialHairColor[dnaSection % _facialHairColor.length];
  }

  function getFacialHairType(uint256 _dna)
      public
      view
      returns (string memory)
  {
      uint256 dnaSection = _getDnaPiece(_dna, 12);
      return _facialHairType[dnaSection % _facialHairType.length];
  }

  function getHairColor(uint256 _dna) public view returns (string memory) {
      uint256 dnaSection = _getDnaPiece(_dna, 14);
      return _hairColor[dnaSection % _hairColor.length];
  }

  function getHatColor(uint256 _dna) public view returns (string memory) {
      uint256 dnaSection = _getDnaPiece(_dna, 16);
      return _hatColor[dnaSection % _hatColor.length];
  }

  function getGraphicType(uint256 _dna) public view returns (string memory) {
      uint256 dnaSection = _getDnaPiece(_dna, 18);
      return _graphicType[dnaSection % _graphicType.length];
  }

  function getMouthType(uint256 _dna) public view returns (string memory) {
      uint256 dnaSection = _getDnaPiece(_dna, 20);
      return _mouthType[dnaSection % _mouthType.length];
  }

  function getSkinColor(uint256 _dna) public view returns (string memory) {
      uint256 dnaSection = _getDnaPiece(_dna, 22);
      return _skinColor[dnaSection % _skinColor.length];
  }

  function getTopType(uint256 _dna) public view returns (string memory) {
      uint256 dnaSection = _getDnaPiece(_dna, 24);
      return _topType[dnaSection % _topType.length];
    }

}