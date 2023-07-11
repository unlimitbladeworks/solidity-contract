require("dotenv").config({ path: require('find-config')('.env') });
const ethers = require('ethers');
const { SocksProxyAgent } = require('socks-proxy-agent');
const INFURA_ID = process.env.infuraId;
const PRIVATE_KEY = process.env.privateKey;
const abi = require('./abi.js');


const mintNft = async () => {
    console.log('开始运行...');
    url = `https://mainnet.infura.io/v3/${INFURA_ID}`;
    https://mainnet.infura.io/v3/e6c19102a27040aabf279dab0f35bd53
    console.log(`初始化node-url:${url}`);
    //设置成代理
    const ethersOptions = {
        // url: `https://goerli.infura.io/v3/${INFURA_ID}`,
        url: url,
        agent: { https: new SocksProxyAgent('socks5h://127.0.0.1:7890') }
    }
    //创建rpc服务商节点
    const provider = new ethers.providers.JsonRpcProvider(ethersOptions);
    console.log('1. 创建rpc服务商节点完成...');
    //创建钱包对象
    const wallet = new ethers.Wallet(PRIVATE_KEY, provider);
    console.log('2. 创建钱包对象完成...');
    //自己部署的测试合约
    // let contract = new ethers.Contract('0xfbAbfEEfA99a2923e4Fc7EB202485c6B2E0977AC', abi.abi, wallet);
    const contractABI = [
        'function saleActive() public view returns (bool)',
        'event SaleStateChanged(bool newSaleActiveStatus)'
      ];
    let contract = new ethers.Contract('0x7D33b7863C4157B65f6E1c734a0Bc7E1dc24Df26', contractABI, wallet);
    console.log(`3. 创建合约对象完成...${contract}`);

    //监听合约状态
    // let paused = await contract.saleActive.call();
    let paused = await contract.saleActive();
    console.log(`4. 监听合约状态wlMintStatus:${wlMintStatus},类型：${typeof wlMintStatus}`);

    //todo 没公售就暂时注释掉
    // let publicMintStatus = await contract.publicMintStatus.call();
    // console.log(`5. 监听合约状态publicMintStatus:${publicMintStatus},类型：${typeof publicMintStatus}`);


    while (!paused) {
        paused = await contract.saleActive.call();
        console.log(`saleActive:${saleActive}`);
    }
 

    // const mintNum = 1;
    // const mintPrice = mintNum * 0.0;

    // try {
    //     //mint nft
    //     const tx = await contract.mint(mintNum, {
    //         value: ethers.utils.parseEther(mintPrice.toString()),
    //         maxFeePerGas: ethers.utils.parseUnits("40", "gwei"),
    //         maxPriorityFeePerGas: ethers.utils.parseUnits("2.5", "gwei"),
    //     });
    //     // 等待交易完成
    //     await tx.wait();
    //     console.log('交易成功，mint 操作成功！');
    // } catch (error) {
    //     console.error('交易失败，mint 操作失败！', error);
    // }
    console.log('运行结束...');
}
mintNft()
