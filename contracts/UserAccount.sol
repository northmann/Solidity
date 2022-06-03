// SPDX-License-Identifier: MIT
// solhint-disable-next-line
pragma solidity >0.8.2;

import "@openzeppelin/contracts/utils/structs/EnumerableSet.sol";

import "@openzeppelin/contracts-upgradeable/proxy/utils/Initializable.sol";
// import "@openzeppelin/contracts/utils/introspection/ERC165Storage.sol";



import "@openzeppelin/contracts/utils/structs/EnumerableSet.sol";

// import "./ArmyData.sol";
// import "./Interfaces.sol";
// import "./Statics.sol";

contract UserAccount is Initializable {

    EnumerableSet.AddressSet private provinces;


        /// @custom:oz-upgrades-unsafe-allow constructor
    constructor() payable {
        _disableInitializers();
    }

    function initialize() initializer public {
    }
}
