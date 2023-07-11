
require("dotenv").config({ path: require('find-config')('.env') });
const ethers = require('ethers');
const { FlashbotsBundleProvider, } = require("@flashbots/ethers-provider-bundle");
const { SocksProxyAgent } = require('socks-proxy-agent');
const INFURA_ID = process.env.infuraId;
const PRIVATE_KEY = process.env.privateKey;



console.log('开始运行...');
// const url = `https://mainnet.infura.io/v3/${INFURA_ID}`;
const url = `https://goerli.infura.io/v3/${INFURA_ID}`;
console.log(`初始化node-url:${url}`);
const FLASHBOTS_ENDPOINT = "https://relay-goerli.flashbots.net";

const GWEI = 10n ** 9n;
const ETHER = 10n ** 18n;
const CHAIN_ID = 5;

//设置成代理
const ethersOptions = {
    url: url,
    agent: { https: new SocksProxyAgent('socks5h://127.0.0.1:7890') }
}

//创建rpc服务商节点
const provider = new ethers.providers.JsonRpcProvider(ethersOptions);
const wallet = new ethers.Wallet(PRIVATE_KEY, provider);

async function main() {
    const flashbotsProvider = await FlashbotsBundleProvider.create(provider, ethers.Wallet.createRandom(), FLASHBOTS_ENDPOINT)
    provider.on('block', async (blockNumber) => {
      console.log(blockNumber)
      
      const bundleSubmitResponse = await flashbotsProvider.sendBundle(
        [
          {
            transaction: {
              chainId: CHAIN_ID,
              type: 2,
              value: ETHER / 100n * 3n,
              data: "0x1249c58b",
              maxFeePerGas: GWEI * 9n,
              maxPriorityFeePerGas: GWEI * 2n,
              to: "0x20EE855E43A7af19E407E39E5110c2C1Ee41F64D"
            },
            signer: wallet
          }
        ], blockNumber + 1
      )
  
      // By exiting this function (via return) when the type is detected as a "RelayResponseError", TypeScript recognizes bundleSubmitResponse must be a success type object (FlashbotsTransactionResponse) after the if block.
      if ('error' in bundleSubmitResponse) {
        console.warn(bundleSubmitResponse.error.message)
        return
      }
  
      console.log(await bundleSubmitResponse.simulate())
    })
  }
  
  main();
