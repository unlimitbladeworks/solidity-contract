const MyFirstNft = artifacts.require("MyFirstNft");

module.exports = function (deployer) {
  deployer.deploy(MyFirstNft);
};