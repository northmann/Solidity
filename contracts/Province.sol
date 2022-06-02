// SPDX-License-Identifier: MIT
// solhint-disable-next-line
pragma solidity >0.8.2;

//import "@openzeppelin/contracts/proxy/utils/Initializable.sol";
//import "@openzeppelin/contracts/access/Ownable.sol";
//import "@openzeppelin/contracts/access/Ownable.sol";
//import "@openzeppelin/contracts/proxy/utils/Initializable.sol";
import "@openzeppelin/contracts-upgradeable/proxy/utils/Initializable.sol";
import "@openzeppelin/contracts/utils/introspection/ERC165Storage.sol";



//import "@openzeppelin/contracts/utils/math/SafeMath.sol";
//import "@openzeppelin/contracts-upgradeable/access/OwnableUpgradeable.sol";
//import "@openzeppelin/contracts-upgradeable/proxy/utils/Initializable.sol";

//import "@openzeppelin/contracts/access/Ownable.sol";

import "./Interfaces.sol";
import "./Statics.sol";

// Resources
// https://programtheblockchain.com/posts/2018/04/20/storage-patterns-pagination/
// https://github.com/kieranelby/KingOfTheEtherThrone/blob/v1.0/contracts/KingOfTheEtherThrone.sol
// import '@openzeppelin/contracts/math/SafeMath.sol'; =>  using SafeMath for uint256;

contract Province is Initializable, ERC165Storage, IProvince {
    string public name;


    uint256 public population;


    address[] public work;
    address[] public incomingTransfers;
    address[] public outgoingTransfers;

    /// @custom:oz-upgrades-unsafe-allow constructor
    constructor() payable {
        _disableInitializers();
    }

    function initialize(string memory _name) initializer public {
        name = _name;
        _registerInterface(type(IProvince).interfaceId);

    }

}