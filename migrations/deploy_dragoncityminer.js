const DragonCityMiner = artifacts.require("DragonCityMiner");

module.exports = function (deployer) {
  deployer.deploy(DragonCityMiner,
    '0xff20E68CFEB92d788443b754e688B5a0795dE420',
    '0x895109E07f847A968a55cF7F25eA4e916dF819Df',
    '0x895109E07f847A968a55cF7F25eA4e916dF819Df',
    1692334800);
};
//goerli token contract : 0xff20E68CFEB92d788443b754e688B5a0795dE420 
//goerli minter contract : 0xe0C7617D6bbE2962f8ED4d40caB32F52d445C155