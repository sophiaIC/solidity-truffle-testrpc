module.exports = function(callback,network,accounts) {
    var ICLD_artifact = artifacts.require("ICLD");
    var BOOK_artifact= artifacts.require("BOOK");

    var ICL_bank= web3.eth.accounts[0]
    var alice = web3.eth.accounts[1]
    var bob = web3.eth.accounts[2]
    ICLD_artifact.deployed().then(function(instance){
        return instance.balanceOf(ICL_bank)
    }).then(function(res) {
        console.log(res.toNumber());
    }).catch(function(e) {
        console.log(e);
    })
    BOOK_artifact.deployed().then(function(instance){
        return instance.balanceOf(alice);
    }).then(function(res) {
        console.log(res.toNumber());
    }).catch(function(e) {
        console.log(e);
    })
    ICLD_artifact.deployed().then(function(instance){
        return instance.transfer(bob, 1, {from: ICL_bank});
    }).then(function(res) {
		console.log(res.logs[0].event);
		console.log(res.logs[0].args);
	}).catch(function(e) {
		console.log(e);
	})
}
