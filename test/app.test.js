const EventModuleCore = artifacts.require("../contracts/EventModuleCore.sol");

contract("EventModuleCore", accounts => {
  it("Create an EventModuleCore", () =>
  EventModuleCore.deployed()
      .then(instance => {
        instance.name.call().then((res) => {
          console.log('name is' + res);
        })

        instance.owner.call().then((res) => {
          console.log('owner is' + res);
        })
      }));
});
