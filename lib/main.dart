import 'package:else_admin_two/HomePage.dart';
import 'package:else_admin_two/drawer/drawer_router.dart';
import 'package:else_admin_two/utils/Contants.dart';
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
  final List<String> listData = <String>['Events', 'Shops', 'Deals', 'FeedBacks', 'Request'];
  DrawerRoute handler = new DrawerRoute();

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
        child: ListView.separated(
          physics: NeverScrollableScrollPhysics(),
          separatorBuilder: (context, index) => Divider(
            color: Constants.dividerColor,
            indent: SizeConfig.blockSizeHorizontal * 5,
            endIndent: SizeConfig.blockSizeHorizontal * 5,
          ),
          itemCount: listData.length,
          shrinkWrap: true,
          itemBuilder: (BuildContext context, int index) {
            return ListTile(
              title: Text('${listData[index]}'),
              trailing: Icon(Icons.arrow_forward),
              onTap: () {
                handler.routeToProfileOptions(context, index);
              },
            );
          },
        ),
        // Populate the Drawer in the next step.
      )),
      body: HomePage(),
    );
  }
}
