pragma solidity ^0.4.24;

import "../../../collateralUpdater/PriceOracle.sol";

contract PriceOracleMock is PriceOracle {

    uint256 public requestTokenPriceInStableToken;

    constructor(uint256 _requestTokenPriceInStableToken) public {
        requestTokenPriceInStableToken = _requestTokenPriceInStableToken;
    }

    function consult(address tokenIn, uint256 amountIn, address tokenOut) external view returns (uint256 amountOut) {
        return amountIn / requestTokenPriceInStableToken;
    }
}
