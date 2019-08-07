import 'package:web3dart/web3dart.dart';
import 'package:http/http.dart';
import 'Produto.dart';

class Api{
  static final String txtAbi = "";
  static final httpClient = Client();
  static final ethClient = Web3Client("https://ropsten.infura.io/v3/0299249ae8cf4874b007772547f8bc72", httpClient);
  static final String lojaAddress = "0xdc773a81c4a6b03dadb621df8b33019e66c1b99d";
  static final lojaABI =
  ContractABI.parseFromJSON(txtAbi, 'Loja');

  static Credentials credentials = Credentials.fromPrivateKeyHex("A36F41ABDA75DDC60990164BC94685D8488EDA42071C0A56DEFF2825F43BB60E");

  static final lojaContract = DeployedContract(
      lojaABI, EthereumAddress(lojaAddress), ethClient, credentials);

  static Future compraProduto(String idProduto) async {
    final compraProdutoFN = lojaContract.findFunctionsByName('comprarProduto').first;

    final transaction = Transaction(keys:credentials, maximumGas: 5700000, gasPrice: EtherAmount.inWei(BigInt.from(5700000000)))
        .prepareForCall(
        lojaContract, compraProdutoFN, [EthereumAddress(idProduto).number]);

    transaction.send(ethClient,chainId: 3);
  }

  static Future buscaProdutos() async {

    final getProdutosFN = lojaContract.findFunctionsByName('getProdutos').first;

    final SystemResponse = await Transaction(keys: credentials, maximumGas: 0)
        .prepareForCall(
        lojaContract, getProdutosFN, []).call(ethClient,chainId: 3);

    return SystemResponse;
  }

  static Future _buscaProdutoId(BigInt id) async {

    final getProdutoFN = lojaContract.findFunctionsByName('getProduto').first;


    final SystemResponse = await Transaction(keys: credentials, maximumGas: 0)
        .prepareForCall(
        lojaContract, getProdutoFN, [id]).call(ethClient,chainId: 3);
    return SystemResponse;
  }

}