import 'package:cached_network_image/cached_network_image.dart';
import 'package:else_admin_two/deals/models/deals_model.dart';
import 'package:else_admin_two/deals/new_deal.dart';
import 'package:else_admin_two/firebaseUtil/firebase_api.dart';
import 'package:else_admin_two/utils/Contants.dart';
import 'package:flutter/material.dart';

import '../utils/SizeConfig.dart';

class DealsDetails extends StatefulWidget {
  final DealModel deals;
  final List tnc;
  final List details;

  DealsDetails(this.deals, this.tnc, this.details);

  @override
  _DealsDetails createState() => _DealsDetails();
}

class _DealsDetails extends State<DealsDetails>{
  bool _buttonPressed=false;
  FireBaseApi _fireBaseApi = FireBaseApi("dealsStaticData");

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
                  background:Opacity(
                      opacity: 0.6,
                      child:  CachedNetworkImage(
                    fit: BoxFit.cover,
                    placeholder: (context, url) => CircularProgressIndicator(),
                    imageUrl: widget.deals.url,
                  ))),
            ),
            SliverList(
              delegate: SliverChildListDelegate(
                [
                  paddingData(),
                  Card(
                    child: ListTile(
                      title: Text('${widget.deals.name}',
                          style: TextStyle(
                              fontSize: 20,
                              color: Constants.textColor,
                              fontWeight: FontWeight.w900
                          )),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          paddingData(),
                          paddingData(),
                          Text(
                              '${widget.deals.details}',
                              style: TextStyle(
                                  fontSize: 15,
                                  color: Constants.textColor,
                                  fontWeight: FontWeight.w300
                              )
                          ),
                          paddingData(),
                        ],
                      ),
                    ),
                  ),
                  paddingData(),
                  Card(
                    child: ListTile(
                      title: Text('Terms and Conditions',
                          style: TextStyle(
                              fontSize: 20,
                              color: Constants.textColor,
                              fontWeight: FontWeight.w600
                          )),
                      subtitle: ListView.builder(
                        shrinkWrap: true,
                        itemCount: widget.deals.details.length,
                        padding: EdgeInsets.all(8.0),
                        itemBuilder: (BuildContext context, int index) {
                          return Text(
                              '• ${widget.details[index]}',
                              style: TextStyle(
                                color: Constants.test,
                              )
                          );
                        },
                      ),
                    ),
                  ),
                  paddingData(),
                  Card(
                    child: ListTile(
                      title: Text('Details',
                          style: TextStyle(
                              fontSize: 20,
                              color: Constants.textColor,
                              fontWeight: FontWeight.w600
                          )),
                      subtitle: ListView.builder(
                        shrinkWrap: true,
                        itemCount: widget.deals.tnc.length,
                        padding: EdgeInsets.all(8.0),
                        itemBuilder: (BuildContext context, int index) {
                          return Text(
                              '• ${widget.tnc[index]}',
                              style: TextStyle(
                                color: Constants.test,
                              )
                          );
                        },
                      ),
                    ),
                  ),
                  paddingData(),
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                    ),
                    child: ListTile(
                      contentPadding: const EdgeInsets.only(
                          left: 10, right: 10, top: 10, bottom: 10),
                      title: Visibility(
                        child: FlatButton(
                          color: Colors.white,
                          onPressed: () {
                            setState(() {
                              _buttonPressed = !_buttonPressed;
                            });
                          },
                          child: Text(
                            'Show Coupon Code',
                            style: TextStyle(
                                fontWeight: FontWeight.bold
                            ),
                          ),
                        ),
                        maintainSize: !_buttonPressed,
                        maintainAnimation: !_buttonPressed,
                        maintainState: !_buttonPressed,
                        visible: !_buttonPressed,
                      ),
                      subtitle: Visibility(
                        child: Text(
                          'Coupon Code : ${widget.deals.couponCode}',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              fontWeight: FontWeight.bold
                          ),
                        ),
                        maintainSize: _buttonPressed,
                        maintainAnimation: true,
                        maintainState: true,
                        visible: _buttonPressed,
                      ),
                    ),
                  ),
                  paddingData(),
                  Card(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: <Widget>[
                        Expanded(
                          child: RaisedButton(
                            onPressed: () {
                              print('${widget.deals.name} removing deal');
                              _fireBaseApi.removeSnapshot(widget.deals.uid);
                              Navigator.pop(context);
                            },
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
                                  builder: (context) => NewDeal(widget.deals),
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

  Widget paddingData(){
    return Padding(
      padding: const EdgeInsets.only(bottom: 10.0),
    );
  }
}