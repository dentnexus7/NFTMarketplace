// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import './ERC721.sol';
import './interfaces/IERC721Enumerable.sol';

contract ERC721Enumerable is IERC721Enumerable, ERC721 {

  uint256[] private _allTokens;

  // mapping from tokenId to position in _allTokens array
  mapping(uint256 => uint256) private _allTokensIndex;

  // mapping of owner to list of all owner token ids
  mapping(address => uint256[]) private _ownedTokens;

  // mapping from token ID to index of the owner tokens list
  mapping(uint256 => uint256) private _ownedTokensIndex;

  constructor() {
    _registerInterface(bytes4(
      keccak256('totalSupply(bytes4)')^
      keccak256('tokenByIndex(bytes4)')^
      keccak256('tokenOfOwnerByIndex(bytes4)')
    ));
  }
  
  function _mint(address _to, uint256 _tokenId) internal override(ERC721) {
    super._mint(_to, _tokenId);
    // A. add tokens to the owner
    _addTokensToAllTokenEnumeration(_tokenId);(_tokenId);
    // B. all tokens to our totalsupply - to allTokens
    _addTokensToOwnerEnumeration(_to, _tokenId);
  }

  // add tokens to the _allTokens array and set the position of the tokens indexes
  function _addTokensToAllTokenEnumeration(uint256 _tokenId) private {
    _allTokensIndex[_tokenId] = _allTokens.length;
    _allTokens.push(_tokenId);
  }

  // add token to the _ownedTokens and set the ownedTokensIndex of the token to the position of the ownedToken address
  function _addTokensToOwnerEnumeration(address _to, uint256 _tokenId) private {
    _ownedTokensIndex[_tokenId] = _ownedTokens[_to].length;
    _ownedTokens[_to].push(_tokenId);
    
  }

  // returns the token at requested index
  function tokenByIndex(uint256 _index) public override view returns(uint256) {
    // make sure the index is not out of bounds of the total supply
    require(_index < totalSupply(), 'global index is out of bounds!');
    return _allTokens[_index];
  }

  // returns token of owner by specified index
  function tokenOfOwnerByIndex(address _owner, uint _index) public override view returns(uint256) {
    require(_index < balanceOf(_owner), 'owner index is out of bounds!');
    return _ownedTokens[_owner][_index];
  }

  // return the total supply of the _allTokens array
  function totalSupply() public override view returns(uint256) {
    return _allTokens.length;
  }
}