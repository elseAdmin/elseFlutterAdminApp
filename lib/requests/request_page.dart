import 'package:else_admin_two/firebaseUtil/api.dart';
import 'package:else_admin_two/requests/models/request_crud_model.dart';
import 'package:else_admin_two/requests/models/request_model.dart';
import 'package:else_admin_two/utils/Contants.dart';
import 'package:flutter/material.dart';

class RequestPage extends StatefulWidget{
  @override
  _RequestPage createState() => _RequestPage();
}

class _RequestPage extends State<RequestPage>{
  RequestCrudModel _requestCrudModel = RequestCrudModel(new Api("/unityOneRohini/requests/allRequests"));
  List<Request> _requests = List();
  
  @override
  void initState() {
    super.initState();
    _requestCrudModel.fetchRequests().then((requestList){
      _requests = requestList;
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Requests"),
      ),
      body: SingleChildScrollView(
        child: ListView.separated(
          separatorBuilder: (context, index) => Divider(
            color: Colors.black,
          ),
          shrinkWrap: true,
          itemCount: _requests.length,
          itemBuilder: (BuildContext context, int index){
            return Card(
              child: ListTile(
                title: richTextData('Message', _requests[index].message),
                subtitle: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    richTextData('Name', _requests[index].name),
                    richTextData('Phone', _requests[index].phoneNumber),
                  ],
                ),
              ),
            );
          },
        ),
      ),
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