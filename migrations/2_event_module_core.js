const EventModuleCore = artifacts.require("../contracts/EventModuleCore.sol");
module.exports = function(deployer) {
  deployer.deploy(EventModuleCore);
};
