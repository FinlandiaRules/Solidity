pragma solidity ^0.4.13;

contract Conciliation {

  struct FX {
        address Counterparty;
        uint Nominal;
        string MonedaSender;
        string MonedaCpty;
        bool Confirmed;
        bool Exists;
    }
    
    mapping(address=>FX[]) private Boletas;
    
    mapping(address=>uint) public Pendings;
    mapping(address=>uint) public Confirmed;
    
    
    function Conciliation() public {
    }
    
    function SendBoleta(address _Counterparty, uint _Nominal, string _MonedaSender, string _MonedaCpty) public {
        //Look if already exists counterparty deal not confirmed yet
        
        FX memory SenderKO = FX({
            Counterparty: _Counterparty,
            Nominal: _Nominal,
            MonedaSender: _MonedaSender,
            MonedaCpty: _MonedaCpty,
            Confirmed: false,
            Exists: true
        });
        
        FX memory SenderOK = FX({
            Counterparty: _Counterparty,
            Nominal: _Nominal,
            MonedaSender: _MonedaSender,
            MonedaCpty: _MonedaCpty,
            Confirmed: true,
            Exists: true
        });
        
        bool found=false;
        
        //Busca si en la conrtaparte tengo el par para confirmar
        for(uint i=0; i<Boletas[_Counterparty].length; i++) {
            if(!Boletas[_Counterparty][i].Confirmed &&
                Boletas[_Counterparty][i].Counterparty==msg.sender &&
                Boletas[_Counterparty][i].Nominal == _Nominal &&
                keccak256(Boletas[_Counterparty][i].MonedaSender) == keccak256(_MonedaCpty) &&
                keccak256(Boletas[_Counterparty][i].MonedaCpty) == keccak256(_MonedaSender)) {
                
                  //Encontrado!! lo confirmo
                  Boletas[_Counterparty][i].Confirmed=true;
                  //Y meto mi boleta tambien confirmada
                  Boletas[msg.sender].push(SenderOK);
                  found=true;
                  CalculateStatus(_Counterparty);
                  break;
            }
        }
        
        //Si no existe, creo mi par sin confirmar
        if (!found) {
          Boletas[msg.sender].push(SenderKO);
        }
        CalculateStatus(msg.sender);
        
    }
    
    function CalculateStatus(address Changed) private {
        Pendings[Changed]=0;
        Confirmed[Changed]=0;
        for(uint i=0; i<Boletas[Changed].length; i++) {
            if(Boletas[msg.sender][i].Confirmed) {
                Confirmed[Changed]++;
            }
            else {
                Pendings[Changed]++;
            }
        }
    }

}
