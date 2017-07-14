pragma solidity ^0.4.11;
contract AbstractMint { 
    function balanceOf(address user) returns (uint256);
    function transfer(address to, uint256 value);
    function transferFrom(address from, address to, uint256 value) returns (bool success);
} 

contract Escrow {

    address public escrowOwner;

    address public seller;
    AbstractMint public seller_mint;
    uint256 public seller_value;

    address public buyer;
    AbstractMint public buyer_mint;
    uint256 public buyer_value;

    enum State { None, Confirm, Locked }
    State public seller_state;
    State public buyer_state;

    event Deal(address indexed seller, uint256 seller_value, address indexed buyer, uint256 buyer_value);

    modifier buyerOnly() { require(msg.sender == buyer);_; }
    modifier sellerOnly() { require(msg.sender == seller);_; }

    function Escrow(address _seller, address _seller_mint, uint256 _seller_value, address _buyer, address _buyer_mint, uint256 _buyer_value){
        escrowOwner = msg.sender;

        seller = _seller;
        seller_mint = AbstractMint(_seller_mint);
        seller_value = _seller_value;

        buyer = _buyer;
        buyer_mint = AbstractMint(_buyer_mint);
        buyer_value = _buyer_value;

        buyer_state = State.None;
        seller_state = State.None;
    }

    function buyer_deposit() buyerOnly returns (bool success){
        if (buyer_state != State.None) throw;
        buyer_state = State.Locked; 
        if (buyer_mint.transferFrom(buyer, this, buyer_value) == false) {
            buyer_state = State.None;
            throw;
        } else {
            buyer_state = State.Confirm;
            return true;
        }
    }
    function buyer_cancel() buyerOnly {
        if (buyer_state !=  State.Confirm) throw;
        buyer_state = State.Locked;
        buyer_mint.transfer(buyer, buyer_value);
        buyer_state = State.None;
    }
    function seller_deposit() sellerOnly returns (bool success){
        if (seller_state != State.None) throw;
        seller_state = State.Locked; 
        if (seller_mint.transferFrom(seller, this, seller_value) == false) {
            seller_state = State.None;
            throw;
        } else {
            seller_state = State.Confirm;
            return true;
        }
    }
    function seller_cancel() sellerOnly {
        if (seller_state !=  State.Confirm) throw;
        seller_state = State.Locked;
        seller_mint.transfer(seller, seller_value);
        seller_state = State.None;
    }
    function deal(){
        if (msg.sender != escrowOwner) throw;
        seller_state = State.Locked;
        buyer_state = State.Locked;
        seller_mint.transfer(buyer, seller_value);
        buyer_mint.transfer(seller, buyer_value);
        Deal(seller, seller_value, buyer, buyer_value);
    }

}
