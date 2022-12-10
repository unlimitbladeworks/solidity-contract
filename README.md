# truffle 合约部署参考 demo

本仓库为本人自用的 solidity 代码仓库，开源出来供大家参考

contracts ：部署合约的源代码  
migrations：部署合约的js脚本  
truffle-config.js: truffle的配置文件


# 配置

truffle-config.js 需要修改代理端口号：

```js
//开源的truffle验证插件，需要配置你本地代理的端口号
plugins: ['truffle-plugin-verify'],
  verify: {
    proxy: {
      host: '127.0.0.1',
      port: '41091'
    }
  },

```

truffle-config.js 需要几个配置的 key ，需要自行在同级目录下创建 .env 文件。  

linux命令：
```linux
touch .env
或者
vim .env 复制下面的内容然后 :wq 即可
```

```js
privateKey=你部署合约钱包的私钥
infuraId=infura公司申请的id
etherscanApiKey=etherscan申请的api key
```

根据自己的 solidity 编译版本，修改下面的版本号
```js
  compilers: {
    solc: {
      version: "0.8.15",      // Fetch exact version from solc-bin (default: truffle's version)
      // docker: true,        // Use "0.5.1" you've installed locally with docker (default: false)
      settings: {          // See the solidity docs for advice about optimization and evmVersion
        optimizer: {
          enabled: true,
          runs: 200
        },
        evmVersion: "london"
      }
    }
  },
```



# 启动运行


进入到主目录，执行命令:

```js
npm install
```
修改你要部署的脚本，前缀需要加 1_ ，truffle有文件命名的识别
安装完毕后，回到主目录执行你要部署的脚本：
```js
truffle migrate --network goerli
//最早是rinkeby，但以太坊转为 pos 后，rinkeby暂时不支持测试网了
truffle migrate --network rinkeby  
```

开源验证命令：  
  
```js
truffle run verify NFTAllowlist  --network goerli --debug
```

# 额外参考

之前写过一篇文章，关于如何从 0 开始用 truffle 部署合约的，可以参考：

https://mirror.xyz/yidakoumi.eth/Uy-JQu3i6gJptGk9AfQVVWuYPu2rGGJNrUg4j9-UDIw