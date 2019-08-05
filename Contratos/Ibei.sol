pragma solidity ^0.5.1;

contract Plataforma{
    address private owner;
    Produto[] private todosProdutos;
    mapping(address => Produto[])private produtoLoja;
    Loja[] private lojasCadastradas;
    mapping(address => Loja)private infoLoja;
    Cliente[] private clienteCadastradas;
    mapping(address => Cliente)private infoCliente;
    
    constructor()public{
        owner = msg.sender;
    }
    
    function cadastraLoja(string memory nome, string memory descricao)public {
        Loja l = new Loja(nome, descricao);
        lojasCadastradas.push(l);
        infoLoja[msg.sender] = l;
    }
    
    function cadastraCliente(string memory nome, string memory cpf)public {
        Cliente c = new Cliente(nome, cpf);
        clienteCadastradas.push(c);
        infoCliente[msg.sender] = c;
    }
    
    function getLojas()public view returns(Loja[] memory lojas){
        lojas = lojasCadastradas;
    }
    
    function getClientes()public view returns(Cliente[] memory clientes){
        clientes = clienteCadastradas;
    }
    
    function getProdutos()public view returns(Produto[] memory produtos){
        produtos = todosProdutos;
    }
    
    function existeLoja(Loja l)public view returns(bool){
        for(uint i; i<lojasCadastradas.length; i++){
            if(lojasCadastradas[i] == l){
                return true;
            }
        }
        return false;
    }
    
    function existeCliente(Cliente c)public view returns(bool){
        for(uint i; i<clienteCadastradas.length; i++){
            if(clienteCadastradas[i] == c){
                return true;
            }
        }
        return false;
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
    
    function retiraDeVenda(Produto p)public {
        for(uint i=0; i<todosProdutos.length; i++){
            if(p == todosProdutos[i]){
                delete todosProdutos[i];
            }
        }
    }
    
    function realizaVenda(Produto p, address donoLoja, uint quantidade)public {
        infoLoja[donoLoja].vendeProduto(p, quantidade);
    }
    
}

contract Cliente{
    
    address private dono;
    string private nomeCliente;
    string private cpf;
    Produto[]private produtosComprados;
    
    constructor(string memory nome, string memory nCPF)public{
        dono = tx.origin;
        nomeCliente = nome;
        cpf = nCPF;
    }
    function adicionaProduto(Produto p)public {
        produtosComprados.push(p);
    }
    
    function getProdutos()public returns(address owner, string memory nome, string memory nCPF, Produto[] memory produtos){
        owner = dono;
        nome = nomeCliente;
        cpf = nCPF;
        produtos = produtosComprados;
    }
    
    function compraProduto(Produto p, Plataforma plataforma,address donoLoja, uint quantidade)public {
        require(msg.sender == dono);
        produtosComprados.push(p);
        plataforma.realizaVenda(p,donoLoja, quantidade);
    }
    
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
    
    function getQuantidade(Produto p)public view returns(uint quant){
        quant = infoProduto[address(p)].quantidadeDisponivel;
    }
    
    function desativaProduto(Produto prod)public {
        require(msg.sender == proprietario);
        infoProduto[address(prod)].estaAtivo = false;
    }
    
    function vendeProduto(Produto p, uint quantidade)public{
        require(quantidade > 0);
        require(infoProduto[address(p)].quantidadeDisponivel >= quantidade);
        
        if(infoProduto[address(p)].quantidadeDisponivel == quantidade){
            infoProduto[address(p)].quantidadeDisponivel = 0;
            infoProduto[address(p)].estaAtivo = false;
        }else{
            infoProduto[address(p)].quantidadeDisponivel -= quantidade;
        }
        
    }
    
    function adicionaProduto(Produto p, uint quantidade)public{
        require(msg.sender == proprietario);
        if(!infoProduto[address(p)].estaAtivo){
            infoProduto[address(p)].estaAtivo = true;
        }
        infoProduto[address(p)].quantidadeDisponivel += quantidade;
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

