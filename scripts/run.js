const main = async () => {
    const [owner, randomPerson] = await hre.ethers.getSigners();
    const respectContractFactory = await hre.ethers.getContractFactory('RespectPortal');
    const respectContract = await respectContractFactory.deploy({
        value: hre.ethers.utils.parseEther('0.1'),
    });
    await respectContract.deployed();
    console.log('Contract deployed to:', respectContract.address);

    console.log('Contract deployed by: ', owner.address);
    /*
    * Get Contract balance
    */
    let contractBalance = await hre.ethers.provider.getBalance(
        respectContract.address
    );
    console.log(
        'Contract balance:',
        hre.ethers.utils.formatEther(contractBalance)
    );
    let respectCount;
    respectCount = await respectContract.getTotalRespect();
    
    let respectTxn = await respectContract.sendRespect('A message');
    await respectTxn.wait();

    contractBalance = await hre.ethers.provider.getBalance(
        respectContract.address
    );
    console.log(
        'Contract balance:',
        hre.ethers.utils.formatEther(contractBalance)
    );

    respectCount = await respectContract.getTotalRespect();

    respectTxn = await respectContract.connect(randomPerson).sendRespect('Another message!');
    await respectTxn.wait();
    
    const allRespectMessages = await respectContract.getAllRespectMessages();
    console.log(allRespectMessages)
}

const runMain = async () => {
    try {
        await main();
        process.exit(0);
    } catch (e) {
        console.log(e);
        process.exit(1);
    }
}

runMain()