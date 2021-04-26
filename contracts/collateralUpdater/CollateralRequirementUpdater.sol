pragma solidity ^0.4.24;

import "openzeppelin-solidity/contracts/ownership/Ownable.sol";
import "../Agreement.sol";
import "./PriceOracle.sol";

contract CollateralRequirementUpdater is Ownable {

    uint256 constant public MAX_DISPUTABLE_APPS = 10;

    Agreement public agreement;
    DisputableAragonApp[] public disputableApps;
    ERC20[] public collateralTokens;
    uint256[] public actionAmountsStable;
    uint256[] public challengeAmountsStable;
    PriceOracle public priceOracle;
    address public stableToken;

    event CollateralRequirementsUpdated();
    event ActionAndChallengeAmountsUpdated();

    constructor(
        Agreement _agreement,
        DisputableAragonApp[] _disputableApps,
        ERC20[] _collateralTokens,
        uint256[] _actionAmountsStable,
        uint256[] _challengeAmountsStable,
        PriceOracle _priceOracle,
        address _stableToken
    ) public {
        require(_disputableApps.length == _collateralTokens.length
            && _actionAmountsStable.length == _challengeAmountsStable.length
            && _collateralTokens.length == _actionAmountsStable.length, "ERROR: Inconsistently sized arrays");
        require(_disputableApps.length <= MAX_DISPUTABLE_APPS, "ERROR: Too many disputable apps");

        agreement = _agreement;
        disputableApps = _disputableApps;
        collateralTokens = _collateralTokens;
        actionAmountsStable = _actionAmountsStable;
        challengeAmountsStable = _challengeAmountsStable;
        priceOracle = _priceOracle;
        stableToken = _stableToken;
    }

    // This contract requires the MANAGE_DISPUTABLE_ROLE permission on the specified Agreement contract
    function updateCollateralRequirements() external {
        for (uint256 i = 0; i < disputableApps.length; i++) {
            DisputableAragonApp disputableAragonApp = disputableApps[i];
            (, uint256 currentCollateralRequirementId) = agreement.getDisputableInfo(disputableAragonApp);
            (ERC20 collateralToken, uint64 challengeDuration, uint256 actionAmount, uint256 challengeAmount)
                = agreement.getCollateralRequirement(disputableAragonApp, currentCollateralRequirementId);

            require(collateralToken == collateralTokens[i], "ERROR: Collateral tokens do not match");

            uint256 actionAmountVariable = priceOracle.consult(stableToken, actionAmountsStable[i], collateralToken);
            uint256 challengeAmountVariable = priceOracle.consult(stableToken, challengeAmountsStable[i], collateralToken);

            require(actionAmount != actionAmountVariable || challengeAmount != challengeAmountVariable, "ERROR: No update needed");

            agreement.changeCollateralRequirement(disputableAragonApp, collateralToken, challengeDuration,
                actionAmountVariable, challengeAmountVariable);
        }

        emit CollateralRequirementsUpdated();
    }

    function updateActionAndChallengeAmount(
        uint256[] _actionAmountsStable,
        uint256[] _challengeAmountsStable
    ) external onlyOwner {
        require(_actionAmountsStable.length == _challengeAmountsStable.length
        && _actionAmountsStable.length == actionAmountsStable.length, "ERROR: Inconsistently sized arrays");

        actionAmountsStable = _actionAmountsStable;
        challengeAmountsStable = _challengeAmountsStable;

        emit ActionAndChallengeAmountsUpdated();
    }
}
