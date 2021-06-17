This Is An ICO Contract Built using Solidity 

Contracts and their workings :

Access : Ownable.sol 

Ensures that the contract can only be accessed by the owners my making access control.

Price Link : PriceOracle.sol

Dynamic Price Detection Using oracle chains provided by Chainlink uses KOVAN test network address.

Token : ERC20.sol

ERC20 Token that is built using the OpenZepplin Solidity Library. Ensures Balances are spread out according to the client's requirements.

WhiteList : WhiteList.sol

WhiteList Role Contract that has the functionality to add and delete WhiteListed Address to ensure proper participation in the ICO

CrowdSale : Crowdsale.sol

Crowdsale contract with all the necessary functions and modifiers. It fetches dynamic data from PriceOracle. Dispense Ether to the Client Specefied Adderss.
Ensure minimum Investment is above 500. Calulates Bonus Structure Along the Way. Releases the Tokens as soon as Ether is Received.