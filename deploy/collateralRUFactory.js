module.exports = async ({
  getNamedAccounts,
  deployments,
  getChainId,
  getUnnamedAccounts,
}) => {
  const { deploy } = deployments;
  const { deployer } = await getNamedAccounts();
  console.log("deployer", deployer);
  console.log("deploying CollateralRequirementUpdaterFactory");
  // the following will only deploy "CollateralRequirementUpdaterFactory" if the contract was never deployed or if the code changed since last deployment
  const t = await deploy("CollateralRequirementUpdaterFactory", {
    from: deployer,
    gasLimit: 4000000,
    args: [],
  });

  console.log("T", t?.address);
};
