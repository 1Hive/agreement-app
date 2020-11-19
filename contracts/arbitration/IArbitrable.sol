pragma solidity ^0.4.24;

import "./IArbitrator.sol";


/**
* @title Arbitrable interface
* @dev This interface is implemented by `Agreement` so it can be used to submit disputes to an `IArbitrator`.
*      This interface was manually-copied from https://github.com/aragon/aragon-court/blob/v1.2.0/contracts/arbitration/IArbitrable.sol
*      since we are using different solidity versions.
*/
contract IArbitrable {
    /**
    * @dev Emitted when an IArbitrable instance's dispute is ruled by an IArbitrator
    * @param arbitrator IArbitrator instance ruling the dispute
    * @param disputeId Identifier of the dispute being ruled by the arbitrator
    * @param ruling Ruling given by the arbitrator
    */
    event Ruled(IArbitrator indexed arbitrator, uint256 indexed disputeId, uint256 ruling);
}
