//SPDX-License-Identifier: MIT
pragma solidity ^0.8.18;


contract mManualToken {

    mapping(address => uint256) s_balances;


    function name() public view returns (string memory){
        return "Manual Token";
    }

    function decimals() public pure returns (uint8){
        return 18;
    }   

    function totalSupply() public pure returns (uint256){
        return 100 ether; // 100 * 10^18
    }

    function balanceOf(address owner) public view returns (address owner){
        return s_balances[owner];
    }

    function transfer(address 256 _to, uint256 _amount) public {
        uint256 previousBalances = balanceOf(msg.sender) + balanceOf(_to);
        s_balances[msg.sender] -= _amount;
        s_balances[_to] += _amount;
        require(balanceOf(msg.sender) + balanceOf(_to) == previousBalances);
    }

}
