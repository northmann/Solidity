// SPDX-License-Identifier: MIT
// solhint-disable-next-line
pragma solidity >0.8.2;

import "@openzeppelin/contracts-upgradeable/proxy/utils/Initializable.sol";
import "@openzeppelin/contracts-upgradeable/access/OwnableUpgradeable.sol";
import "@openzeppelin/contracts/utils/introspection/ERC165Storage.sol";


import "./Event.sol";

contract FarmEvent is Event {

    uint256 public populationUsed;
    uint256 public timeRequired;
    uint256 public yieldFactor;
    uint256 public goldForTimeFactor; // Per population x time x goldForTimeFactor
    uint256 public attritionFactor;

    function initialize(uint256 _populationUsed, uint256 _provinceFarmYieldFactor, uint256 _attritionFactor) initializer public {
        super.initialize();

        populationUsed = _populationUsed;
        timeRequired = 100; // Number of blocks
        goldForTimeFactor = 1 ether; // something in wei, the factor price should reflect that its cheaper to farm than to buy on open market.
        yieldFactor = _provinceFarmYieldFactor;
        attritionFactor = _attritionFactor;
    }

    /// The cost of the time to complete the event.
    function payForTimeCost() external view override returns(uint256)
    {
        return populationUsed * timeRequired * goldForTimeFactor;
    }

    /// When a user has paid for time, this method gets called.
    function paidForTime() external view override onlyOwner returns(uint256)
    {
        return goldForTimeFactor;
    }


}