import 'package:else_admin_two/event/AllEventScreen.dart';
import 'package:else_admin_two/firebaseUtil/database_manager.dart';
import 'package:else_admin_two/deals/deal_list.dart';
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
    DatabaseManager().getAllEvents();
  }
  _redirectToEventPage() {
    Navigator.push(context,
        MaterialPageRoute(builder: (BuildContext context) => AllEventScreen()));
  }

  _redirectToShopPage() {
    Navigator.push(context,
        MaterialPageRoute(builder: (BuildContext context) => ShopScreen()));
  }

  _redirectToDealsPage() {
    Navigator.push(context,
        MaterialPageRoute(builder: (BuildContext context) => DealSection()));
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
            SizedBox(
              height: MediaQuery.of(context).size.height/12,
              child: RaisedButton(
                onPressed: _redirectToEventPage,
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
            SizedBox(
              height: MediaQuery.of(context).size.height/12,
              child: RaisedButton(
                onPressed: _redirectToDealsPage,
                child: Text("Deals"),
                color: Colors.white,
                textColor: Colors.green,
              ),
            )
          ],
        ),
      ),
    );
  }
}
