import 'package:flutter/material.dart';
import 'Produto.dart';
import 'Api.dart';
import 'dart:math';
import 'package:web3dart/web3dart.dart';
void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Ibei',
      theme: new ThemeData(primaryColor: Color.fromRGBO(58, 66, 86, 1.0)),
      home: MyHomePage(title: 'ShopChain'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);
  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {

  List<Produto> produtos;
  bool carregandoCompra = false;

  void initState(){
    super.initState();
    carregaProdutos();
  }

  void carregaProdutos() async {
    produtos = new List();
    produtos = await Api.buscaProdutos();
    setState(() {
      produtos = produtos;
    });
  }

  void compraProduto(Produto prod) async{
    setState(() {
      carregandoCompra = true;
    });
    await Api.compraProduto(prod);
    carregaProdutos();
    setState(() {
      carregandoCompra = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromRGBO(58, 66, 86, 1.0),
      appBar: AppBar(
        title: Text("ShopChain"),
        centerTitle: true,
      ),
      body: makeBody(),
    );
  }

  Widget makeBody (){
    if(carregandoCompra){
      return Container(
        child: Center(
          child: Column(
            children: <Widget>[
              Padding(
                padding: EdgeInsets.fromLTRB(0, 30, 0, 0),
                child: CircularProgressIndicator(),
              ),
              Padding(
                padding: EdgeInsets.fromLTRB(0, 30, 0, 0),
                child: Text("Sua compra está sendo processada!",
                    style: TextStyle(color: Colors.white, fontSize: 30, ),textAlign: TextAlign.center),
              ),
            ],
          ),
        )
      );
    }else{
      return Container(
        child: ListView.builder(
          scrollDirection: Axis.vertical,
          shrinkWrap: true,
          itemCount: produtos.length,
          itemBuilder: (BuildContext context, int index) {
            Produto prod = produtos.elementAt(index);
            return Card(
              elevation: 8.0,
              margin: new EdgeInsets.symmetric(horizontal: 10.0, vertical: 6.0),
              child: Container(
                decoration: BoxDecoration(color: Color.fromRGBO(64, 75, 96, .9)),
                child: ListTile(
                    contentPadding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
                    leading: Container(
                      padding: EdgeInsets.only(right: 12.0),
                      decoration: new BoxDecoration(
                          border: new Border(
                              right: new BorderSide(width: 1.0, color: Colors.white24))),
                      child: Icon(Icons.adjust, color: Colors.white),
                    ),
                    title: Text(
                      prod.nome,
                      style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                    ),
                    // subtitle: Text("Intermediate", style: TextStyle(color: Colors.white)),

                    subtitle: Row(
                      children: <Widget>[
                        Icon(Icons.attach_money, color: Colors.white),
                        Text(" R\$ "+prod.preco.toString(), style: TextStyle(color: Colors.white))
                      ],
                    ),
                    trailing:
                    (Api.credentials.address.hex.compareTo(prod.dono) == 0) ?
                    IconButton(
                      icon:
                      Icon(Icons.check, color: Colors.green, size: 30.0),

                    )

                        : (!prod.estaVendido)
                        ?
                    IconButton(
                        icon:
                        Icon(Icons.shopping_cart, color: Colors.white, size: 30.0),
                        onPressed: (){compraProduto(prod);}
                    )
                        :
                    IconButton(
                      icon:
                      Icon(Icons.do_not_disturb, color: Colors.yellow, size: 30.0),

                    )
                ),
              ),
            );
          },
        ),
      );
    }

  }
}
