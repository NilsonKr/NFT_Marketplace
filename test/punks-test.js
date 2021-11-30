const { expect } = require("chai");

describe("CrazyPunks smart-contract", () => {
  const setup = async ({ maxSupply = 10 }) => {
    const [owner] = await ethers.getSigners();
    const CrazyPunks = await ethers.getContractFactory("CrazyPunks");
    const deployed = await CrazyPunks.deploy(maxSupply);

    return {
      owner,
      deployed,
    };
  };

  it("Deploying contract", async () => {
    const { owner, deployed } = await setup({ maxSupply: 20 });

    const contractMaxSupply = await deployed.maxSupply();

    expect(contractMaxSupply).to.equal(20);
    expect(deployed.signer.address).to.be.equal(owner.address);
  });

  describe("Minting NFTs", () => {
    it("Testing balance and owners", async () => {
      const { owner, deployed } = await setup({ maxSupply: 20 });

      //Mint NFT
      await deployed.mintToken();
      await deployed.mintToken();

      expect(await deployed.ownerOf(0)).to.be.equal(owner.address);
      expect(await deployed.balanceOf(owner.address)).to.be.equal(2);
    });

    it("Max supply applied", async () => {
      const { deployed } = await setup({ maxSupply: 2 });
      const revertedMsg = "No CrazyPunks Left, sory :( not sory :3";

      //Mint NFT
      await deployed.mintToken();
      await deployed.mintToken();

      await expect(deployed.mintToken()).to.be.revertedWith(revertedMsg);
    });
  });

  describe("Testing NFT's TokenURI", () => {
    it("Testing tokenURI format", async () => {
      const { deployed } = await setup({});

      //Mint test NFT
      await deployed.mintToken();

      const tokenURI = await deployed.tokenURI(0);
      const [, JSONbase64] = tokenURI.split("data:application/json;base64,");

      const parsedBase64 = Buffer.from(JSONbase64, "base64").toString();
      const parsedJSON = JSON.parse(parsedBase64);

      expect(parsedJSON.name).to.be.equal("CrazyPunk #" + 0);
      expect(parsedJSON).to.have.all.keys(["name", "description", "image"]);
    });
  });
});
