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
  

   result = await greeter.gavg(2,2);
   console.log("sub value: ", result.toString());
   console.log("valor real: ", result/2**64);

   
   console.log("Resto: ",3 % 2)
   console.log("test &: ",3191599813329 & 1);
   console.log("test <<: ", -1 << 60);
   
   console.log("pow -1; 63: ",ethers.BigNumber.from(-1).pow(63).toString());
   result = await greeter.pow(ethers.BigNumber.from("7000000000000"),3);
   console.log("Contract result: ",result.toString());
   console.log(ethers.BigNumber.from(2).pow(64).toString());

   console.log("sqrt", (await greeter.sqrt(1)).toString());

  let max128 = ethers.BigNumber.from("170141183460469231731687303715884105727");
   console.log("log2: ", (await greeter.log_2(max128)).toString());


   console.log("exp2: ", (await greeter.exp_2(await greeter.fromInt(0))).toString()/2**64);
   console.log("mul 1*1: ", (await greeter.mul(await greeter.fromInt(0),await greeter.fromInt(0))).toString());

   console.log("exp: ", (await greeter.exp(1)).toString());

   console.log("test >>: ", 10 >> 3);
   let factorExp = ethers.BigNumber.from("-490923683258796565746369346286093237522");
   console.log(factorExp.div(2*128).toString());
   console.log("test conversion: ", (await greeter.test()).toString());

   console.log("Test toUInt: ", (await greeter.toUInt(1)).toString())

   console.log("test add: ", (await greeter.add(1,1)).toString());

   let one = ethers.BigNumber.from(await greeter.fromInt(1));
   console.log("test redondeo: ", one.toString());

   console.log("test mul: ", ethers.BigNumber.from(await greeter.mul(one.div("10000000000000000000"),one)).toString());
   console.log("test redondeo: ",one.div("10000000000000000000").toString());

   

  });
});
