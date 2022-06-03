// SPDX-License-Identifier: MIT
// solhint-disable-next-line
pragma solidity >0.8.2;

import "./KingsGold.sol";
import "./World.sol";
import "./Continent.sol";
import "./Treasury.sol";
import "./ProvinceManager.sol";
import "./Province.sol";
import "./ProvincesNFT.sol";


contract BootstrapTest {

    Treasury public treasury;
    KingsGold public gold;
    World public world;

    constructor() {
        // address province = address(new ProvincesNFT());

        // address provinceImplementation = address(new ProvinceManager());
        // emit test_value("Start");
        gold = new KingsGold();
        gold.mint(address(this), 10 ether);
        
        treasury = new Treasury(address(gold));

        
        world = new World(address(treasury));
        world.createWorld();

        gold.mint(address(world), 1 ether);

        Continent continent = Continent(world.continents(uint256(0)));

        gold.approve(address(continent), 10 ether);

        // Bootstrap is calling createProvince
        uint256 tokenId = continent.createProvince("First Province");

    }

}