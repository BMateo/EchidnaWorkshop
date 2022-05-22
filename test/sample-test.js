const { expect } = require("chai");
const { ethers } = require("hardhat");

describe("Greeter", function () {
  let greeter;
  before(async () => {
    [account1, account2, account3, account4, account5] = await ethers.getSigners();
    const Greeter = await ethers.getContractFactory("Greeter");
     greeter = await Greeter.deploy();
    await greeter.deployed();
  });

  it("Should return the new greeting once it's changed", async function () {
   result = await greeter.mul(await greeter.fromInt(1),await greeter.fromInt(2));
   console.log((await greeter.toInt(result)).toString());
  
   result = await greeter.add(await greeter.fromInt(1),await greeter.fromInt(2));
   console.log("Resultado de la suma: ",(await greeter.toInt(result)).toString());
   
   result = await greeter.div(await greeter.fromInt(1),await greeter.fromInt(-2));
   console.log((result/2**64).toString());
   result = await greeter.shift(1,64);
   console.log("shifted value: ", result.toString());
  });
});
