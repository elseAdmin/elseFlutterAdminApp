import 'dart:io';

import 'package:else_admin_two/event/BackgroundPicture.dart';
import 'package:else_admin_two/event/beacon_model.dart';
import 'package:else_admin_two/event/events_model.dart';
import 'package:else_admin_two/firebaseUtil/database_manager.dart';
import 'package:else_admin_two/utils/SizeConfig.dart';
import 'package:else_admin_two/utils/pick_gallery_impl.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:fluttertoast/fluttertoast.dart';

class AddEventScreen extends StatefulWidget {
  @override
  createState() => AddEventScreenState();
}

class AddEventScreenState extends State<AddEventScreen> {
  String statusValue = 'active';
  String typeValue = "Online";
  DateTime selectedStartDate = DateTime.now();
  DateTime selectedEndDate = DateTime.now();
  String uid, name, description,major,minor,observedDays;
  File backgroundImage;

  List<TextEditingController> ruleControllers = [];
  TextEditingController ruleController = TextEditingController();
  int ruleCount = 0;
  List<Widget> ruleChildren = [];

  @override
  initState(){
    ruleControllers.add(ruleController);
    super.initState();
  }


  final _formKey = GlobalKey<FormState>();
  _selectStartDate(BuildContext context) async {
    final DateTime picked = await showDatePicker(
        context: context,
        initialDate: selectedStartDate,
        firstDate: DateTime(2020),
        lastDate: DateTime(2022));
    if (picked != null && picked != selectedStartDate)
      setState(() {
        selectedStartDate = picked;
      });
  }

  _selectEndDate(BuildContext context) async {
    final DateTime picked = await showDatePicker(
        context: context,
        initialDate: selectedEndDate,
        firstDate: DateTime(2020),
        lastDate: DateTime(2022));
    if (picked != null && picked != selectedEndDate)
      setState(() {
        selectedEndDate = picked;
      });
  }

  _submitEvent() async {
    if (_formKey.currentState.validate()) {
      if (backgroundImage != null) {

        List rules = List();
        for(TextEditingController ruleController in ruleControllers){
          rules.add(ruleController.text);
        }
        EventModel event = EventModel();
        event.uid = this.uid;
        event.name = this.name;
        event.status = this.statusValue;
        event.type = this.typeValue;
        event.endDate = this.selectedEndDate;
        event.startDate = this.selectedStartDate;
        event.rules = rules;
        event.description = this.description;
        event.totalRules = 3;
        List<BeaconData> beacons = List();
        BeaconData beaconData = BeaconData(int.parse(this.major),int.parse(this.minor));
        beacons.add(beaconData);
        event.beaconDataList = beacons;
        event.observedDays=int.parse(this.observedDays);
        await DatabaseManager().addEvent(event,backgroundImage);
        Navigator.pop(context);
      } else {
        //Toast
        Fluttertoast.showToast(
            msg: "Please upload a background image",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.BOTTOM,
            timeInSecForIos: 1,
            backgroundColor: Colors.black,
            textColor: Colors.white,
            fontSize: 14.0);
      }
    }
  }

  onImageSelectedFromCameraOrGallery(file) {
    setState(() {
      backgroundImage = file;
    });
  }
  
  _addRule(String rule){
    setState(() => ++ruleCount);
    ruleControllers.length = ruleCount+1;
    ruleControllers[ruleCount] = TextEditingController();
    if(rule != null){
      ruleControllers[ruleCount].text = rule;
    }
    ruleChildren = List.from(ruleChildren)
      ..add(
          TextFormField(
            decoration: InputDecoration(
              labelText: 'enter a rule for the event',
            ),
            controller: ruleControllers[ruleCount],
            validator: (value) {
              if (value == null || value.length == 0) {
                return 'Please enter some text';
              }
              return null;
            },
          )
      );
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("Add Event"),
        ),
        body: ListView(children: <Widget>[
          Form(
              key: _formKey,
              child: Column(
                children: <Widget>[
                  TextFormField(
                    onChanged: (text) {
                      this.uid = text;
                    },
                    textCapitalization: TextCapitalization.characters,
                    decoration: const InputDecoration(
                      hintMaxLines: 3,
                      hintText:
                          'First three letters for premise, next three for event name and 2 digit number for serial id',
                      labelText: 'Uid',
                    ),
                    onSaved: (String value) {
                      // This optional block of code can be used to run
                      // code when the user saves the form.
                    },
                    validator: (String value) {
                      return value == null || value.isEmpty
                          ? 'Do not use the @ char.'
                          : null;
                    },
                  ),
                  TextFormField(
                    onChanged: (text) {
                      this.name = text;
                    },
                    decoration: InputDecoration(labelText: 'Name'),
                    validator: (value) {
                      if (value.isEmpty) {
                        return 'Please enter a valid event name';
                      }
                    },
                  ),
                  TextFormField(
                    onChanged: (text) {
                      this.description = text;
                    },
                    decoration: InputDecoration(labelText: 'Description'),
                    validator: (value) {
                      if (value.isEmpty) {
                        return 'Please enter a valid description';
                      }
                    },
                  ),
                  TextFormField(
                    onChanged: (text) {
                      this.observedDays = text;
                    },
                    decoration: InputDecoration(labelText: 'Observed days'),
                    validator: (value) {
                      if (value.isEmpty) {
                        return 'Please enter a valid number';
                      }
                    },
                  ),
                  TextFormField(
                    onChanged: (text) {
                      this.major = text;
                    },
                    decoration: InputDecoration(labelText: 'Major'),
                    validator: (value) {
                      if (value.isEmpty) {
                        return 'Please enter a valid major';
                      }
                    },
                  ),
                  TextFormField(
                    onChanged: (text) {
                      this.minor = text;
                    },
                    decoration: InputDecoration(labelText: 'Minor'),
                    validator: (value) {
                      if (value.isEmpty) {
                        return 'Please enter a valid minor';
                      }
                    },
                  ),
                  TextFormField(
                    decoration: InputDecoration(
                        labelText: 'Rules',
                        suffixIcon: IconButton(
                          icon: Icon(Icons.add_circle),
                          onPressed: (){
                            _addRule(null);
                          },
                        )
                    ),
                    controller: ruleControllers[0],
                    validator: (value) {
                      if (value == null || value.length == 0) {
                        return 'Please enter some text';
                      }
                      return null;
                    },
                  ),
                  ListView(
                    physics: NeverScrollableScrollPhysics(),
                    shrinkWrap: true,
                    children: ruleChildren,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: <Widget>[
                      Text("Status"),
                      DropdownButton<String>(
                        value: statusValue,
                        icon: Icon(Icons.arrow_downward),
                        iconSize: 24,
                        elevation: 16,
                        style: TextStyle(color: Colors.deepPurple),
                        underline: Container(
                          height: 2,
                          color: Colors.deepPurpleAccent,
                        ),
                        onChanged: (String newValue) {
                          setState(() {
                            statusValue = newValue;
                          });
                        },
                        items: <String>['active', 'inactive']
                            .map<DropdownMenuItem<String>>((String value) {
                          return DropdownMenuItem<String>(
                            value: value,
                            child: Text(value),
                          );
                        }).toList(),
                      )
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: <Widget>[
                      Text("Event type"),
                      DropdownButton<String>(
                        value: typeValue,
                        icon: Icon(Icons.arrow_downward),
                        iconSize: 24,
                        elevation: 16,
                        style: TextStyle(color: Colors.deepPurple),
                        underline: Container(
                          height: 2,
                          color: Colors.deepPurpleAccent,
                        ),
                        onChanged: (String newValue) {
                          setState(() {
                            typeValue = newValue;
                          });
                        },
                        items: <String>['Online', 'Location', 'Offline']
                            .map<DropdownMenuItem<String>>((String value) {
                          return DropdownMenuItem<String>(
                            value: value,
                            child: Text(value),
                          );
                        }).toList(),
                      )
                    ],
                  ),
                  Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: <Widget>[
                        GestureDetector(
                            onTap: () => _selectStartDate(context),
                            child: Text("Start date")),
                        Text("$selectedStartDate"),
                      ]),
                  Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: <Widget>[
                        GestureDetector(
                            onTap: () => _selectEndDate(context),
                            child: Text("End date")),
                        Text("$selectedEndDate"),
                      ]),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: <Widget>[
                      BackgroundPicture(backgroundImage),
                      GalleryImpl(onImageSelectedFromCameraOrGallery)
                    ],
                  ),
                  Container(
                      padding: EdgeInsets.only(
                          top: SizeConfig.blockSizeVertical * 10),
                      child: GestureDetector(
                          onTap: _submitEvent,
                          child: Text(
                            "save",
                            style: TextStyle(fontSize: 20),
                          ))),
                ],
              ))
        ]));
  }
}

