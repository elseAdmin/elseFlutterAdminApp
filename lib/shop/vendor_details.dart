import 'package:cached_network_image/cached_network_image.dart';
import 'package:else_admin_two/shop/models/shop_model.dart';
import 'package:else_admin_two/shop/new_vendor.dart';
import 'package:else_admin_two/utils/Contants.dart';
import 'package:flutter/material.dart';
import '../utils/SizeConfig.dart';

class VendorDetails extends StatelessWidget {
  final ShopModel _shopModel;
  VendorDetails(this._shopModel);
  double userRating = -1;
  String userReview;

  setUserRating(double rating) {
    userRating = rating;
  }

  _redirectToNewVendorPage(BuildContext context){
//    Navigator.push(context,
//        MaterialPageRoute(builder: (BuildContext context) => NewVendor(_shopModel)));
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return Scaffold(
      body: Container(
        color: Constants.mainBackgroundColor,
        child: CustomScrollView(
          slivers: <Widget>[
            SliverAppBar(
              expandedHeight: SizeConfig.blockSizeVertical * 25,
              floating: false,
              pinned: true,
              flexibleSpace: FlexibleSpaceBar(
                  centerTitle: true,
                  background: Opacity(
                      opacity: 0.6,
                      child: CachedNetworkImage(
                        fit: BoxFit.cover,
                        placeholder: (context, url) =>
                            CircularProgressIndicator(),
                        imageUrl: _shopModel.imageUrl,
                      ))),
            ),
            SliverList(
              delegate: SliverChildListDelegate(
                [
                  Card(
                    child: ListTile(
                      title: Text('${_shopModel.name}',
                          style: TextStyle(
                              fontSize: 20,
                              color: Constants.textColor,
                              fontWeight: FontWeight.w900)),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          paddingData(),
                          paddingData(),
                          Text('${_shopModel.about}',
                              style: TextStyle(
                                  fontSize: 15,
                                  color: Constants.textColor,
                                  fontWeight: FontWeight.w300)),
                        ],
                      ),
                    ),
                  ),
                  Card(
                    child: ListTile(
                      title: Text('Details',
                          style: TextStyle(
                              fontSize: 20,
                              color: Constants.textColor,
                              fontWeight: FontWeight.w600)),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          richTextData("Shop No", _shopModel.shopNo),
                          richTextData("Floor", _shopModel.floor.toString()),
                          richTextData(
                              "Timing",
                              _shopModel.openTime +
                                  ' to ' +
                                  _shopModel.closeTime),
                          richTextData("Contant Info", _shopModel.contactInfo),
                        ],
                      ),
                    ),
                  ),
                  Card(
                    child: ListTile(
                      title: Text('Offers',
                          style: TextStyle(
                              fontSize: 20,
                              color: Constants.textColor,
                              fontWeight: FontWeight.w600)),
                      subtitle: Text('Yet to start offer on this',
                          style: TextStyle(
                              fontSize: 12,
                              color: Constants.textColor,
                              fontWeight: FontWeight.w400)),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(bottom: SizeConfig.blockSizeVertical*3),
                  ),
                  Card(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: <Widget>[
                        Expanded(
                          child: RaisedButton(
                            child: Center(child: Text("Delete"),),
                            color: Colors.white,
                            textColor: Colors.red,
                          ),
                        ),
                        Expanded(
                          child: RaisedButton(
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => NewVendor(_shopModel),
                                ),
                              );
                            },
                            color: Colors.white,
                            textColor: Colors.red,
                            child: Center(child: Text("Edit"),),
                          ),
                        ),
                      ],
                    ),
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget paddingData() {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10.0),
    );
  }

  Widget richTextData(String heading, String data) {
    return RichText(
      text: TextSpan(
          text: '$heading : ',
          style: TextStyle(
              color: Constants.textColor, fontWeight: FontWeight.w600),
          children: <TextSpan>[
            TextSpan(
              text: '$data',
              style: TextStyle(
                  color: Constants.textColor, fontWeight: FontWeight.w400),
            ),
          ]),
    );
  }
}
