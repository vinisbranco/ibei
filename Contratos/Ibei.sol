pragma solidity ^0.5.1;

contract Plataforma{
    address private owner;
    Produto[] private todosProdutos;
    mapping(address => Produto[])private produtoLoja;
    
    constructor()public{
        owner = msg.sender;
    }
    
    function _adicionaProduto(Produto p, address proprietario)internal {
        todosProdutos.push(p);
        Produto[] storage aux = produtoLoja[proprietario];  
        aux.push(p);
        produtoLoja[proprietario] = aux;
    }
    
    function adicionaProduto(Produto p)public {
        _adicionaProduto(p, tx.origin);
    }
    
    
    
}

contract Cliente{
    
    string private nomeCliente;
    string private cpf;
    Produto[]private produtosComprados;
    
    function 
    
    
}

contract Loja{
    
    string private nomeLoja;
    string private descricaoLoja;
    address private proprietario;
    Produto[] private produtosCadastrados;
    produtoAVenda[]private produtos;
    mapping ( address => produtoAVenda)private infoProduto;
    
    struct produtoAVenda{
        address codigo;
        Produto produto;
        uint quantidadeDisponivel;
        bool estaAtivo;
    }
    
    constructor(string memory nome, string memory descricao)public{
        proprietario = tx.origin;
        nomeLoja = nome;
        descricaoLoja = descricao;
    }
    
    function cadastraProduto(address cod, string memory nome, uint valor, string memory urlIPFS, string memory descricaoProduto, uint quantidade)public {
        require(msg.sender == proprietario);
        require(quantidade > 0);
        Produto p = new Produto(proprietario, nome, valor, urlIPFS, descricaoProduto);
        produtoAVenda memory ps = produtoAVenda(cod, p, quantidade, true);
        produtosCadastrados.push(p);
        produtos.push(ps);
        infoProduto[address(p)] = ps;
    }
    
    function getProdutos()public view returns(Produto[] memory prods){
        prods = produtosCadastrados;
    }
    
    function getProduto(Produto prod)public view returns(address cod, bool ativo){
        cod = infoProduto[address(prod)].codigo;
        ativo = infoProduto[address(prod)].estaAtivo;
    }
    
    function getInfoLoja()public view returns(string memory nome, string memory descricao, address dono, Produto[] memory prods){
        nome = nomeLoja;
        descricao = descricaoLoja;
        dono = proprietario;
        prods = produtosCadastrados;
    }
    
    function desativaProduto(Produto prod)public {
        require(msg.sender == proprietario);
        infoProduto[address(prod)].estaAtivo = false;
    }
    
}

contract Produto{
    
    address dono;
    string nomeProduto;
    uint valorProduto;
    string urlIPFS;
    string descricaoProduto;
    
    constructor(address owner, string memory nome, uint valor, string memory endereco, string memory descricao) public{
        require(valor > 0);
        dono = owner;
        nomeProduto = nome;
        valorProduto = valor;
        urlIPFS = endereco;
        descricaoProduto = descricao;
    }
    
    function getInfo()public view returns(address owner, string memory nome, uint valor, string memory url, string memory descricao){
        owner = dono;
        nome = nomeProduto;
        valor = valorProduto;
        url = urlIPFS;
        descricao = descricaoProduto;
    }
    
    function alteraValor(uint novoValor)public {
        require(tx.origin == dono);
        require(novoValor > 0);
        valorProduto = novoValor;
    }
    
}

