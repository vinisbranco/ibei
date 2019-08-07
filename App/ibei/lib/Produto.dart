class Produto{
  String _idProduto;
  String _dono;
  String _nome;
  String _descricao;
  double _preco;
  bool _estaVendido;

  Produto(this._idProduto, this._dono, this._nome, this._descricao,
      this._preco, this._estaVendido);

  bool get estaVendido => _estaVendido;

  double get preco => _preco;

  String get descricao => _descricao;

  String get nome => _nome;

  String get dono => _dono;

  String get idProduto => _idProduto;


}