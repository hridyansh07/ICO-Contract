// SPDX-License-Identifier: MIT

pragma solidity >0.6.7;

import "../Access/Ownable.sol";
import "../PriceLink/PriceOracle.sol";
import "../Token/ERC20.sol";
import "../WhiteList/WhiteList.sol";

contract CrowdSale is Ownable,WhiteList{

    using SafeMath for uint256;
    
    bool public privateSale;
    bool public preSale;
    bool public crowdSale;
    bool public icoCompeleted;
    bool public isPaused;
    uint256 public icoStartTime;
    uint256 public icoEndTime;
    address public tokenAddress;
    uint256 public tokenRate;
    uint internal ethUsdPrice;
    uint internal usdPrice;
    PriceOracle price;
    uint256 internal tokensToBeGiven;
    uint256 public minimumInvestmentAmount; 
    uint256 public totalInvested;
    uint256 public softCap;
    address payable ownerAddress;
    XToken public token;
    
    event CrowdSaleStarted();
    event CrowdSalePaused();
    event CrowdSaleResumed();
    event PrivateSaleStarted();
    event PrivateSaleEnded();
    event PreSaleStarted();
    event PreSaleEnded();
    event RateChanged(uint);
    

    constructor(uint256 _icoStart, uint256 _icoEnd, uint256 _tokenRate , address _tokenAddress , address payable _OwnerAddress) 
    {
        require(_icoStart != 0 &&
      _icoEnd != 0 &&
      _icoStart < _icoEnd &&
      _tokenRate != 0 &&
      _tokenAddress != address(0));
      icoStartTime = _icoStart;
      icoEndTime = _icoEnd;
      minimumInvestmentAmount = 500;
      softCap = 5000000;
      privateSale = true;
      preSale = false;
      crowdSale = false;
      ownerAddress = _OwnerAddress;
      token = XToken(_tokenAddress);
    }


  modifier crowdSaleInProgress()
  {
    require(!isPaused);
    _;
  }
  
  modifier privateSaleInProgress()
  {
      require(privateSale);
        _;
  }
  
  modifier preSaleInProgress()
  {
      require(preSale);
      _;
  }
  
  modifier capReached()
  {
      require(totalInvested + msg.value <= softCap , "Sorry Limit Cap Reached");
      _;
  }
  
  function pauseCrowdSale() public 
  onlyOwner
  {
    _pauseCrowdSale();
  }

  function resumeCrowdSale() public  
  onlyOwner
  {
     _resumeCrowdSale();
  }
  
  function endPrivateSale() public
  onlyOwner
  {
    _endPrivateSale();      
  }
  
  function _endPrivateSale() internal 
  {
      privateSale = false;
      emit PrivateSaleEnded();
  }
  
  function startPreSale() public 
  onlyOwner{
      _startPreSale();
  }

  function _startPreSale() internal {
      preSale = true ;
      emit PreSaleStarted();
  }

  function endPreSale() public 
  onlyOwner
  {
    _endPreSale();
  }
  
  function _endPreSale() internal {
      preSale = false;
      emit PreSaleEnded();
  }
  
  function _resumeCrowdSale() internal {
    isPaused = false;
    emit CrowdSaleResumed();
  }

  function _pauseCrowdSale() internal {
    isPaused = true;
    emit CrowdSalePaused();
  }
  
  function changeRate(uint _tokenRate) public onlyOwner {
      _changeRate(_tokenRate);
  }
  
  function _changeRate(uint _tokenRate) internal {
      tokenRate = _tokenRate;
      emit RateChanged(tokenRate);
  }

  function buyPrivateSale() public payable
  privateSaleInProgress
  isWhiteListed(msg.sender)
  capReached
  
  {
    _getRate();
    usdPrice = ethUsdPrice.mul((msg.value/1 ether)); 
    require(usdPrice >= minimumInvestmentAmount,"Minimum Investment Amount 500 Dollars");
    tokensToBeGiven = calculateToken(usdPrice);
    token.buyTokens(msg.sender,tokensToBeGiven);
    ownerAddress.transfer(msg.value);
  }
  
  function buyPreSale() public payable
  preSaleInProgress
  isWhiteListed(msg.sender) 
  capReached
  
  {
      _getRate();
      usdPrice = ethUsdPrice.mul((msg.value/1 ether));
      require(usdPrice >= minimumInvestmentAmount,"Minimum Investment Amount 500 Dollars");
      tokensToBeGiven = calculateToken(usdPrice);
      token.buyTokens(msg.sender , tokensToBeGiven);
      ownerAddress.transfer(msg.value);
  }

  function buyCrowdSale() public payable
  crowdSaleInProgress
  capReached
  
  {
      _getRate();
      usdPrice = ethUsdPrice.mul((msg.value/1 ether));
      require(usdPrice >= minimumInvestmentAmount,"Minimum Investment Amount 500 Dollars");
      tokensToBeGiven = calculateToken(usdPrice);
      token.buyTokens(msg.sender, tokensToBeGiven);
      ownerAddress.transfer(msg.value);
  }

  function calculateToken(uint256 _usdPrice) internal view returns(uint tokens)
  {
    if(privateSale)
    {
        tokens = _usdPrice * tokenRate;
        uint bonus = (tokens * 25) / 100;
        tokens = tokens.add(bonus);
        return(tokens);
    }
    if(preSale)
    {
         tokens = _usdPrice * tokenRate;
        uint bonus = (tokens * 20)/100;
        tokens = tokens.add(bonus);
        return(tokens);
    }
    if(crowdSale)
    {
        if(((((block.timestamp - icoStartTime)/ 60) / 60) / 24) >= 7 )
        {
             tokens = _usdPrice * tokenRate;
            uint bonus = (tokens * 15)/100;
            tokens = tokens.add(bonus);
            return(tokens);
        }
        if(((((block.timestamp- icoStartTime)/ 60) / 60) / 24) >= 14 )
        {
             tokens = _usdPrice * tokenRate;
            uint bonus = (tokens * 10)/100;
            tokens = tokens.add(bonus);
            return(tokens);
        }
        if(((((block.timestamp- icoStartTime)/ 60) / 60) / 24) >= 21 )
        {
             tokens = _usdPrice * tokenRate;
            uint bonus = (tokens * 5)/100;
            tokens = tokens.add(bonus);
            return(tokens);
        }
        if(((((block.timestamp - icoStartTime)/ 60) / 60) / 24) >= 28 )
        {
             tokens = _usdPrice * tokenRate;
            return(tokens);
        }
        
    }
    
  }


    function _getRate() internal crowdSaleInProgress
    {
      ethUsdPrice = price.getLatestPrice();
    }
}