var web3;
var chainId;
async function connect() {
    if (window.ethereum) {
        try {
            await window.ethereum.enable();
        } catch (error) {
            console.error("User denied account access!");
        }
        web3 = new Web3(window.ethereum);
    } else if (windows.web3) {
        web3 = new Web3(window.ethereum);
    } else {
        alert("Please install MetaMask!");
    }

    chainId = await web3.eth.getChainId();
}