// SPDX-License-Identifier: MIT
pragma solidity ^0.8.18;

import {AggregatorV3Interface} from "@chainlink/contracts/src/v0.8/shared/interfaces/AggregatorV3Interface.sol";
// import "./MockAggregator_PriceFeed.sol";
// libraries cant have any state variable
// all the functions in library must be marked "internal " instead of public

library PriceConverter{
 function getPrice() internal view returns (uint256){
        //address - 0x694AA1769357215DE4FAC081bf1f309aDC325306
        //chainlink ABI OF AGGREGATORV3Interface

        AggregatorV3Interface pricefeed = AggregatorV3Interface(0x694AA1769357215DE4FAC081bf1f309aDC325306);
        // AggregatorV3Interface pricefeed = AggregatorV3Interface(0xE73E34dc58E839eF58B64B3FC81F37BC864a9065);
        (, int256 price ,,,)=pricefeed.latestRoundData();
        //price variable rfer the price of eth in USD
        // price have 8 decimal places, msg.value have 18 decimal Places
        // 2000.00000000
        return uint256(price) * 1e10;
    }

    function getConversionRate(uint256 ethammount) internal view returns(uint256){
        //msg.value.getConversionRate(); here the msg.value is the by default 1st input parameter for getConversionRate(). 
        uint256 ethPrice = getPrice();
        // we are dividing with 1e18 because due to multiplication the value will become 1e36, but we want in e18.
        uint256 ethammount_in_USD = (ethPrice*ethammount)/1e18;
        return ethammount_in_USD;// it is returning in the power of e18
    }

//     function getVersion () internal  view  returns (uint256){
//         return AggregatorV3Interface(0xE73E34dc58E839eF58B64B3FC81F37BC864a9065).version();
//     }
}
