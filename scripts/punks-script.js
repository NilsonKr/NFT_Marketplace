const { ethers } = require("ethers");

async function deployPunks() {
  const [deployer] = await ethers.getSigners();

  console.log("Deploying Punks contract to : %s", deployer.address);

  const PunksContract = await ethers.getContractFactory("Punks");
  const deployed = await PunksContract.deploy();

  console.log("Punks deployed to: %s", deployed.address);
}

deployPunks()
  .then(() => process.exit(0))
  .catch((err) => {
    console.error(err);
    process.exit(1);
  });
