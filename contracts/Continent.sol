// SPDX-License-Identifier: MIT
// solhint-disable-next-line
pragma solidity >0.8.2;

import "@openzeppelin/contracts/proxy/beacon/UpgradeableBeacon.sol";
import "@openzeppelin/contracts/proxy/beacon/BeaconProxy.sol";
//import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts-upgradeable/access/OwnableUpgradeable.sol";

//import "@openzeppelin/contracts/proxy/utils/Initializable.sol";
import "@openzeppelin/contracts-upgradeable/proxy/utils/Initializable.sol";
import "@openzeppelin/contracts/utils/introspection/ERC165Checker.sol";

//import "@openzeppelin/contracts/token/ERC20/IERC20.sol";


import "./ProvinceNFT.sol";
import "./Province.sol";
import "./Treasury.sol";
import "./KingsGold.sol";
import "./Interfaces.sol";


contract Continent is Initializable, OwnableUpgradeable {
    uint256 constant provinceCost = 1 ether;

    ProvinceNFT public NFTManager;

    mapping(uint256 => address) public provinces;
    mapping(address => uint8) public knownContracts;

    UpgradeableBeacon public beacon;

    Treasury public treasury;
    

    /// @custom:oz-upgrades-unsafe-allow constructor
    constructor() {
        _disableInitializers();
    }

    function initialize(string memory _name, address _treasury) public initializer {
        __Ownable_init(); // Initialize contract with World owner
        transferOwnership(tx.origin); // Now set ownership to the caller and not the world contract.

        treasury = Treasury(_treasury);
        
        NFTManager = new ProvinceNFT(_name, "KSGP"); // Create a new Province NFT contract.
        
        beacon = new UpgradeableBeacon(address(new Province())); // Make a Province blueprint and set it to the Beacon
    }

    // Everyone should be able to mint new Provinces from a payment in KingsGold
    function createProvince(string memory _name) external returns(uint256) {
        KingsGold gold = KingsGold(treasury.gold());
        require(provinceCost <= gold.balanceOf(msg.sender), "Not enough tokens in the reserve");

        gold.transferFrom(msg.sender, address(treasury), provinceCost);

        uint256 tokenId = NFTManager.safeMint(tx.origin);

        BeaconProxy proxy = new BeaconProxy(address(beacon),abi.encodeWithSelector(Province(address(0)).initialize.selector, _name));

        provinces[tokenId] = address(proxy);
        addKnownContract(address(proxy));

        return tokenId;
    }

    function createHeroTransfer() external returns(address) {
        return address(0);
    }

    function addKnownContract(address _contract) internal {
        knownContracts[_contract] = 1;
    }

    function payForTime(address _contract) external {
        //check if contract is registred! 
        require(knownContracts[_contract] != uint8(0), "Not known contract");
        require(ERC165Checker.supportsInterface(_contract, type(ITimeContract).interfaceId), "Not a time contract");

        ITimeContract timeContract = ITimeContract(_contract);
        uint256 timeCost = timeContract.timeCost();
        KingsGold gold = KingsGold(treasury.gold());
        require(timeCost <= gold.balanceOf(msg.sender), "Not enough gold");

        if(!gold.transferFrom(msg.sender, address(treasury), timeCost))
            revert();

        timeContract.paidForTime();
    }

    // function deposit(uint amount_) external {
    //     gold.transferFrom(msg.sender, address(gold), amount_);
    // }

    function upgradeProvince(address _blueprint) external onlyOwner {
        beacon.upgradeTo(_blueprint);
    }
}