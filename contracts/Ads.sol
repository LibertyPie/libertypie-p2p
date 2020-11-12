// SPDX-License-Identifier: MIT
pragma solidity ^0.6.2;

import "./Assets.sol";
import "@openzeppelin/contracts/token/ERC20/IERC20.sol";


contract Ads {

    /*
     * @dev add a new ad  event  
     * @param address  _assetAddress, contract address  of  the asset
     * @param uint256 _priceMargin: extra  amount  to be added  to price in percentage  
     * @param address _adOwner: The ad owner's address 
     * @param string country: country  code of the  ad 
     * @param string  paymentMethod 
     */
    event _newAd(address indexed _assetAddress, uint256 _priceMargin, address indexed _adOwner, string country, string  paymentMethod);

    Assets  _assets;

    //total ads defaults  to 0
    uint256 totalAds;

    struct adStruct {
        address assetAddress;
        address adOwner;
        uint256 priceMargin;
        string  country;
        string  paymentMethod;
        bool    enabled;
    }

    //ads data
    //format is mapping(adIndex => adStruct)
    mapping(uint256 => adStruct) private adsData;

    //user ad index 
    //save  into user map
    //format  mapping( msg.sender =>  _index)
    mapping(address => uint256[]) private adIndexesByUserAddress;

    // assets  Ads  indexes 
    //format  mapping( assetAddress =>  _index)
    mapping(address => uint256[])  private adIndexesByAssetAddress;

    // ads indexes based  on country
     //format  mapping(countryCode =>  _index)
    mapping(string => uint256[]) private  adIndexesByCountryCode;

    //ads indexes based on paymentTypeId 
    mapping(string => uint256[]) private  adIndexesByPaymentType;

    /**
     * @dev add a  new ad 
     * @param _assetAddress the contract  address of the  asset  you wish to add the ad
     * @param _priceMargin the profit margin in percentage to add to the asset price
     * @param countryCode the country  where   ad is   targeted at
     * @param paymentMethod enabled payment method for the ad
     */
    function newAd(
        address  _assetAddress,
        uint256  _priceMargin,
        string   memory countryCode,
        string   memory paymentMethod
    ) public {


        //lets get  asset  info, 
        // this will validate asset info by address
        _assets.getAsset(_assetAddress);

        //check user  balance  for that asset,  if user balance  is 0, he cannot add an ad
        uint256 userBalance = IERC20(_assetAddress).balanceOf(msg.sender);

        require(userBalance > 0,"Insufficient balance");

        //adIndex 
        uint256 _index  = totalAds++;

        //lets  now inser  the  ad
        adsData[_index]  = adStruct(_assetAddress, msg.sender, _priceMargin,  countryCode, paymentMethod, true );

        //add ad  index for asset indexes 
        adIndexesByAssetAddress[_assetAddress].push(_index);

        //add  ad to user  ads  collections 
        adIndexesByUserAddress[msg.sender].push(_index);

        //add  index based on country 
        adIndexesByCountryCode[countryCode].push(_index);

        //add index  based on payment Type 
        adIndexesByPaymentType[countryCode].push(_index);

        emit  _newAd(_assetAddress,_priceMargin, msg.sender, countryCode, paymentMethod);
    } //end fun 

}  //end contract 