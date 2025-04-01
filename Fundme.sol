// get funds from users
//  withdraw funds
// Set a minimum funding value in USD



// SPDX-License-Identifier: MIT
pragma solidity ^0.8.18;

// import {AggregatorV3Interface} from "@chainlink/contracts/src/v0.8/interfaces/AggregatorV3Interface.sol";
import {PriceConverter} from "PriceConverter.sol";
contract FundMe{


        using PriceConverter for uint256;
        // all uint256 have access to price converter

        // set a minimum value say $5
        // if we use "constant", " immutable" keywords to those variable which are not going to change, It will drastically resude the gas cost

        uint256 public min_USD = 1 * 1e15;

        address[] public funders;
        // funders is just keeping the records of funder
        mapping (address funder => uint256 ammountfunded) public addressToAmmountFunded;
        // mapping is the actual important thing in which we are storing the ammount w.r.t funders

        address public immutable i_owner;
        constructor(){
            i_owner = msg.sender;
        }


function fund() public payable {
    require(msg.value > 0, "No ETH sent!");  // Debug line 1
    uint256 conversion = msg.value.getConversionRate();
    require(conversion >= min_USD, "Didnt send enough ETH"); // Debug line 2
    funders.push(msg.sender);
    addressToAmmountFunded[msg.sender] += msg.value;
}

    // function fund() public payable  {
    //     //allow user to send money
    
    //     // msg.value :- value to be sent along with message(accepts ETH )
    //     // 1 e18 = 1 ETH = 1000000000000000000 = 1 * 10^18
    //     require(msg.value.getConversionRate() >= min_USD, "Didnt send enough ETH"); //Here the msg.value is the by default 1st input parameter for getConversionRate().
    //     //i.e anybody should send more then min_USD ETH or else the transcation will get " revert " the whole with a message and goes into its initial state
    //     // msg.value.getConversionRate();
    //     // 
    //     funders.push(msg.sender);
    //     addressToAmmountFunded[msg.sender] += msg.value;

    
    // }
    // only owner should call this withdraw function, hence we made a constructor
    function Withdraw() public onlyOwner{
        // we will sue for loop to reset
        // require(msg.sender == owner,"You are not the owner");


        for(uint256 funderIndex = 0;funderIndex < funders.length;funderIndex++){
            // get the address of funder who is withdrawing the money
            address funder_address = funders[funderIndex];
            // input the obtained address to mapping variable and set it to 0.
            addressToAmmountFunded[funder_address] = 0;
        }
        // Resetting the Array
        funders = new address[](0);
// there are 3 types to send money from contract- 
        // tranfer
        // send
        // call 

    // transfer : it uses 2100 gas fee,throws error
        // msg. sender is type address and we want it to be "payable address" type
        // payable(msg.sender).transfer(address(this).balance);

    // send : uses 2300max gas and returns bool
        // bool success = payable(msg.sender).send(address(this).balance);
        // require(success,"send_Failed");

    // call : no gas cap, returns bool
        (bool callsuccess,) = payable (msg.sender).call{value: address(this).balance}("");
        require(callsuccess,"call_Failed");


    }


// Below Code are in the form of library (Price Converter.sol )

    // function getPrice() public view returns (uint256){
    //     //address - 0x694AA1769357215DE4FAC081bf1f309aDC325306
    //     //chainlink ABI OF AGGREGATORV3Interface

    //     AggregatorV3Interface pricefeed = AggregatorV3Interface(0x694AA1769357215DE4FAC081bf1f309aDC325306);
    //     (, int256 price ,,,)=pricefeed.latestRoundData();
    //     //price variable rfer the price of eth in USD
    //     // price have 8 decimal places, msg.value have 18 decimal Places
    //     // 2000.00000000
    //     return uint256(price) * 1e10;
    // }

    // function getConversionRate(uint256 ethammount) public view returns(uint256){
    //     uint256 ethPrice = getPrice();
    //     // we are dividing with 1e18 because due to multiplication the value will become 1e36, but we want in e18.
    //     uint256 ethammount_in_USD = (ethPrice*ethammount)/1e18;
    //     return ethammount_in_USD;// it is returning in the power of e18
    // }

    // function getVersion () public view  returns (uint256){
    //     return AggregatorV3Interface(0x694AA1769357215DE4FAC081bf1f309aDC325306).version();
    // }

    // we are using modifiers so that we dont have to use " require " to check the withdraw person is the actual owner or not

    modifier onlyOwner() {
        require(msg.sender == i_owner, "Sender is not owner");
        _; // these are the lines of code of funciton, hence position of _ does matters
    }
}

// by using revert(); we can revert the fuction instantaneously