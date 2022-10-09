// imports
const { ethers, run, network } = require('hardhat')
// async main
async function main() {
    const MoonSentFactory = await ethers.getContractFactory(
        'MoonSent'
    )
    console.log('🔄 Deploying MoonSent...')
    const moonSent = await MoonSentFactory.deploy()
    await moonSent.deployed()
    console.log('🚢 MoonSent is deployed to', moonSent.address)
    if (network.config.chainId == 5 && process.env.ETHERSCAN_API_KEY) {
        await moonSent.deployTransaction.wait(6)
        await verify(moonSent.address, [])
    } else {
        console.log('🚫 Skipping Etherscan verification')
    }
}

async function verify(contractAddress, args) {
    console.log('✔️ Verifying contract...')
    try {
        await run('verify:verify', {
            address: contractAddress,
            constructorArguments: args,
        })
    } catch (e) {
        if (e.message.toLowerCase().includes('already verified')) {
            console.log('✔️ Contract is already verified')
        } else {
            console.log(e)
        }
    }
}

main()
    .then(() => process.exit(0))
    .catch((error) => {
        console.error(error)
        process.exit(1)
    })
