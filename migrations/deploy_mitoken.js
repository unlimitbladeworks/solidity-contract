const DaMiToken = artifacts.require("DaMiToken");

module.exports = function (deployer) {
  deployer.deploy(DaMiToken,"DaMiToken","DaMi-Token");
};
