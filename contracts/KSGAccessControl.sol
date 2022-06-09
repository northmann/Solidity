// SPDX-License-Identifier: MIT
// solhint-disable-next-line
pragma solidity >0.8.2;

import "@openzeppelin/contracts-upgradeable/proxy/utils/Initializable.sol";
import "@openzeppelin/contracts-upgradeable/access/AccessControlUpgradeable.sol";


contract KSGAccessControl is Initializable, AccessControlUpgradeable {
    bytes32 public constant VASSAL_ROLE = keccak256("VASSAL_ROLE");
    bytes32 public constant OWNER_ROLE = keccak256("OWNER_ROLE");


    modifier ownerOrVassel() {
        require(hasRole(OWNER_ROLE, msg.sender) || hasRole(VASSAL_ROLE, msg.sender),"Access denied");
        _;
    }

    modifier onlyRoles(bytes32 role1, bytes32 role2) {
        require(hasRole(role1, msg.sender) || hasRole(role2, msg.sender),"Access denied");
        _;
    }

}