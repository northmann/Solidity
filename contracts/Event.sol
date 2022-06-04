// SPDX-License-Identifier: MIT
// solhint-disable-next-line
pragma solidity >0.8.2;

import "@openzeppelin/contracts-upgradeable/proxy/utils/Initializable.sol";
import "@openzeppelin/contracts-upgradeable/access/OwnableUpgradeable.sol";
import "@openzeppelin/contracts/utils/introspection/ERC165Storage.sol";


import "./Interfaces.sol";

abstract contract Event is ERC165Storage, Initializable, OwnableUpgradeable, IEvent, ITimeContract {

    /// @custom:oz-upgrades-unsafe-allow constructor
    constructor() payable {
        _disableInitializers();
    }

    function initialize() initializer public virtual {
        __Ownable_init();
		_registerInterface(type(IEvent).interfaceId);
		_registerInterface(type(ITimeContract).interfaceId);

    }

    /// The cost of the time to complete the transfer.
    function payForTimeCost() external view override virtual returns(uint256)
    {
        return 0;
    }

    /// When a user has paid for time, this method gets called.
    function paidForTime() external view override virtual onlyOwner returns(uint256)
    {
        return 0;
    }


}
