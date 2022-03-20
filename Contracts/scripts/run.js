const main = async () => {
  const contractFactoryVerifier = await hre.ethers.getContractFactory("Verifier");
  const contractVerifier = await contractFactoryVerifier.deploy();
  await contractVerifier.deployed();
  console.log("Contract deployed to:", contractVerifier.address);

  const contractFactory = await hre.ethers.getContractFactory("TriangleMove");
  const contract = await contractFactory.deploy(contractVerifier.address);
  await contract.deployed();
  console.log("Contract deployed to:", contract.address);

  // Call the function.
  let result = await contract.verifyMove(
    [
      "0x2ac1059cac6d77fdb17dc2c8e9ca57837d08082c15f3b45a0eaf52c3bf48e8b8",
      "0x2064b45f12fe2f1f8b3df0a60ba3189fc769083f5ef8ca10a3385de53adca792",
    ],
    [
      [
        "0x22c49969d181d13dda9b8c1fd7753fd755bc1512e730306dab68e5e64e48215f",
        "0x20482674f07d62d57e440d55ba9e39ac53452e487d2f444bef31e4e33335981f",
      ],
      [
        "0x1df87b0825c5efe9953f0596cb7a4d27fd39ef6efb8bd5767d4ed4c68a033860",
        "0x2692965ca7d4af99d569138ba471aba0490a8e8e558488db80768f102225b61c",
      ],
    ],
    [
      "0x16dce68bae3bd1951c2ee3f2c7cc63c26998267ba4d99e684c429c355b69145f",
      "0x305fab5aedb49cb6bb7f17a5cbf49afcae3d8e6419e9c1280121d742f584d285",
    ],
    [
      "0x0000000000000000000000000000000000000000000000000000000000000001",
      "0x0000000000000000000000000000000000000000000000000000000000000014",
    ]
  );
  console.log("Result", result);
};

const runMain = async () => {
  try {
    await main();
    process.exit(0);
  } catch (error) {
    console.log(error);
    process.exit(1);
  }
};

runMain();
