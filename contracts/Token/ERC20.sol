// SPDX-License-Identifier: MIT

pragma solidity >0.6.7;

import "../Access/Ownable.sol";

library SafeMath {
   function mul(uint256 a, uint256 b) internal pure returns (uint256 c) {
    
      if (a == 0) {
         return 0;
      }
      c = a * b;  
      assert(c / a == b);
      return c;
   }
   function div(uint256 a, uint256 b) internal pure returns (uint256) {
      // assert(b > 0); // Solidity automatically throws when dividing by 0
      // uint256 c = a / b;
      // assert(a == b * c + a % b); // There is no case in which this doesn't hold
      return a / b;
   }
   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
      assert(b <= a);
      return a - b;
   }
   function add(uint256 a, uint256 b) internal pure returns (uint256 c) {
      c = a + b;
      assert(c >= a);
      return c;
   }
}
contract Token {
    
   using SafeMath for uint256;
   event Transfer(address indexed from, address indexed to, uint256 value);
   event Approval(address indexed owner, address indexed spender, uint256 value);
   mapping(address => uint256) balances;
   uint256 totalSupply_;

   function totalSupply() public view returns (uint256) {
      return totalSupply_;
   }
   function transfer(address _to, uint256 _value) public returns (bool) {
      require(_value <= balances[msg.sender]);
      require(_to != address(0));
      balances[msg.sender] = balances[msg.sender].sub(_value);
      balances[_to] = balances[_to].add(_value);
      emit Transfer(msg.sender, _to, _value);
      return true;
   }
   function balanceOf(address _owner) public view returns (uint256) {
      return balances[_owner];
   }
   mapping (address => mapping (address => uint256)) internal allowed;
   function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
      require(_value <= balances[_from]);
      require(_value <= allowed[_from][msg.sender]);
      require(_to != address(0));
      balances[_from] = balances[_from].sub(_value);
      balances[_to] = balances[_to].add(_value);
      allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
      emit Transfer(_from, _to, _value);
      return true;
   }
   function approve(address _spender, uint256 _value) public returns (bool) {
      allowed[msg.sender][_spender] = _value;
      emit Approval(msg.sender, _spender, _value);
      return true;
   }
   function allowance(address _owner,address _spender) public view returns (uint256) {
      return allowed[_owner][_spender];
   }
   function increaseApproval(address _spender, uint256 _addedValue) public returns (bool) {
      allowed[msg.sender][_spender] = (allowed[msg.sender][_spender].add(_addedValue));
      emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);   
      return true;
   }
   function decreaseApproval(address _spender, uint256 _subtractedValue) public returns (bool) {
      uint256 oldValue = allowed[msg.sender][_spender];
      if (_subtractedValue >= oldValue) {
         allowed[msg.sender][_spender] = 0;
      } else {
         allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
      }
      emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
      return true;
   }
}

contract XToken is Token,Ownable {
   string public name = 'XToken';
   string public symbol = 'XT';
   uint256 public decimals = 18;
   address public crowdsaleAddress;
   address public reserveWallet;
   address public interestPayoutWallet;
   address public teamMembersHRWallet ;
   address public companyGeneralFundWallet;
   address public bounties;
   address public tokenSaleWallet;

    modifier onlyCrowdsale()
    {
        require(msg.sender == crowdsaleAddress);
      _;
    }
    
   constructor (address _reserveWallet , address _interestWallet , address _teamHrWallet , address _companyGenerealWallet , address _bounties , address _tokenSaleWallet , address _crowdsaleAddress)  Token() {
      totalSupply_ = 50000000000;
      reserveWallet = _reserveWallet;
      interestPayoutWallet = _interestWallet;
      teamMembersHRWallet = _teamHrWallet;
      companyGeneralFundWallet = _companyGenerealWallet;
      bounties = _bounties;
      tokenSaleWallet = _tokenSaleWallet;
      crowdsaleAddress = _crowdsaleAddress;
      balances[reserveWallet] = 20000000000;
      balances[interestPayoutWallet] = 10000000000;
      balances[companyGeneralFundWallet] = 5000000000;
      balances[bounties] = 1000000000;
      balances[tokenSaleWallet] = 12500000000;
   }

     function setCrowdsale(address _crowdsaleAddress) public onlyOwner {
      require(_crowdsaleAddress != address(0));
      crowdsaleAddress = _crowdsaleAddress;
   }
   
    function buyTokens(address _receiver, uint256 _amount) public onlyCrowdsale {
      require(_receiver != address(0));
      require(_amount > 0);
      transferFrom(tokenSaleWallet,_receiver, _amount);
   }
    
    
}