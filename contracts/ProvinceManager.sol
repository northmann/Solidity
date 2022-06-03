// SPDX-License-Identifier: MIT
// solhint-disable-next-line
pragma solidity >0.8.2;

//import "@openzeppelin/contracts/proxy/utils/Initializable.sol";
//import "@openzeppelin/contracts/access/Ownable.sol";
//import "@openzeppelin/contracts/access/Ownable.sol";
//import "@openzeppelin/contracts/proxy/utils/Initializable.sol";
//import "@openzeppelin/contracts-upgradeable/proxy/utils/Initializable.sol";
//import "@openzeppelin/contracts/utils/introspection/ERC165Storage.sol";

import "@openzeppelin/contracts/proxy/beacon/UpgradeableBeacon.sol";
import "@openzeppelin/contracts/proxy/beacon/BeaconProxy.sol";
import "@openzeppelin/contracts-upgradeable/proxy/utils/Initializable.sol";



//import "@openzeppelin/contracts/utils/math/SafeMath.sol";
//import "@openzeppelin/contracts-upgradeable/access/OwnableUpgradeable.sol";
//import "@openzeppelin/contracts/utils/structs/EnumerableSet.sol";

//import "@openzeppelin/contracts/access/Ownable.sol";

//import "./Interfaces.sol";
//import "./Statics.sol";
import "./ProvincesNFT.sol";
import "./Province.sol";

// Resources
// https://programtheblockchain.com/posts/2018/04/20/storage-patterns-pagination/
// https://github.com/kieranelby/KingOfTheEtherThrone/blob/v1.0/contracts/KingOfTheEtherThrone.sol
// import '@openzeppelin/contracts/math/SafeMath.sol'; =>  using SafeMath for uint256;

contract ProvinceManager is ProvincesNFT {

    UpgradeableBeacon public beacon;
    mapping(uint256 => address) public provinces;

    // /// @custom:oz-upgrades-unsafe-allow constructor
    // constructor() {
    //     _disableInitializers();
    // }

    function initialize() initializer public override {
        super.initialize();

        beacon = new UpgradeableBeacon(address(new Province())); // Make a Province blueprint and set it to the Beacon
    }

    function mintProvince(string memory _name, address _owner) public onlyRole(MINTER_ROLE) returns(uint256) {
        uint256 tokenId = safeMint(_owner);
        
        BeaconProxy proxy = new BeaconProxy(address(beacon),abi.encodeWithSelector(Province(address(0)).initialize.selector, _name, _owner));
        provinces[tokenId] = address(proxy);
        return tokenId;
    }

    function upgradeProvince(address _template) external onlyRole(UPGRADER_ROLE) {
        beacon.upgradeTo(_template);
    }
}
