import 'package:cached_network_image/cached_network_image.dart';
import 'package:else_admin_two/event/AddEventScreen.dart';
import 'package:else_admin_two/event/viewEvent.dart';
import 'package:else_admin_two/firebaseUtil/database_manager.dart';
import 'package:else_admin_two/utils/Contants.dart';
import 'package:else_admin_two/utils/SizeConfig.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class AllEventScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => AllEventScreenState();
}

class AllEventScreenState extends State<AllEventScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Constants.titleBarBackgroundColor,
          leading: IconButton(
            icon: Icon(Icons.arrow_back, color: Colors.black),
            onPressed: () => Navigator.of(context).pop(),
          ),
          title: Text("Events",
              style: TextStyle(
                color: Constants.titleBarTextColor,
                fontSize: 18,
              )),
          centerTitle: true,
        ),
        body: Container(
          color: Constants.mainBackgroundColor,
          child: CustomScrollView(
            slivers: <Widget>[
              SliverPadding(
                  padding: EdgeInsets.only(
                      top: SizeConfig.blockSizeVertical * 1,
                      left: SizeConfig.blockSizeHorizontal * 2,
                      right: SizeConfig.blockSizeHorizontal * 2),
                  sliver: SliverList(
                      delegate: SliverChildBuilderDelegate(
                    (BuildContext context, int index) {
                      return Container(
                          height: SizeConfig.blockSizeVertical * 24,
                          width: SizeConfig.blockSizeHorizontal * 96,
                          child: GestureDetector(
                              onTap: () {Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (BuildContext context) => ViewSingleEvent(DatabaseManager.events[index])));},
                              child: CachedNetworkImage(
                                  fit: BoxFit.cover,
                                  imageUrl:
                                      DatabaseManager.events[index].url)));
                    },
                    childCount: DatabaseManager.events.length,
                  ))),
            ],
          ),
        ),
      floatingActionButton: FloatingActionButton(onPressed: navigateAddEvent, child: Icon(Icons.add),),
    );

  }
  navigateAddEvent(){
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (BuildContext context) => AddEventScreen()));
  }
}
