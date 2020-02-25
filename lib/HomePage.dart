import 'dart:collection';

import 'package:else_admin_two/requests/request_page.dart';
import 'package:else_admin_two/utils/Contants.dart';
import 'package:flutter/material.dart';

import 'feedback/AllFeedbacks.dart';
import 'firebaseUtil/database_manager.dart';

class HomePage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => HomePageState();
}

class HomePageState extends State<HomePage> {
  Map counts = HashMap();
  @override
  void initState() {
    super.initState();
    DatabaseManager().getCounts(countFetched);
  }

  countFetched(Map counts) {
    setState(() {
      this.counts = counts;
    });
  }

  Future<Null> _handleRefresh() async {
    DatabaseManager().getCounts(countFetched);
    return null;
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return RefreshIndicator(
        onRefresh: _handleRefresh,
        child: Container(
          color: Constants.mainBackgroundColor,
          child: ListView(
            shrinkWrap: true,
            children: <Widget>[
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: <Widget>[
                  GestureDetector(
                    onTap: _redirectToFeedbackPage,
                    child:Stack(
                    children: <Widget>[
                      Column(children: <Widget>[
                        Text(
                          counts['feedback'].toString(),
                          style: TextStyle(fontSize: 50),
                        ),
                        Text(
                          'Feedbacks',
                          style: TextStyle(fontSize: 28),
                        ),
                      ])
                    ],
                  )),
                  GestureDetector(
                    onTap: _redirectToRequestsPage,
                      child: Stack(
                    children: <Widget>[
                      Column(
                        children: <Widget>[
                          Text(
                            counts['request'].toString(),
                            style: TextStyle(fontSize: 50),
                          ),
                          Text(
                            'Requests',
                            style: TextStyle(fontSize: 28),
                          )
                        ],
                      )
                    ],
                  )),
                ],
              )
            ],
          ),
        ));
  }
  _redirectToRequestsPage() {
    Navigator.push(context,
        MaterialPageRoute(builder: (BuildContext context) => RequestPage()));
  }
  _redirectToFeedbackPage(){
    Navigator.push(context,
        MaterialPageRoute(builder: (BuildContext context) => AllFeedback()));
  }
}
