// SPDX-License-Identifier: MIT

pragma solidity  >=0.6.7;
import "../../node_modules/@chainlink/contracts/src/v0.6/interfaces/AggregatorV3Interface.sol";


// Kovan Test Network
contract PriceOracle {

    AggregatorV3Interface internal priceFeed;

    /**
     * Network: Kovan
     * Aggregator: ETH/USD
     * Address: 0x9326BFA02ADD2366b30bacB125260Af641031331
     */
    constructor() {
        priceFeed = AggregatorV3Interface(0x9326BFA02ADD2366b30bacB125260Af641031331);
    }

    /**
     * Returns the latest price
     */
    function getLatestPrice() public  returns (uint) {
        (
            uint80 roundID, 
            int price,
            uint startedAt,
            uint timeStamp,
            uint80 answeredInRound
        ) = priceFeed.latestRoundData();
        uint priceChanged = changePriceType(price);
        return priceChanged;
    }
    
    function changePriceType(int _price) internal pure returns(uint)
    {
        return uint(_price);
    }
}