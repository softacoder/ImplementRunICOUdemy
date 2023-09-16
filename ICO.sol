// SPDX-License_Identifier: GPL-3.0

pragma solidity >=0.5.0 <0.9.0;
// ----------------------------------
// EIP-20: ERC-20 Token Standard
// https://eips.ethereum.org/EIPS/eip-20
// ----------------------------------

interface ERC20Interface {
    function totalSupply() external view returns(uint);
    function balanceOf(address tokenOwner) external view returns(uint balance);
    function transfer(address to, uint tokens) external returns(bool success);

    function allowance(address tokenOwner, address spender) external view returns (uint remaining);
    function approve(address spender, uint tokens) external returns (bool success);
    function transferFrom(address from, address to, uint tokens) external returns(bool success);

    event Transfer(address indexed from, address indexed to, uint tokens);
    event Approval(address indexed tokenOwner, address indexed spender, uint tokens);
}

contract CryptosICO is Cryptos{
    address public admin;
    address payable public deposit;
    uint tokenprice = 0.001 ether; // 1ETH = 1000 CRPT, 1 CRPT = 0.001ETH
    uint public hardCap = 300 ether;
    uint public raisedAmount;
    uint public saleStart = block.timestamp;
    uint public saleEnd = block.timestamp + 604800; // ico ends in a week
    uint public tokenTradeStart = saleEnd + 604800; // transfer a week after the sale end
    uint public maxInvestment = 5 ether;
    uint public minInvestment = 0.1 ether;

    enum State {beforeStart, running, afterEnd, halted}
    State public icoState;

    constructor (address payable _deposit){
        deposit = deposit;
        admin = msg.sender;
        icoState = State.beforeStart;
    } 
    modifier onlyAdmin(){
        require(msg.sender == admin);
        _;
    }
    function halt() public onlyAdmin{
        icoState = state.halted;
    }
    function resume() public onlyAdmin{
        icoState = state.running;
    }
    function changeDepositAddress(address payable newDeposit) public onlyAdmin{
        deposit = newDeposit;
    } 
    function getCurrentState() public view returns(State){
        if(icoState == State.halted){
            return State.halted;
        }else if(block.timestamp < saleStart){
            return State.beforeStart;
        }else if(block.timestamp >= saleStart && block.timestamp <= saleEnd){
     return State.running;
}else{
    return State.afterEnd;
}
}

function invest() payable public returns(bool){
    icoState = getCurrentState();
    require(icoState == State.running);

    require(msg.value >= minInvestment && msg.value <= maxInvestment);
    require(raisedAmount <= hardCap);

    uint tokens = msg.sender / tokenPrice;

    balances[msg.sender] += tokens;
    balances[founder] -= tokens;
    deposit.transfer(msg.value);
    emit Invest(msg.sender, msg.value, tokens);

    return true;
}
receive() payable external{
    invest();
}
}