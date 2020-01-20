import 'dart:io';

import 'package:else_admin_two/event/BackgroundPicture.dart';
import 'package:else_admin_two/event/SubmissionScreen.dart';
import 'package:else_admin_two/event/beacon_model.dart';
import 'package:else_admin_two/event/events_model.dart';
import 'package:else_admin_two/firebaseUtil/database_manager.dart';
import 'package:else_admin_two/utils/Contants.dart';
import 'package:else_admin_two/utils/pick_gallery_impl.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ViewSingleEvent extends StatefulWidget {
  final EventModel event;
  ViewSingleEvent(this.event);
  @override
  State<StatefulWidget> createState() => ViewSingleEventState();
}

class ViewSingleEventState extends State<ViewSingleEvent> {
  final _formKey = GlobalKey<FormState>();
  TextEditingController _descriptionController = TextEditingController();
  TextEditingController _nameController = TextEditingController();
  TextEditingController _observedDaysController = TextEditingController();
  TextEditingController _majorController = TextEditingController();
  TextEditingController _minorController = TextEditingController();
  File image;
  List<String> statusList;
  List<String> typeList;
  String _startDate, _endDate, _type, _status;
  bool isOnline = false;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _nameController.text = widget.event.name;
    _descriptionController.text = widget.event.description;
    _observedDaysController.text = widget.event.observedDays.toString();
    _status = widget.event.status;
    _startDate = widget.event.startDate.toString();
    _endDate = widget.event.endDate.toString();
    _majorController.text = widget.event.beaconDataList[0].major.toString();
    _minorController.text = widget.event.beaconDataList[0].minor.toString();
    _type = widget.event.type;
    statusList = List();
    statusList.add("active");
    statusList.add("inactive");
    typeList = List();
    typeList.add("Online");
    typeList.add("Offline");
    typeList.add("Location");

    if (widget.event.type.compareTo('Online') == 0) {
      isOnline = true;
    }
  }

  viewSubmissions() {
    DatabaseManager().getSubmissionForEvent(widget.event.uid);
    Navigator.push(context,
        MaterialPageRoute(builder: (BuildContext context) => SubmissionScreen(widget.event)));
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
        appBar: AppBar(
          leading: IconButton(
            icon: Icon(Icons.arrow_back, color: Colors.black),
            onPressed: () => Navigator.of(context).pop(),
          ),
          title: Text("Edit/View",
              style: TextStyle(
                color: Constants.titleBarTextColor,
                fontSize: 18,
              )),
          centerTitle: true,
        ),
        body: ListView(
          children: <Widget>[
            Visibility(
                visible: isOnline,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                  GestureDetector(
                      child: Text(
                        "View Submission",
                        style: TextStyle(fontSize: 18),
                      ),
                      onTap: viewSubmissions)
                ])),
            Form(
              key: _formKey,
              child: Column(
                children: <Widget>[
                  TextFormField(
                    decoration: const InputDecoration(labelText: 'Name'),
                    controller: _nameController,
                    validator: (value) {
                      if (value == null || value.length == 0) {
                        return 'Please enter Name';
                      }
                      return null;
                    },
                  ),
                  TextFormField(
                    maxLines: 6,
                    decoration: const InputDecoration(labelText: 'Description'),
                    controller: _descriptionController,
                    validator: (value) {
                      if (value == null || value.length == 0) {
                        return 'around 100 words';
                      }
                      return null;
                    },
                  ),
                  TextFormField(
                    decoration:
                        const InputDecoration(labelText: 'Observed days'),
                    controller: _observedDaysController,
                    validator: (value) {
                      if (value == null || value.length == 0) {
                        return 'important for location events';
                      }
                      return null;
                    },
                  ),
                  TextFormField(
                    decoration: const InputDecoration(labelText: 'Major'),
                    controller: _majorController,
                    validator: (value) {
                      if (value == null || value.length == 0) {
                        return 'important for location events';
                      }
                      return null;
                    },
                  ),
                  TextFormField(
                    decoration: const InputDecoration(labelText: 'Minor'),
                    controller: _minorController,
                    validator: (value) {
                      if (value == null || value.length == 0) {
                        return 'important for location events';
                      }
                      return null;
                    },
                  ),
                  Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: <Widget>[
                        Text('status'),
                        DropdownButton<String>(
                          value: _status,
                          icon: Icon(Icons.arrow_downward),
                          iconSize: 24,
                          elevation: 16,
                          style: TextStyle(color: Colors.black),
                          underline: Container(
                            height: 2,
                            color: Colors.black12,
                          ),
                          onChanged: (String newValue) {
                            setState(() {
                              _status = newValue;
                            });
                          },
                          items: statusList
                              .map<DropdownMenuItem<String>>((String value) {
                            return DropdownMenuItem<String>(
                              value: value,
                              child: Text(value),
                            );
                          }).toList(),
                        )
                      ]),
                  Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: <Widget>[
                        Text('type'),
                        DropdownButton<String>(
                          value: _type,
                          icon: Icon(Icons.arrow_downward),
                          iconSize: 24,
                          elevation: 16,
                          style: TextStyle(color: Colors.black),
                          underline: Container(
                            height: 2,
                            color: Colors.black12,
                          ),
                          onChanged: (String newValue) {
                            setState(() {
                              _type = newValue;
                            });
                          },
                          items: typeList
                              .map<DropdownMenuItem<String>>((String value) {
                            return DropdownMenuItem<String>(
                              value: value,
                              child: Text(value),
                            );
                          }).toList(),
                        )
                      ]),
                  Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: <Widget>[
                        Text('start date'),
                        GestureDetector(
                          child: Text(_startDate),
                          onTap: () => _selectStartDate(context),
                        ),
                      ]),
                  Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: <Widget>[
                        Text('end date'),
                        GestureDetector(
                          child: Text(_endDate),
                          onTap: () => _selectEndDate(context),
                        ),
                      ]),
                  Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: <Widget>[
                        BackgroundPicture(image),
                        GalleryImpl(onImageSelectedFromCameraOrGallery)
                      ]),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: <Widget>[
                      GestureDetector(
                        child: Text('delete'),
                        onTap: deleteEvent,
                      ),
                      GestureDetector(
                        child: Text('save'),
                        onTap: saveChanges,
                      )
                    ],
                  )
                ],
              ),
            )
          ],
        ));
  }

  deleteEvent() async {
    await DatabaseManager().deleteEvent(widget.event.uid);

    Navigator.pop(context);
  }

  saveChanges() async {
    EventModel model = widget.event;
    model.observedDays = int.parse(_observedDaysController.text);
    model.type = _type;
    model.endDate = DateTime.parse(_endDate);
    model.startDate = DateTime.parse(_startDate);
    model.description = _descriptionController.text;
    model.status = _status;
    model.name = _nameController.text;
    List<BeaconData> beacons = List();
    BeaconData beacon = BeaconData(
        int.parse(_majorController.text), int.parse(_minorController.text));
    beacons.add(beacon);
    model.beaconDataList = beacons;
    await DatabaseManager().saveEvent(model, image);
    Navigator.pop(context);
  }

  onImageSelectedFromCameraOrGallery(file) {
    setState(() {
      image = file;
    });
  }

  _selectEndDate(BuildContext context) async {
    final DateTime picked = await showDatePicker(
        context: context,
        initialDate: DateTime.parse(_endDate),
        firstDate: DateTime(2018),
        lastDate: DateTime(2022));
    if (picked != null && picked != DateTime.parse(_endDate))
      setState(() {
        _endDate = picked.toString();
      });
  }

  _selectStartDate(BuildContext context) async {
    final DateTime picked = await showDatePicker(
        context: context,
        initialDate: DateTime.parse(_startDate),
        firstDate: DateTime(2018),
        lastDate: DateTime(2022));
    if (picked != null && picked != DateTime.parse(_startDate))
      setState(() {
        _startDate = picked.toString();
      });
  }
}
