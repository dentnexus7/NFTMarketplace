// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import './ERC721Metadata.sol';
import './ERC721Enumerable.sol';

contract ERC721Connector is ERC721Metadata, ERC721Enumerable {

  // we deploy connector right away
  // we want to carry the metadata info over
  constructor(string memory _name, string memory _symbol) ERC721Metadata(_name, _symbol) {

  }

}