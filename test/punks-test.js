const { expect } = require("chai");

const parseTokenURI = (tokenURI) => {
  const [, JSONbase64] = tokenURI.split("data:application/json;base64,");

  const parsedBase64 = Buffer.from(JSONbase64, "base64").toString();
  const parsedJSON = JSON.parse(parsedBase64);

  return parsedJSON;
};

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

      //Getting json parsed
      const TokenUriJSON = parseTokenURI(tokenURI);

      expect(TokenUriJSON.name).to.be.equal("CrazyPunk #" + 0);
      expect(TokenUriJSON).to.have.all.keys(["name", "description", "image"]);
    });

    it("Testing tokenURI image Url", async () => {
      const { deployed } = await setup({});
      const TOTAL_PUNK_PIECES = 13;

      //Mint test NFT
      await deployed.mintToken();
      const tokenURI = await deployed.tokenURI(0);

      //Getting json parsed
      const TokenUriJSON = parseTokenURI(tokenURI);

      //Crumbling image url

      const chunks = TokenUriJSON.image.split("?").slice(1)[0].split("&");

      expect(chunks.length).to.be.equals(TOTAL_PUNK_PIECES);
    });
  });

  describe("Testing NFT's DNA", () => {
    it("Correctly DNA generation", async () => {
      const { owner, deployed } = await setup({});
      const TOKEN_ID = 0;

      const dna = await deployed.generatePseudoRandomDNA(
        TOKEN_ID,
        owner.address
      );

      expect(dna._isBigNumber).to.be.true;
    });

    it("Deterministic DNA", async () => {
      const { owner, deployed } = await setup({});
      const TOKEN_ID = 0;

      //Generating two calls with same params
      const dna1 = await deployed.generatePseudoRandomDNA(
        TOKEN_ID,
        owner.address
      );

      const dna2 = await deployed.generatePseudoRandomDNA(
        TOKEN_ID,
        owner.address
      );

      //Third call with different token
      const dna3 = await deployed.generatePseudoRandomDNA(1232, owner.address);

      expect(dna1._hex).to.be.equals(dna2._hex);
      expect(dna1._hex).to.not.be.equals(dna3._hex);
    });

    it("Getting Attributes by dna", async () => {
      const { owner, deployed } = await setup({});
      const TOKEN_ID = 0;
      const ACCESORIES_TYPE = [
        "Blank",
        "Kurt",
        "Prescription01",
        "Prescription02",
        "Round",
        "Sunglasses",
        "Wayfarers",
      ];
      const HAIR_COLOR = [
        "Auburn",
        "Black",
        "Blonde",
        "BlondeGolden",
        "Brown",
        "BrownDark",
        "PastelPink",
        "Platinum",
        "Red",
        "SilverGray",
      ];

      //Generating two calls with same params
      const dna = await deployed.generatePseudoRandomDNA(
        TOKEN_ID,
        owner.address
      );

      //Getting attributes
      const accessory_contract = await deployed.getAccessoriesType(dna);
      const hair_color_contract = await deployed.getHairColor(dna);

      expect(ACCESORIES_TYPE).to.be.includes(accessory_contract);
      expect(HAIR_COLOR).to.be.includes(hair_color_contract);
    });
  });
});
