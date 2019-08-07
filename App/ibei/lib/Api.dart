import 'package:web3dart/web3dart.dart';
import 'package:http/http.dart';
import 'Produto.dart';

class Api{

  static final httpClient = Client();
  static final ethClient = Web3Client("https://ropsten.infura.io/v3/b25fe40f2df94cbe933dc5fc3f08c6b1", httpClient);
  static final String plataformaAddress = "0xd3a0cf27f45a576732bc503161d83f0374466243";
  static final plataformaABI =
  ContractABI.parseFromJSON(txtAbi, 'Plataforma');

  static Credentials credentials = Credentials.fromPrivateKeyHex("1745f0b380360cd9b70f7cf460a4155dcfa0d10b98224060e914c35a4e9eb7a7");

  static final plataformaContract = DeployedContract(
      plataformaABI, EthereumAddress(plataformaAddress), ethClient, credentials);

  static Future compraProduto(Produto prod) async {
    final compraProdutoFN = plataformaContract.findFunctionsByName('compraProduto').first;

    final transaction = Transaction(keys:credentials, maximumGas: 5700000, gasPrice: EtherAmount.inWei(BigInt.from(5700000000)))
        .prepareForCall(
        plataformaContract, compraProdutoFN, [EthereumAddress(prod.idProduto).number, EthereumAddress(prod.dono).number]);
    transaction.send(ethClient,chainId: 3);

    var produtoAux = await _buscaProdutoId(EthereumAddress(prod.idProduto).number);
    while(!produtoAux[4]){
      await new Future.delayed(const Duration(seconds: 1));
      produtoAux = await _buscaProdutoId(EthereumAddress(prod.idProduto).number);
    }

    if(produtoAux[4])
      return true;
  }

  static Future buscaProdutos() async {
    final getProdutosFN = plataformaContract
        .findFunctionsByName('getProdutos')
        .first;

    final SystemResponse = await Transaction(keys: credentials, maximumGas: 0)
        .prepareForCall(
        plataformaContract, getProdutosFN, []).call(ethClient, chainId: 3);
    List<Produto> listaProdutos = new List();
    List<dynamic> prods = SystemResponse[0];
    for (int i = 0; i < prods.length; i++) {
      var produtoAux = await _buscaProdutoId(prods.elementAt(i));
      listaProdutos.add(new Produto(
          new EthereumAddress.fromNumber(prods.elementAt(i)).hex, new EthereumAddress.fromNumber(produtoAux[0]).hex,
          produtoAux[1], produtoAux[2], int.parse(produtoAux[3].toString()) / 100, produtoAux[4]));
    }
    return listaProdutos;
  }

  static Future _buscaProdutoId(BigInt id) async {

    final getProdutoFN = plataformaContract.findFunctionsByName('getProduto').first;


    final SystemResponse = await Transaction(keys: credentials, maximumGas: 0)
        .prepareForCall(
        plataformaContract, getProdutoFN, [id]).call(ethClient,chainId: 3);
    return SystemResponse;
  }

  static final String txtAbi = '''[
	{
		"constant": true,
		"inputs": [],
		"name": "getProdutos",
		"outputs": [
			{
				"name": "codigos",
				"type": "address[]"
			}
		],
		"payable": false,
		"stateMutability": "view",
		"type": "function"
	},
	{
		"constant": true,
		"inputs": [],
		"name": "getProdutosLoja",
		"outputs": [
			{
				"name": "codigos",
				"type": "address[]"
			}
		],
		"payable": false,
		"stateMutability": "view",
		"type": "function"
	},
	{
		"constant": true,
		"inputs": [
			{
				"name": "id",
				"type": "address"
			}
		],
		"name": "getProduto",
		"outputs": [
			{
				"name": "dono",
				"type": "address"
			},
			{
				"name": "nome",
				"type": "string"
			},
			{
				"name": "descricao",
				"type": "string"
			},
			{
				"name": "preco",
				"type": "uint256"
			},
			{
				"name": "estaVendido",
				"type": "bool"
			}
		],
		"payable": false,
		"stateMutability": "view",
		"type": "function"
	},
	{
		"constant": false,
		"inputs": [
			{
				"name": "id",
				"type": "address"
			},
			{
				"name": "dono",
				"type": "address"
			}
		],
		"name": "compraProduto",
		"outputs": [],
		"payable": false,
		"stateMutability": "nonpayable",
		"type": "function"
	},
	{
		"constant": false,
		"inputs": [
			{
				"name": "id",
				"type": "address"
			},
			{
				"name": "nome",
				"type": "string"
			},
			{
				"name": "descricao",
				"type": "string"
			},
			{
				"name": "preco",
				"type": "uint256"
			}
		],
		"name": "cadastraProduto",
		"outputs": [],
		"payable": false,
		"stateMutability": "nonpayable",
		"type": "function"
	},
	{
		"constant": true,
		"inputs": [
			{
				"name": "dono",
				"type": "address"
			}
		],
		"name": "getProdutosLoja",
		"outputs": [
			{
				"name": "codigos",
				"type": "address[]"
			}
		],
		"payable": false,
		"stateMutability": "view",
		"type": "function"
	}
]''';
}