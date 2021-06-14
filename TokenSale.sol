pragma solidity ^0.4.2;

import "./ERC20Token.sol";

contract ERC20TokenSale {
    address admin;
    ERC20Token public tokenContract;
    uint256 public tokenPrice;
    uint256 public tokensSold;

    event Sell(address _buyer, uint256 _amount);

    //Prices for different stages 
    enum saleStage { Initial, Second ,Final  }
    //Setting default for first sale .
    saleStage public stage = saleStage.Initial;
    
    
    function ERC20TokenSale(ERC20Token _tokenContract, uint256 _tokenPrice) public {
        admin = msg.sender;
        if(tokensSold <= 30000) 
        {
        stage = saleStage.Initial;
        } 
        else 
        if(tokensSold > 30000 && tokensSold <=50000)
        {
         stage = saleStage.Second;
        }
        else if (tokensSold > 50000){
            stage = saleStage.Final;
        }

        if(stage == saleStage.Initial) {
        tokenPrice = 0.01;
     
      
         } 
        else if (stage == saleStage.Second) 
         {
        tokenPrice = 0.02;
        }
        else 
        {
        tokenContract = _tokenContract;
        tokenPrice = _tokenPrice;
        }
    }

    

    function buyTokens(uint256 _numberOfTokens) public payable {
       
        require(tokenContract.balanceOf(this) >= _numberOfTokens);
        require(tokenContract.transfer(msg.sender, _numberOfTokens));

        tokensSold += _numberOfTokens;

        Sell(msg.sender, _numberOfTokens);
    }

    function endSale() public {
        require(msg.sender == admin);
        require(tokenContract.transfer(admin, tokenContract.balanceOf(this)));
        admin.transfer(address(this).balance);
    }
}
