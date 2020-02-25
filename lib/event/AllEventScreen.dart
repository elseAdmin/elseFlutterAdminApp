import 'package:cached_network_image/cached_network_image.dart';
import 'package:else_admin_two/event/AddEventScreen.dart';
import 'package:else_admin_two/event/events_model.dart';
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
  List<EventModel> events = List();
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    DatabaseManager().getAllEvents(eventsFetched);
  }

  eventsFetched(events) {
    setState(() {
      this.events = events;
    });
  }

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
                    return Column(children: <Widget>[ Container(
                        height: SizeConfig.blockSizeVertical * 24,
                        width: SizeConfig.blockSizeHorizontal * 96,
                        child: GestureDetector(
                            onTap: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (BuildContext context) =>
                                          ViewSingleEvent(
                                              DatabaseManager.events[index])));
                            },
                            child: Stack(
                              fit: StackFit.passthrough,
                              children: <Widget>[
                                CachedNetworkImage(
                                    fit: BoxFit.cover,
                                    imageUrl:
                                        DatabaseManager.events[index].url),
                                Row(
                                  crossAxisAlignment: CrossAxisAlignment.end,
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: <Widget>[
                                    Text('submissions ',style: TextStyle(fontSize: 26,color: Colors.white),),
                                    Text(events[index]
                                        .submissionCount
                                        .toString(),style: TextStyle(fontSize: 32,color: Colors.white))
                                  ],
                                )
                              ],
                            ))),
                    Padding(padding: EdgeInsets.only(bottom: SizeConfig.blockSizeHorizontal),)]);
                  },
                  childCount: events.length,
                ))),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: navigateAddEvent,
        child: Icon(Icons.add),
      ),
    );
  }

  navigateAddEvent() {
    Navigator.push(context,
        MaterialPageRoute(builder: (BuildContext context) => AddEventScreen()));
  }
}
