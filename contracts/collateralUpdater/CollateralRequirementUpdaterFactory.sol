pragma solidity ^0.4.24;

import "./CollateralRequirementUpdater.sol";

// Rinkeby deployment: 0x4c4B2EE79D42d21E76045b0d7B2f9DD0e951F4Ed
// xDai deployment: 0x186F0bF13D2C1D06eBB296aaE0eaB9A5008f776D

contract CollateralRequirementUpdaterFactory {

    event NewCollateralRequirementUpdater(CollateralRequirementUpdater _newCollateralRequirementUpdater);

    function newCollateralRequirementUpdater(
        Agreement _agreement,
        DisputableAragonApp[] _disputableApps,
        ERC20[] _collateralTokens,
        uint256[] _actionAmountsStable,
        uint256[] _challengeAmountsStable,
        PriceOracle _priceOracle,
        address _stableToken
    ) public returns (address) {
        CollateralRequirementUpdater collateralRequirementUpdater = new CollateralRequirementUpdater(
            _agreement,
            _disputableApps,
            _collateralTokens,
            _actionAmountsStable,
            _challengeAmountsStable,
            _priceOracle,
            _stableToken
        );

        collateralRequirementUpdater.transferOwnership(msg.sender);

        emit NewCollateralRequirementUpdater(collateralRequirementUpdater);

        return collateralRequirementUpdater;
    }
}
