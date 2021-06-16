// SPDX-License : MIT Licencse 

pragma solidity >= 0.6.0;

contract Ownable 
{
    address private origOwner ;

    event TransferOwnership(address indexed oldOwner, address indexed newOwner);

    constructor()
    {
        origOwner = msg.sender;
        emit TransferOwnership(address(0), origOwner);
    }

    function owner() public view returns (address)
    {
        return origOwner;
    }

    function isOwner() public view returns(bool)
    {
        return msg.sender == origOwner; 
    }

    modifier onlyOwner()
    {
       require(isOwner()); 
        _;
    }

    function renounceOwnership() external onlyOwner
    {
        emit TransferOwnership(origOwner , address(0));
        origOwner = address(0);
    }

    function transferOwnership(address newOwner) external onlyOwner
    {
        _transferOwnership(newOwner);
    }

    function _transferOwnership(address newOwner) internal 
    {
        require(newOwner != address(0));
        emit TransferOwnership(origOwner, newOwner);
        origOwner = newOwner;
    }

}