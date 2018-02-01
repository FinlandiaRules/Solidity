pragma solidity ^0.4.0;

contract PayCheck {

    address[] employees = [, ];
    
    mapping (address => uint) withdrawnAmounts;
    
    function PayCheck() payable {
    }
    
    function () payable {
    }
    
    modifier canWithdraw() {
        bool contains = false;
        
        for(uint i = 0; i < employees.length; i++) {
            if(employees[i] == msg.sender) {
                contains = true;
            }
        }
        require(contains);
        _;
    }
    
    function withdraw() canWithdraw {
        uint amountAllocated = this.balance/employees.length;
        uint amountWithdrawn = withdrawnAmounts[msg.sender];
        uint amount = amountAllocated - amountWithdrawn;
        withdrawnAmounts[msg.sender] = amountWithdrawn + amount;
        if (amount > 0) {
            msg.sender.transfer(amount);
        }
        
    }
    
}
