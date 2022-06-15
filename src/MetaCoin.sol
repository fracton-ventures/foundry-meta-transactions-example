// SPDX-License-Identifier: MIT
pragma solidity >0.8.0;

import {MinimalForwarder} from "openzeppelin-contracts/metatx/MinimalForwarder.sol";
import {ERC2771Context} from "openzeppelin-contracts/metatx/ERC2771Context.sol";

// This is just a simple example of a coin-like contract.
// It is not standards compatible and cannot be expected to talk to other
// coin/token contracts. If you want to create a standards-compliant
// token, see: https://github.com/ConsenSys/Tokens. Cheers!

contract MetaCoin is ERC2771Context {
    string public symbol = "META";
    string public description = "GSN Sample MetaCoin";
    uint256 public decimals = 0;

    mapping(address => uint256) balances;

    event Transfer(address indexed _from, address indexed _to, uint256 _value);

    constructor(address forwarder) ERC2771Context(forwarder) {
        balances[tx.origin] = 10000;
    }

    function transfer(address receiver, uint256 amount)
        public
        returns (bool sufficient)
    {
        if (balances[_msgSender()] < amount) return false;
        balances[_msgSender()] -= amount;
        balances[receiver] += amount;
        emit Transfer(_msgSender(), receiver, amount);
        return true;
    }

    function balanceOf(address addr) public view returns (uint256) {
        return balances[addr];
    }

    mapping(address => bool) minted;

    /**
     * mint some coins for this caller.
     * (in a real-life application, minting is protected for admin, or by other mechanism.
     * but for our sample, any user can mint some coins - but just once..
     */
    function mint() public {
        require(!minted[_msgSender()], "already minted");
        minted[_msgSender()] = true;
        balances[_msgSender()] += 10000;
    }
}
