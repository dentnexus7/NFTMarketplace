// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "./ERC165.sol";
import "./interfaces/IERC721.sol";
import "./libraries/Counters.sol";

/*
  building out the minting function:
    a. nft to piont to an address
    b. keep track of the token ids
    c. keep track of token owners addresses to token ids
    d. keep track of how many tokens an owner address has
    e. create an event that emits a transfer log - contract address, where it is being minted to, the id
*/

contract ERC721 is ERC165, IERC721 {
  using SafeMath for uint256;
  using Counters for Counters.Counter;

  // mapping in solidity creates a hash table of key pair values

  // Mapping from token id to the owner
  mapping(uint256 => address) private _tokenOwner;

  // Mapping from owner to number of owned tokens
  mapping(address => Counters.Counter) private _ownedTokensCount;

  // Mapping from token id to approves addresses
  mapping(uint256 => address) private _tokenApprovals;

  constructor() {
    _registerInterface(bytes4(
      keccak256('balanceOf(bytes4)')^
      keccak256('ownerOf(bytes4)')^
      keccak256('transferFrom(bytes4)')
    ));
  }

  // We'll find the current balanceOf
  /// @notice Count all NFTs assigned to an owner
  /// @dev NFTs assigned to the zero address are considered invalid
  /// function throws for queries about the zero address.
  /// @param _owner An Address for whom to query the balance
  /// @return The number of NFTs owned by '_owner', possibly zero
  function balanceOf(address _owner) public override view returns(uint256) {
    require(_owner != address(0), 'owner query for non-existent token');
    return _ownedTokensCount[_owner].current();
  }

  /// @notice Find the owner of an NFT
  /// @dev NFTs assigned to the zero address are considered invalid, and queries about them do throw
  /// @param _tokenId The identifier for an NFT
  /// @return The address of the owner of the NFT
  function ownerOf(uint256 _tokenId) public override view returns(address) {
    address owner = _tokenOwner[_tokenId];
    require(owner != address(0), 'owner query for non-existent token');
    return owner;
  }

  function _exists(uint256 _tokenId) internal view returns(bool) {
    // setting the address of nft owner to check the mapping of the address from tokenOwner at the tokenId
    address owner = _tokenOwner[_tokenId];
    // return the truthiness that the address is not zero
    return owner != address(0);
  }

  function _mint(address _to, uint256 _tokenId) internal virtual {
    // requires that the address isn't zero
    require(_to != address(0), 'ERC721: minting to the zero address');
    // requires that the token does not already exist
    require(!_exists(_tokenId), 'ERC721: token already minted');
    // we are adding a new address with a token id for minting
    _tokenOwner[_tokenId] = _to;
    // keeping track of each address that is minting and adding one to the count
    _ownedTokensCount[_to].increment();

    emit Transfer(address(0), _to, _tokenId);
  }

  /// @notice Transfer ownership of an NFT
  /// @dev Throws unless 'msg.sender' is the current owner, an authorized operator, or the approved address for this NFT.
  /// Throws if '_from' is not the current owner. Throws if '_to' is the zero address. Throws if '_tokenId' is not a valid NFT
  /// @param _from The current owner of teh NFT
  /// @param _to The new owner
  /// @param _tokenId The NFT to transfer
  function _transferFrom(address _from, address _to, uint256 _tokenId) internal {
    require(_to != address(0), 'ERC721: Transfer to the zero address');
    require(ownerOf(_tokenId) == _from, 'ERC721: Trying to transfer a token the address does not own');
    
    _ownedTokensCount[_from].decrement();
    _ownedTokensCount[_to].increment();

    _tokenOwner[_tokenId] = _to;

    emit Transfer(_from, _to, _tokenId);
  }

  function transferFrom(address _from, address _to, uint256 _tokenId) override public {
    require(isApprovedOrOwner(msg.sender, _tokenId));
    _transferFrom(_from, _to, _tokenId);
  }

  // require that the person approving is the owner
  // approve an address to a token
  // require that we can't approve sending tokens fo the owner to the owner (caller)
  // update the map of the approval addresses
  function approve(address _to, uint256 _tokenId) public {
    address owner = ownerOf(_tokenId);
    require(_to != owner, 'Error - approval to current owner');
    require(msg.sender == owner, 'Current caller is not the owner of the token');
    _tokenApprovals[_tokenId] = _to;

    emit Approval(owner, _to, _tokenId);
  }

  function isApprovedOrOwner(address _spender, uint256 _tokenId) internal view returns(bool) {
    require(_exists(_tokenId), 'token does not exist');
    address owner = ownerOf(_tokenId);
    return(_spender == owner);
    // || getApproved(_tokenId) == _spender;
  }

}