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
    
    mapping(address=>FX[]) public Boletas;
    
    function Concilia() public {
    }
    
    function SendBoleta(address _Counterparty, uint _Nominal, string _MonedaSender, string _MonedaCpty) public {
        //Look if already exists counterparty deal not confirmed yet
        
        FX memory SenderKO = FX({
            Counterparty: _Counterparty,
            Nominal: _Nominal,
            MonedaSender: _MonedaSender,
            MonedaCpty: _MonedaCpty,
            Confirmed: false,
            Created: true
        });
        
        FX memory SenderOK = FX({
            Counterparty: _Counterparty,
            Nominal: _Nominal,
            MonedaSender: _MonedaSender,
            MonedaCpty: _MonedaCpty,
            Confirmed: false,
            Created: true
        });
        
        bool found=false;
        
        //Busca si en la conrtaparte tengo el par para confirmar
        for(uint i=0; i<Boletas[_Counterparty].length; i++) {
            if(!Boletas[_Counterparty][i].Confirmed &&
                Boletas[_Counterparty][i].Counterparty==msg.sender &&
                Boletas[_Counterparty][i].Nominal == _Nominal &&
                keccak256(Boletas[_Counterparty][i].MonedaSender) == keccak256(_MonedaCpty) &&
                keccak256(Boletas[_Counterparty][i].MonedaCpty) == keccak256(_MonedaSender)) {
                Boletas[_Counterparty][i].Confirmed=true;
                
                //Encontrado!!
                Boletas[msg.sender].push(SenderOK);
                found=true;
                break;
            }
        }
        
        //Si no existe, creo mi par sin confirmar
        if (!found) {
          Boletas[msg.sender].push(SenderKO);
        }
    }
    
    function Status(address _Counterparty, uint _Nominal, string _MonedaSender, string _MonedaCpty) public view returns (string out) {
    	
    	uint confirmed=0;
    	uint pending=0;
    	
        for(uint i=0; i<Boletas[msg.sender].length; i++) {
            if( Boletas[msg.sender][i].Counterparty==_Counterparty &&
                Boletas[msg.sender][i].Nominal == _Nominal &&
                keccak256(Boletas[msg.sender][i].MonedaSender) == keccak256(_MonedaSender) &&
                keccak256(Boletas[msg.sender][i].MonedaCpty) == keccak256(_MonedaCpty)) {
                
                if(Boletas[msg.sender][i].Confirmed) {
                    confirmed++;
                }
                else {
                    pending++;
                }
            }
        }        
    	out="Confirmed";
    }
}
