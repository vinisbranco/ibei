import 'package:flutter/material.dart';
import 'Produto.dart';

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

  void initState(){
    produtos = new List();
    super.initState();
    carregaProdutos();
  }

  void carregaProdutos(){
    produtos.add(new Produto("Ford Focus 2015", "0x7815696ecbf1c96e6894b779456d330e", 32.12, ""));
    produtos.add(new Produto("Iphone 8", "0xa8f5f167f44f4964e6c998dee827110c", 4.23, ""));
    produtos.add(new Produto("Jabulani", "0x7c90c1fb31c4ac6d2a8f8050ce2a0c8c", 0.54, ""));
    produtos.add(new Produto("Caneca Avengers", "0x355a23b0542bb64cd36241241b838a22", 0.02, ""));
    produtos.add(new Produto("Carburador Opala 77", "0x0056ab8201fdb3e89c9411e77ee300ad", 0.98, ""));
    produtos.add(new Produto("Teclado Dell", "0x0056ab8201fdb3e89c9411e77ee300ad", 0.32, ""));
    produtos.add(new Produto("Camisa Polo Azul", "0x0056ab8201fdb3e89c9411e77ee300ad", 0.05, ""));
    produtos.add(new Produto("Windows 10 Ultimate", "0x0056ab8201fdb3e89c9411e77ee300ad", 2.41, ""));
    setState(() {
      produtos = produtos;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromRGBO(58, 66, 86, 1.0),
      bottomNavigationBar: makeBottom(),
      appBar: AppBar(
        title: Text("ShopChain"),
        centerTitle: true,
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.list),
            onPressed: () {},
          )
        ],
      ),
      body: makeBody(),
    );
  }

  Widget makeBottom(){
    return Container(
      height: 55.0,
      child: BottomAppBar(
        color: Color.fromRGBO(58, 66, 86, 1.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            Icon(Icons.attach_money, color: Colors.white,),
            Text(
              "Saldo: 4.325 ETH",
              style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 20),
            ),
            Icon(Icons.attach_money, color: Colors.white,),
          ],
        ),
      ),
    );
  }

  Widget makeBody (){
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
                      Text(" "+prod.preco.toString()+" ETH", style: TextStyle(color: Colors.white))
                    ],
                  ),
                  trailing:
                  Icon(Icons.shopping_cart, color: Colors.white, size: 30.0)
              ),
            ),
          );
        },
      ),
    );
  }
}
