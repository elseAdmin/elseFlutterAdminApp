import 'package:else_admin_two/feedback/feedback_preview.dart';
import 'package:else_admin_two/feedback/models/feedback_crud_model.dart';
import 'package:else_admin_two/feedback/models/feedback_model.dart';
import 'package:else_admin_two/firebaseUtil/api.dart';
import 'package:else_admin_two/utils/Contants.dart';
import 'package:else_admin_two/utils/app_startup_data.dart';
import 'package:else_admin_two/utils/helper_methods.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class FeedbackPage extends StatefulWidget {
  final List<FeedBackPreview> _feedBackPreviewMap;
  final VoidCallback refreshList;
  FeedbackPage(this._feedBackPreviewMap, this.refreshList);

  @override
  _FeedbackPage createState() => _FeedbackPage();
}

class _FeedbackPage extends State<FeedbackPage> {
  final _formKey = GlobalKey<FormState>();
  TextEditingController _commentController = TextEditingController();
  static String pathFeedbackCollection = StartupData.dbreference+'/feedback/allfeedbacks';
  final FeedbackCrudModel feedbackCrudModel = FeedbackCrudModel(new Api(pathFeedbackCollection));

  String getFeedBackType(bool feedbackType) {
    if (feedbackType) return "POSITIVE";
    return "NEGATIVE";
  }

  _changeFeedBack(FeedBack _feedback){
    _feedback.comment = _commentController.text;
    _feedback.updatedDate = DateTime.now().millisecondsSinceEpoch;
    feedbackCrudModel.updateFeedBack(_feedback, _feedback.id).then((value){
      showModalBottomSheet(context: context, builder: (context){
        return getModal();
      });
    });
  }

  Widget getModal(){
    return Container(
      height: MediaQuery.of(context).size.height / 4,
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(
          color: Colors.white70,
          width: 1.0,
        ),
      ),
      child: Column(
        children: <Widget>[
          ListTile(
            title: Text("FeedBack Updated", textAlign: TextAlign.center,),
            subtitle: Text("Our team has started working on this......"),
          ),
          Padding(
            padding: const EdgeInsets.only(bottom: 10.0),
          ),
          FlatButton(
            color: Colors.white,
            onPressed: (){
              Navigator.pop(context);
              widget.refreshList();
            },
            child: Text('Ok', style: TextStyle(fontWeight: FontWeight.bold,
                fontSize: 20.0),),
          )
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      shrinkWrap: true,
      itemCount: widget._feedBackPreviewMap.length,
      itemBuilder: (BuildContext context, int index) {
        return ExpansionTile(
          title: ListTile(
            title: Text(
              '${widget._feedBackPreviewMap[index].feedBack.subject}',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            contentPadding: EdgeInsets.all(15.0),
            isThreeLine: true,
            subtitle: Padding(
              padding: const EdgeInsets.only(
                  left: 0.0, top: 8.0, right: 0.0, bottom: 0.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  richTextData('Updated On', DateTime.fromMillisecondsSinceEpoch(widget._feedBackPreviewMap[index].feedBack.updatedDate).day.toString()+" "+HelperMethods().getMonthNameForMonth(DateTime.fromMillisecondsSinceEpoch(widget._feedBackPreviewMap[index].feedBack.updatedDate).month.toString())),
                  richTextData('Place', widget._feedBackPreviewMap[index].universe),
                ],
              ),
            ),
          ),
          children: <Widget>[
            Card(
              child: ListTile(
                contentPadding:
                EdgeInsets.only(left: 8.0, top: 0.0, right: 8.0, bottom: 8.0),
                title: imageGrid(widget._feedBackPreviewMap[index].feedBack),
                subtitle: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: <Widget>[
                      Text(widget._feedBackPreviewMap[index].feedBack.content),
                      richTextData('FeedBack ID', widget._feedBackPreviewMap[index].feedBack.id),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          richTextData(
                              "Type", getFeedBackType(widget._feedBackPreviewMap[index].feedBack.typeOfFeedBack)),
                          richTextData(
                              "Intensity", widget._feedBackPreviewMap[index].feedBack.feedbackIntensity.toString()),
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Text("Status",style: TextStyle(
                              color: Constants.textColor, fontWeight: FontWeight.w600)),
                          DropdownButton<String>(
                            value: widget._feedBackPreviewMap[index].feedBack.feedbackStatus,
                            icon: Icon(Icons.arrow_downward),
                            iconSize: 24,
                            elevation: 16,
                            style: TextStyle(color: Colors.black),
                            underline: Container(
                              height: 2,
                              color: Colors.black12,
                            ),
                            onChanged: (String newValue) {
                              print(newValue);
                              widget._feedBackPreviewMap[index].feedBack.feedbackStatus = newValue;
                              setState(() {});
                            },
                            items: <String>['PENDING','IN_PROCESS', 'ACKNOWLEDGED', 'COMPLETED','INVALID']
                                .map<DropdownMenuItem<String>>((String value) {
                              return DropdownMenuItem<String>(
                                value: value,
                                child: Text(value),
                              );
                            }).toList(),
                          )
                        ],
                      ),
                      TextFormField(
                        decoration: const InputDecoration(
                            labelText: 'Comment'
                        ),
                        controller: _commentController,
                        keyboardType: TextInputType.text,
                        validator: (value) {
                          if (value == null || value.length == 0) {
                            return 'Please enter some text';
                          }
                          return null;
                        },
                      ),
                      FlatButton(
                        onPressed: (){
                          if(_formKey.currentState.validate()){
                            print("Inside Data");
                            _changeFeedBack(widget._feedBackPreviewMap[index].feedBack);
                          }
                        },
                        child: Center(child: Text("Save"),),
                      )
                    ],
                  ),
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  Widget imageGrid(FeedBack feedBack){
    if(feedBack.imageUrls.length == 0){
      return paddingData();
    }
    else{
      return Container(
        child: GridView.builder(
          shrinkWrap: true,
          physics: NeverScrollableScrollPhysics(),
          itemCount: feedBack.imageUrls.length,
          gridDelegate: new SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 3),
          itemBuilder: (context, index) {
            return Center(
              child: Card(
                elevation: 10.0,
                shape: RoundedRectangleBorder(
                    borderRadius:
                    BorderRadius.all(Radius.circular(10.0))),
                child: Image(
                  image: NetworkImage('${feedBack.imageUrls[index]}'),
                  fit: BoxFit.cover,
                  height: 200.0,
                  width: 230.0,
                ),
              ),
            );
          }
        ),
      );
    }
  }

  Widget paddingData() {
    return Padding(
      padding: const EdgeInsets.only(bottom: 5.0),
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

/*
@override
  Widget build(BuildContext context) {
    return ListView.builder(
      shrinkWrap: true,
      itemCount: 1,
      itemBuilder: (BuildContext context, int index) {
        List<ExpansionPanel> myExpansionPanelList = [];
        for (int i = 0; i < widget._feedBackPreviewMap.length; ++i) {
          myExpansionPanelList
              .add(widget._feedBackPreviewMap[i].buildExpansionPanel());
        }
        return ExpansionPanelList(
          children: myExpansionPanelList,
          expansionCallback: _onExpansion,
        );
      },
    );
  }
 */