const{ethers,upgrades} = require("hardhat");

async function main(){
    const gas = (await ethers.provider.getFeeData()).gasPrice;
    const MajorContract = await ethers.getContractFactory("MajorValidator");
    console.log("Deploying Major Validator Contract ......");
    const majorContract = await upgrades.deployProxy(MajorContract,"0x4b6428460Dc6D016f8dcD8DF2612109539DC1562", {
        gasPrice: gas,
        initializer: "initialValue",
    });

    await majorContract.waitForDeployment();
    console.log("Major Validator contract deployed to : ",await majorContract.getAddress());
}

main().catch((error) => {
    console.error(error);
    process.exitCode = 1;
});