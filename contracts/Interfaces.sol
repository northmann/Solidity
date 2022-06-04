// SPDX-License-Identifier: MIT
// solhint-disable-next-line
pragma solidity >0.8.2;

interface ITimeContract {   

    function payForTimeCost() external returns(uint256);
    function paidForTime() external returns(uint256);
}

interface IContractType {
    function getType() external pure returns(uint256);
}

interface IProvince { }
interface IEvent { }
