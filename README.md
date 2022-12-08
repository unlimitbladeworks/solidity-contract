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