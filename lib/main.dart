import 'package:else_admin_two/event/AddEventScreen.dart';
import 'package:else_admin_two/shop/shop_screen.dart';
import 'package:else_admin_two/utils/SizeConfig.dart';
import 'package:flutter/material.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Else Admin',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(title: 'Else Admin'),
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
  @override
  initState(){
    super.initState();
  }
  _redirectToAddEventPage() {
    Navigator.push(context,
        MaterialPageRoute(builder: (BuildContext context) => AddEventScreen()));
  }

  _redirectToShopPage() {
    Navigator.push(context,
        MaterialPageRoute(builder: (BuildContext context) => ShopScreen()));
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: ListView(
          padding: const EdgeInsets.all(3),
          children: <Widget>[
            Container(
              padding: EdgeInsets.only(
              top: SizeConfig.blockSizeVertical * 1,
              left: SizeConfig.blockSizeHorizontal * 2),
              child: GestureDetector(
                onTap: _redirectToAddEventPage,
                child: Text("Add an event"),
              ),
            ),
            Divider(
              endIndent: SizeConfig.blockSizeHorizontal * 60,
              color: Colors.black87,
              height: SizeConfig.blockSizeVertical,
            ),
            Container(
              padding: EdgeInsets.only(
                  top: SizeConfig.blockSizeVertical * 1,
                  left: SizeConfig.blockSizeHorizontal * 2),
              child: GestureDetector(
                child: Text("Add Shop"),
              ),
            ),
            Divider(
              endIndent: SizeConfig.blockSizeHorizontal * 60,
              color: Colors.black87,
              height: SizeConfig.blockSizeVertical,
            ),
            SizedBox(
              height: MediaQuery.of(context).size.height/12,
              child: RaisedButton(
                onPressed: _redirectToAddEventPage,
                child: Text("Events"),
                color: Colors.white,
                textColor: Colors.green,
              ),
            ),
            SizedBox(
              height: MediaQuery.of(context).size.height/12,
              child: RaisedButton(
                onPressed: _redirectToShopPage,
                child: Text("Shops"),
                color: Colors.white,
                textColor: Colors.red,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
