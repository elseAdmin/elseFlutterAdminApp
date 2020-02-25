import 'package:else_admin_two/deals/deals_details.dart';
import 'package:else_admin_two/deals/models/deals_model.dart';
import 'package:else_admin_two/deals/new_deal.dart';
import 'package:else_admin_two/utils/Contants.dart';
import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';

import '../firebaseUtil/database_manager.dart';
import '../utils/SizeConfig.dart';

class DealSection extends StatefulWidget {
  @override
  _DealSectionState createState() => new _DealSectionState();
}

class _DealSectionState extends State<DealSection> {
  List<DealModel> deals = new List();
  final DatabaseManager manager = DatabaseManager();

  @override
  void initState() {
    super.initState();

    manager.getDealsDBRef()
        .orderByChild('status')
        .equalTo('active')
        .once()
        .then((snapshot) {
      if (snapshot.value.length != 0) {
        deals = List();
        for (int i = 0; i < snapshot.value.length; i++) {
          if (snapshot.value[i] != null) {
            DealModel deal = DealModel.fromMap(snapshot.value[i]);
            deals.add(deal);
          }
        }
        setState(() {});
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    if(deals!=null){
      return Scaffold(
        appBar: AppBar(
          title: Text("Deals"),
        ),
        floatingActionButton: FloatingActionButton(
          child: Icon(Icons.add),
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => NewDeal(null),
              ),
            );
          },
        ),
        body: Container(
          padding: EdgeInsets.only(
            left: SizeConfig.blockSizeHorizontal * 1,
            right: SizeConfig.blockSizeHorizontal * 1
          ),
          height: MediaQuery.of(context).size.height,
          child: GridView.builder(
            itemCount: deals.length,
            gridDelegate:
            SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2),
            itemBuilder: (context, index) {
              return Container(
                width: MediaQuery.of(context).size.width * 0.50,
                child: Card(
                  child: GestureDetector(
                    onTap:  () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (BuildContext context) =>
                            DealsDetails(deals[index], deals[index].tnc.toList(), deals[index].details.toList()),
                        ),
                      );
                    },
                    child: Stack(
                      fit: StackFit.passthrough,
                      children: <Widget>[
                        Opacity(
                          opacity: 0.4,
                          child:CachedNetworkImage(
                            fit: BoxFit.cover,
                            imageUrl: deals[index].blurUrl,
                          ),
                        ),
                        Card(
                          margin: EdgeInsets.all(0.0),
                          color: Colors.transparent,
                          child: Center(
                            child:  Text(deals[index].shortDetails,
                              style: TextStyle(
                                color: Constants.mainBackgroundColor,
                                fontWeight: FontWeight.w800,
                                fontSize: 16
                              ),
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                ),
              );
            }
          )
        ),
      );
    }else{
      return Text("No deals as such");
    }
  }

}
