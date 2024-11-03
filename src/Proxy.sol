// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

contract Proxy {

    error DELEGATION_FAILED();
    error PERMISSION_DENIED(address);

    address private _owner;
    address public impl;

    constructor(address _impl){
        _owner = msg.sender;
        impl = _impl;
    }

    receive() external payable{}
    
    fallback() external payable{
        (bool success,) = impl.delegatecall(msg.data);
        if(!success){
            revert DELEGATION_FAILED();
        }
    }

    function setImpl(address _impl) external {
        if(msg.sender != _owner){
            revert PERMISSION_DENIED(msg.sender);
        }
        impl = _impl;
    }

}