import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:else_admin_two/event/BackgroundPicture.dart';
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
  String uid, name, description;
  File backgroundImage;
  File image;
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
        await DatabaseManager()
            .uploadImageToStorage(this.uid, this.backgroundImage);
        EventModel event = EventModel(null);
        event.uid = this.uid;
        event.name = this.name;
        event.url = "url";
        event.status = this.statusValue;
        event.type = this.typeValue;
        event.endDate = this.selectedEndDate;
        event.observedDays = 0;
        event.startDate = this.selectedStartDate;
        event.rules = "asss";
        event.description = this.description;
        event.totalRules = 3;
        event.blurUrl = "asasas";

        DatabaseManager().addEvent(event);
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
      image = file;
    });
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
                      BackgroundPicture(image),
                      GalleryImpl(onImageSelectedFromCameraOrGallery)
                    ],
                  ),
                  Container(
                      padding: EdgeInsets.only(
                          top: SizeConfig.blockSizeVertical * 10),
                      child: GestureDetector(
                          onTap: _submitEvent,
                          child: Text(
                            "Create",
                            style: TextStyle(fontSize: 20),
                          ))),
                ],
              ))
        ]));
  }
}

