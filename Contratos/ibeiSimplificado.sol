pragma solidity ^0.5.1;

contract Plataforma{
    
    mapping(address => address[])private produtosLoja;
    mapping(address => Produto)private infoProdutos;
    address[] private ids;
    
    struct Produto{
        address id;
        address dono;
        string nome;
        string descricao;
        uint preco;
        bool estaVendido;
    }
    
    function getProduto(address id)public view returns(
        address dono, 
        string memory nome, 
        string memory descricao, 
        uint preco, 
        bool estaVendido
        ){
            Produto memory p = infoProdutos[id];
            dono = p.dono;
            nome = p.nome;
            descricao = p.descricao;
            preco = p.preco;
            estaVendido = p.estaVendido;
            
        }
        
    function getProdutos()public view returns(address[] memory codigos){
        codigos = ids; 
    }
    
    function getProdutosLoja(address dono)public view returns(address[] memory codigos){
        codigos = produtosLoja[dono];
    }
    
    function getProdutosLoja()public view returns(address[] memory codigos){
        codigos = produtosLoja[msg.sender];
    }
    
    function cadastraProduto(address id, string memory nome, string memory descricao, uint preco)public {
        require(preco > 0);
        
        Produto memory p = Produto(id, msg.sender, nome, descricao, preco, false);
        
        produtosLoja[msg.sender].push(id);
        infoProdutos[id] = p;
        ids.push(id);
    }
    
    function compraProduto(address id, address dono)public{
        require(msg.sender != dono);
        
        infoProdutos[id].estaVendido = true;
        for(uint i=0; i<ids.length; i++){
            if(ids[i] == id){
                delete ids[i];
            }
        }
        
        for(uint j=0; j<produtosLoja[dono].length; j++){
            if(produtosLoja[dono][j] == id){
                delete produtosLoja[dono][j];
            }
        }
    }
    
}
