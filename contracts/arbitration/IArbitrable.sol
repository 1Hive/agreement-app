pragma solidity ^0.4.24;

import "@aragon/os/contracts/lib/standards/ERC165.sol";

import "./IArbitrator.sol";


/**
* @title Arbitrable interface
* @dev This interface is implemented by `Agreement` so it can be used to submit disputes to an `IArbitrator`.
*      This interface was manually-copied from https://github.com/aragon/aragon-court/blob/v1.2.0/contracts/arbitration/IArbitrable.sol
*      since we are using different solidity versions.
*/
contract IArbitrable is ERC165 {
    bytes4 internal constant ARBITRABLE_INTERFACE_ID = bytes4(0x88f3ee69);

    /**
    * @dev Emitted when an IArbitrable instance's dispute is ruled by an IArbitrator
    * @param arbitrator IArbitrator instance ruling the dispute
    * @param disputeId Identifier of the dispute being ruled by the arbitrator
    * @param ruling Ruling given by the arbitrator
    */
    event Ruled(IArbitrator indexed arbitrator, uint256 indexed disputeId, uint256 ruling);

    /**
    * @dev Query if a contract implements a certain interface
    * @param _interfaceId The interface identifier being queried, as specified in ERC-165
    * @return True if the contract implements the requested interface and if its not 0xffffffff, false otherwise
    */
    function supportsInterface(bytes4 _interfaceId) public pure returns (bool) {
        return super.supportsInterface(_interfaceId) || _interfaceId == ARBITRABLE_INTERFACE_ID;
    }
}
