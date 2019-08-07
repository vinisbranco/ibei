class Produto{
  String _nome;
  String _vendedor;
  double _preco;
  String _idProduto;

  Produto(this._nome, this._vendedor, this._preco, this._idProduto);

  double get preco => _preco;

  String get vendedor => _vendedor;

  String get nome => _nome;

  String get idProduto => _idProduto;

}