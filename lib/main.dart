import 'package:else_admin_two/HomePage.dart';
import 'package:else_admin_two/event/AllEventScreen.dart';
import 'package:else_admin_two/deals/deal_list.dart';
import 'package:else_admin_two/requests/request_page.dart';
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
  initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      drawer: Drawer(
          child: Center(
        child: ListView(
          physics: NeverScrollableScrollPhysics(),
          shrinkWrap: true,
          children: <Widget>[
            RaisedButton(
              onPressed: _redirectToEventPage,
              child: Text("Events"),
              color: Colors.white,
              textColor: Colors.brown,
            ),
            RaisedButton(
              onPressed: _redirectToShopPage,
              child: Text("Shops"),
              color: Colors.white,
              textColor: Colors.red,
            ),
            RaisedButton(
              onPressed: _redirectToDealsPage,
              child: Text("Deals"),
              color: Colors.white,
              textColor: Colors.green,
            ),
          ],
        ),
        // Populate the Drawer in the next step.
      )),
      body: HomePage(),
    );
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
}
