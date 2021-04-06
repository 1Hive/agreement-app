const deployer = require('../helpers/utils/deployer')(web3, artifacts)
const { bn, bigExp, ONE_DAY } = require('@aragon/contract-helpers-test')
const { assertBn, assertRevert } = require('@aragon/contract-helpers-test/src/asserts')

const CollateralRequirementUpdater = artifacts.require('CollateralRequirementUpdater')
const PriceOracleMock = artifacts.require('PriceOracleMock')

contract('CollateralRequirementUpdater', ([owner]) => {

  let priceOracle, stableToken, collateralRequirementUpdater
  const actionAmountStable = bigExp(200, 18) // 200 dai
  const challengeAmountStable = bigExp(300, 18) // 300 dai
  const stablePricePerToken = bn(1000)

  beforeEach(async () => {
    await deployer.deployAndInitializeDisputableWrapper({ owner, activate: true })
    priceOracle = await PriceOracleMock.new(stablePricePerToken)
    stableToken = await deployer.deployToken({})
  })

  describe("constructor", () => {
    
    beforeEach(async () => {
      collateralRequirementUpdater = await CollateralRequirementUpdater.new(deployer.agreement.address, [deployer.disputable.address],
        [deployer.collateralToken.address], [actionAmountStable], [challengeAmountStable], priceOracle.address, stableToken.address)
      const manageDisputableRole = await deployer.agreement.MANAGE_DISPUTABLE_ROLE()
      await deployer.acl.grantPermission(collateralRequirementUpdater.address, deployer.agreement.address, manageDisputableRole)
    })

    it('sets variables correctly', async () => {
      assert.equal(await collateralRequirementUpdater.agreement(), deployer.agreement.address, "Incorrect agreement")
      assert.equal(await collateralRequirementUpdater.disputableApps(0), deployer.disputable.address, "Incorrect disputable")
      assert.equal(await collateralRequirementUpdater.collateralTokens(0), deployer.collateralToken.address, "Incorrect collateral token")
      assertBn(await collateralRequirementUpdater.actionAmountsStable(0), actionAmountStable, "Incorrect action amount stable")
      assertBn(await collateralRequirementUpdater.challengeAmountsStable(0), challengeAmountStable, "Incorrect challenge amount stable")
      assert.equal(await collateralRequirementUpdater.priceOracle(), priceOracle.address, "Incorrect price oracle")
      assert.equal(await collateralRequirementUpdater.stableToken(), stableToken.address, "Incorrect stable token")
    })

    it('reverts when array lengths are inconsistent', async () => {
      await assertRevert(CollateralRequirementUpdater.new(deployer.agreement.address, [deployer.disputable.address, deployer.disputable.address],
        [deployer.collateralToken.address], [actionAmountStable], [challengeAmountStable], priceOracle.address, stableToken.address),
        "ERROR: Inconsistently sized arrays")

      await assertRevert(CollateralRequirementUpdater.new(deployer.agreement.address, [deployer.disputable.address],
        [deployer.collateralToken.address, deployer.collateralToken.address], [actionAmountStable], [challengeAmountStable],
        priceOracle.address, stableToken.address), "ERROR: Inconsistently sized arrays")

      await assertRevert(CollateralRequirementUpdater.new(deployer.agreement.address, [deployer.disputable.address],
        [deployer.collateralToken.address], [actionAmountStable, actionAmountStable], [challengeAmountStable],
        priceOracle.address, stableToken.address), "ERROR: Inconsistently sized arrays")

      await assertRevert(CollateralRequirementUpdater.new(deployer.agreement.address, [deployer.disputable.address],
        [deployer.collateralToken.address], [actionAmountStable], [challengeAmountStable, challengeAmountStable],
        priceOracle.address, stableToken.address), "ERROR: Inconsistently sized arrays")
    })

    describe("updateCollateralRequirements()", () => {
      it('updates collateral requirements', async () => {
        await collateralRequirementUpdater.updateCollateralRequirements()
        const { currentCollateralRequirementId: collateralRequirementIdAfter } = await deployer.agreement.getDisputableInfo(deployer.disputable.address)
        const {
          collateralToken: collateralTokenAfter,
          challengeDuration: challengeDurationAfter,
          actionAmount: actionAmountAfter,
          challengeAmount: challengeAmountAfter
        } = await deployer.agreement.getCollateralRequirement(deployer.disputable.address, collateralRequirementIdAfter)

        assert.equal(collateralTokenAfter, deployer.collateralToken.address, "Incorrect collateral token")
        assertBn(challengeDurationAfter, bn(2 * ONE_DAY), "Incorrect challenge duration")
        assertBn(actionAmountAfter, actionAmountStable.div(stablePricePerToken), "Incorrect action amount")
        assertBn(challengeAmountAfter, challengeAmountStable.div(stablePricePerToken), "Incorrect challenge amount")
      })

      it('reverts when incorrect collateral token received', async () => {
        const collateralRequirementUpdater = await CollateralRequirementUpdater.new(deployer.agreement.address, [deployer.disputable.address],
          [deployer.disputable.address], [actionAmountStable], [challengeAmountStable], priceOracle.address, stableToken.address)
        const manageDisputableRole = await deployer.agreement.MANAGE_DISPUTABLE_ROLE()
        await deployer.acl.grantPermission(collateralRequirementUpdater.address, deployer.agreement.address, manageDisputableRole)

        await assertRevert(collateralRequirementUpdater.updateCollateralRequirements(), "ERROR: Collateral tokens do not match")
      })

      it('reverts when already updated', async () => {
        await collateralRequirementUpdater.updateCollateralRequirements()
        await assertRevert(collateralRequirementUpdater.updateCollateralRequirements(), "ERROR: No update needed")
      })
    })
  })


})
