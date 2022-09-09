// SPDX-License-Identifier: MIT

pragma solidity ^0.8.16;

import "./SharedWallet.sol";

contract Wallet is SharedWallet {
    event MoneyWithdrawn(address indexed _to, uint _amount);
    event MoneyReceived(address indexed _from, uint _amount);

    function withdrawMoney(uint _amount) public ownerOrWithinLimits(_amount) {
        require(_amount <= address(this).balance, "Not enough funds to withdraw!");

        if(members[_msgSender()].is_admin == false) {
            deduceFromLimit(_msgSender(), _amount);
        }

        address payable _to = payable(_msgSender());
        _to.transfer(_amount);

        emit MoneyWithdrawn(_to, _amount);
    }

    function sendToContract() public payable {
        address payable _to = payable(this);
        _to.transfer(msg.value);

        emit MoneyReceived(_msgSender(), msg.value);
    }

    function getBalance() public view returns(uint) {
        return address(this).balance;
    }

    fallback() external payable {}

    receive() external payable {
        emit MoneyReceived(_msgSender(), msg.value);
    }
}