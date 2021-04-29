/**
 * LibertyPie (https://libertypie.com)
 * @author LibertyPie <hello@libertypie.com>
 * factory_add_asset.js
 */
module.exports = {
    contract: 'Factory',
    method:   'addAsset',
    data: [

        // Bitcoin [renBTC]
        [
            "0x0A9ADD98C076448CBcFAcf5E457DA12ddbEF4A8f", //contractAddress
            true, //isPegged
            "0x55363c0dBf97Ff9C0e31dAfe0fC99d3e9ce50b8A", // peggedAssetGateway
            "Bitcoin", //originalName
            "BTC", //originalSymbol
            "chainlink", //priceFeedProvider
            true // isEnabled
        ],

        
        [
            "0x42805DA220DF1f8a33C16B0DF9CE876B9d416610", //contractAddress
            true, //isPegged
            "0xAACbB1e7bA99F2Ed6bd02eC96C2F9a52013Efe2d", // peggedAssetGateway
            "ZCash", //originalName
            "ZEC", //originalSymbol
            "chainlink", //priceFeedProvider
            true // isEnabled
        ]
    ]
}