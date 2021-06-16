// SPDX-License-Identifier: MIT

pragma solidity >=0.6.7;

contract WhiteList {

  mapping (address => bool) public whiteList;
  

  function addToWhitelist(address[] memory _whiteList)  public{
    for (uint i = 0; i < _whiteList.length; i++) {
      whiteList[_whiteList[i]] = true;
    }
  }
  
  function removeFromWhiteList(address[] memory _whiteList) public
  {
      for(uint i=0 ; i< _whiteList.length ; i++)
      {
          whiteList[_whiteList[i]] = false;
      }
  }

  function isWhiteList(address _member) public view returns (bool) {
    return whiteList[_member] == true;
  }
  
  modifier isWhiteListed(address _member) {
      require(whiteList[_member]);
      _;
  }
}