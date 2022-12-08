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