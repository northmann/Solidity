// SPDX-License-Identifier: MIT
// solhint-disable-next-line
pragma solidity >0.8.2;

import "@openzeppelin/contracts/proxy/beacon/UpgradeableBeacon.sol";
import "@openzeppelin/contracts/proxy/beacon/BeaconProxy.sol";
import "@openzeppelin/contracts-upgradeable/proxy/utils/Initializable.sol";

import "@openzeppelin/contracts-upgradeable/access/AccessControlUpgradeable.sol";
import "@openzeppelin/contracts-upgradeable/proxy/utils/Initializable.sol";
import "@openzeppelin/contracts-upgradeable/proxy/utils/UUPSUpgradeable.sol";

// import "./ArmyNFT.sol";
import "./UserAccount.sol";

contract UserAccountManager is Initializable, AccessControlUpgradeable, UUPSUpgradeable {
    bytes32 public constant MINTER_ROLE = keccak256("MINTER_ROLE");
    bytes32 public constant UPGRADER_ROLE = keccak256("UPGRADER_ROLE");

    UpgradeableBeacon private userAccountBeacon;
    mapping(address => address) private users;


    /// @custom:oz-upgrades-unsafe-allow constructor
    constructor() {
        _disableInitializers();
    }

    function initialize() initializer public virtual {
        __AccessControl_init();
        __UUPSUpgradeable_init();
        _grantRole(DEFAULT_ADMIN_ROLE, msg.sender);
        _grantRole(MINTER_ROLE, msg.sender);
        _grantRole(UPGRADER_ROLE, tx.origin);

        
        userAccountBeacon = new UpgradeableBeacon(address(new UserAccount()));
    }

    
    function createUserAccount() private onlyRole(MINTER_ROLE) returns(address) {
        if(users[tx.origin] != address(0)) return users[tx.origin]; // If exist return
        BeaconProxy proxy = new BeaconProxy(address(userAccountBeacon),abi.encodeWithSelector(UserAccount(address(0)).initialize.selector));
        users[msg.sender] = address(proxy);
        return address(proxy);
    }

    function upgradeUserAccountTemplate(address _template) external onlyRole(UPGRADER_ROLE) {
        userAccountBeacon.upgradeTo(_template);
    }

    function _authorizeUpgrade(address newImplementation)
        internal
        onlyRole(UPGRADER_ROLE)
        override
    {}

}
