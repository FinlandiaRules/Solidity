pragma solidity ^0.4.13;

contract Concilia {

  struct FX {
        address Counterparty;
        uint Nominal;
        string MonedaSender;
        string MonedaCpty;
        bool Confirmed;
        bool Created;
    }
    
    mapping(FX=>FX) public Boletas;
    
    function Concilia() public {
    }
    
    function SendBoleta(address _Counterparty, uint _Nominal, string _MonedaSender, string _MonedaCpty) public {
        //Look if already exists counterparty deal not confirmed yet
        
        FX Sender = FX({
            Sender: msg.sender,
            Counterparty: _Counterparty,
            Nominal: _Nominal,
            MonedaSender: _MonedaSender,
            MonedaCpty: _MonedaCpty,
            Confirmed: false,
            Created: true;
        });
        
        FX Counterparty = FX({
            Sender: _Counterparty,
            Counterparty: msg.sender,
            Nominal: _Nominal,
            MonedaSender: _MonedaCpty,
            MonedaCpty: _MonedaSender,
            Confirmed: false,
            Created: true;
        });
        
        if(Boletas[Counterparty].Created && !Boletas[Counterparty].Confirmed) {
            Boletas[Counterparty].Confirmed=true;
        }
        else {
          Boletas[Sender]=Counterparty;
        }
    }
    
    funtion Status(address _Counterparty, uint _Nominal, string _MonedaSender, string _MonedaCpty) public returns (string out) {
    	FX Sender = FX({
            Sender: msg.sender,
            Counterparty: _Counterparty,
            Nominal: _Nominal,
            MonedaSender: _MonedaSender,
            MonedaCpty: _MonedaCpty,
            Confirmed: false,
            Created: true;
        });
        
        FX Counterparty = FX({
            Sender: _Counterparty,
            Counterparty: msg.sender,
            Nominal: _Nominal,
            MonedaSender: _MonedaCpty,
            MonedaCpty: _MonedaSender,
            Confirmed: false,
            Created: true;
        });
        
	if(Boletas[Sender].Created && Boletas[Sender].Confirmed)) {
	    out="Confirmed";
	}
	else if(Boletas[Counterparty].Created && Boletas[Counterparty].Confirmed)) {
	    out="Confirmed";
	}
        else if(Boletas[Sender].Created && !Boletas[Sender].Confirmed)) {
            out="Pending";
        }
	else {
	    out="No Exists";
	}
    }
}
