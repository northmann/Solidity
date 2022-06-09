// SPDX-License-Identifier: MIT
// solhint-disable-next-line
pragma solidity >0.8.2;

import "@openzeppelin/contracts-upgradeable/proxy/utils/Initializable.sol";
import "@openzeppelin/contracts/utils/introspection/ERC165Storage.sol";
import "@openzeppelin/contracts-upgradeable/access/AccessControlUpgradeable.sol";
import "@openzeppelin/contracts/utils/structs/EnumerableSet.sol";


import "./Interfaces.sol";
import "./Statics.sol";

// Resources
// https://programtheblockchain.com/posts/2018/04/20/storage-patterns-pagination/
// https://github.com/kieranelby/KingOfTheEtherThrone/blob/v1.0/contracts/KingOfTheEtherThrone.sol
// import '@openzeppelin/contracts/math/SafeMath.sol'; =>  using SafeMath for uint256;
struct Position {
    uint32 x;
    uint32 y;
}

struct Resources {
    uint32 plains;
    uint32 wood;
    uint32 stone;
}


contract Province is Initializable, AccessControlUpgradeable, IProvince {
    bytes32 public constant VASSAL_ROLE = keccak256("VASSAL_ROLE");
    bytes32 public constant OWNER_ROLE = keccak256("OWNER_ROLE");

    string public name;

    address public owner;
    address public vassal;

    Position public position;
    Resources public resources;

    uint256 public population;
    address public armyContract;

    EnumerableSet.AddressSet private work;
    EnumerableSet.AddressSet private building;
    EnumerableSet.AddressSet private incomingTransfers;
    EnumerableSet.AddressSet private insideTransfers;
    EnumerableSet.AddressSet private outgoingTransfers;

    
    /// @custom:oz-upgrades-unsafe-allow constructor
    constructor() payable {
        _disableInitializers();
    }

    function initialize(string memory _name, address _owner) initializer public {
        grantRole(DEFAULT_ADMIN_ROLE, msg.sender);
        grantRole(DEFAULT_ADMIN_ROLE, _owner);
        grantRole(OWNER_ROLE, _owner);
        name = _name;
    }


    function setVassal(address _user) external onlyRole(OWNER_ROLE)
    {
        _setupRole(VASSAL_ROLE, _user);
    }

    function createFarmEvent(address _hero, uint256 populationUsed) external ownerOrVassel {
        require(populationUsed <= population, "not enough population");
        // check that the hero exist and is controlled by user.
        population = population - populationUsed;
        //BeaconProxy proxy = new BeaconProxy(address(farmEventBeacon),abi.encodeWithSelector(FarmEvent(address(0)).initialize.selector, _hero, populationUsed));
        //users[tx.origin] = address(proxy);
        

    }
}