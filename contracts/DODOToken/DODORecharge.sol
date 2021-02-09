//SPDX-License-Identifier: MIT
pragma solidity ^0.6.9;


import {SafeMath} from "../lib/SafeMath.sol";
import {SafeERC20} from "../lib/SafeERC20.sol";
import {IERC20} from "../intf/IERC20.sol";
import {InitializableOwnable} from "../lib/InitializableOwnable.sol";


contract DODORecharge is InitializableOwnable {
    using SafeERC20 for IERC20;
    IERC20 immutable _DODO_;
    address immutable _DODO_APPROVE_PROXY_;

    event DeductionDODO(address user,uint256 _amount);
    
    constructor(address dodoAddress,address dodoApproveProxy)public {
        _DODO_ = IERC20(dodoAddress);
        _DODO_APPROVE_PROXY_ = dodoApproveProxy;
    }

    function deductionDODO(uint256 amount) external{
        IDODOApproveProxy(_DODO_APPROVE_PROXY_).claimTokens(_DODO_, msg.sender, address(this), amount);
        emit DeductionDODO(msg.sender, amount);
    }
    // ============ Owner Functions ============
    function claimToken(address token) public onlyOwner {
        IERC20 erc20token = IERC20(token);
        uint256 balance = erc20token.balanceOf(address(this));
        require(balance>0,"no enough token can claim");
        erc20token.safeTransfer(_OWNER_, balance);
    }
}
