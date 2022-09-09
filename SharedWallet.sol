// SPDX-License-Identifier: MIT

pragma solidity ^0.8.16;

import "@openzeppelin/contracts/access/Ownable.sol";

contract SharedWallet is Ownable {
    event LimitChanged(address _userAddress, uint _oldLimit, uint _newLimit);

    uint _oldLimit;

    struct Members {
        string name;
        uint limit;
        bool is_admin;
    }

    mapping(address => Members) public members;

    function isOwner() internal view returns(bool) {
        return owner() == _msgSender();
    }

    modifier ownerOrWithinLimits(uint _amount) {
        require(isOwner() || members[_msgSender()].limit >= _amount, "You are not allowed to perform this operation!");
        _;
    }

    function addLimit(address _member, uint _limit) public onlyOwner {
        members[_member].limit = _limit;
        emit LimitChanged(_member, _oldLimit, _limit);
    }

    function deduceFromLimit(address _member, uint _amount) internal {
        members[_member].limit -= _amount;
    }

    function renounceOwnership() override public view onlyOwner {
        revert("Can't renounce!");
    }

    function deleteMember(address _member) public onlyOwner {
        delete members[_member];
    }

    function makeAdmin(address _member) public onlyOwner returns(bool) {
        return members[_member].is_admin = true;
    }

    function revokeAdmin(address _member) public onlyOwner returns(bool) {
        return members[_member].is_admin = false;
    }
}