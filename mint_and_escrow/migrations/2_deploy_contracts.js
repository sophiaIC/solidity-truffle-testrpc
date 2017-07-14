var ICLD = artifacts.require("ICLD");
var BOOK = artifacts.require("BOOK")
var AliceWallet = artifacts.require("AliceWallet")
var BobWallet = artifacts.require("BobWallet")
var Escrow = artifacts.require("Escrow")

module.exports = function(deployer,network,accounts) {
    var mint;
    deployer.deploy(ICLD,1000,"Imperial Dollars",2,"$",{from: accounts[0]}).then(function(){
        mint = ICLD.address;
    });
    deployer.deploy(BOOK,1,"Book",0,"B",{from: accounts[1]});

    deployer.deploy(Escrow, accounts[1], 1, accounts[2], 50, {from: accounts[3]}); 
};
