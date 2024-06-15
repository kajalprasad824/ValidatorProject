const{ethers,upgrades} = require("hardhat");

async function main(){
    const gas = (await ethers.provider.getFeeData()).gasPrice;
    const MiniContract = await ethers.getContractFactory("MiniValidator");
    console.log("Deploying Mini Validator Contract ......");
    const miniContract = await upgrades.deployProxy(MiniContract,"0x4b6428460Dc6D016f8dcD8DF2612109539DC1562", {
        gasPrice: gas,
        initializer: "initialValue",
    });

    await miniContract.waitForDeployment();
    console.log("Major Validator contract deployed to : ",await miniContract.getAddress());
}

main().catch((error) => {
    console.error(error);
    process.exitCode = 1;
});