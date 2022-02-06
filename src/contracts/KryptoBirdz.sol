// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import './ERC721Connector.sol';

contract KryptoBird is ERC721Connector {
  // Array to store out NFTs
  string[] public kryptoBirdz;

  mapping(string => bool) _kryptoBirdzExists;

  constructor() ERC721Connector('KryptoBird', 'KBIRDZ') {

  }

  function mint(string memory _kryptoBird) public {
    require(!_kryptoBirdzExists[_kryptoBird], 'Error - kryptoBird already exists');

    // this is deprecated  - uint _id = KryptoBirdz.push(_kryptoBird);
    // .push no longer returns the length but a red to the added element
    kryptoBirdz.push(_kryptoBird);
    uint _id = kryptoBirdz.length -1;

    _mint(msg.sender, _id);
    
    _kryptoBirdzExists[_kryptoBird] = true;
  }
}