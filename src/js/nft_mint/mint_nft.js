require("dotenv").config({ path: require('find-config')('.env') });
const ethers = require('ethers');
const { SocksProxyAgent } = require('socks-proxy-agent');
const INFURA_ID = process.env.infuraId;
const PRIVATE_KEY = process.env.privateKey;
const abi = require('./abi.js');


const test = async () => {
    //设置成代理
    const ethersOptions = {
        url: `https://goerli.infura.io/v3/${INFURA_ID}`,
        agent: { https: new SocksProxyAgent('socks5h://127.0.0.1:7890') }
    }
    //创建rpc服务商节点
    const provider = new ethers.providers.JsonRpcProvider(ethersOptions);
    //创建钱包对象
    const wallet = new ethers.Wallet(PRIVATE_KEY, provider);
    //自己部署的合约
    let contract = new ethers.Contract('0xfbAbfEEfA99a2923e4Fc7EB202485c6B2E0977AC', abi.abi, wallet);
    //监听合约状态
    let wlMintStatus = await contract.wlMintStatus.call();
    console.log(`wlMintStatus:${wlMintStatus},类型：${typeof wlMintStatus}`);

    let publicMintStatus = await contract.publicMintStatus.call();
    console.log(`publicMintStatus:${publicMintStatus},类型：${typeof publicMintStatus}`);


    // while (!wlMintStatus) {
    //     wlMintStatus = await contract.wlMintStatus.call();
    //     console.log(`wlMintStatus:${wlMintStatus}`);
    // }
 

    const mintNum = 2;
    const mintPrice = mintNum * 0.0001;

    try {
        //mint nft
        const tx = await contract.wlMint(mintNum, {
            value: ethers.utils.parseEther(mintPrice.toString()),
            maxFeePerGas: ethers.utils.parseUnits("22", "gwei"),
            maxPriorityFeePerGas: ethers.utils.parseUnits("1.14", "gwei"),
        });
        // 等待交易完成
        await tx.wait();
        console.log('交易成功，mint 操作成功！');
    } catch (error) {
        console.error('交易失败，mint 操作失败！', error);
    }
}
test()
