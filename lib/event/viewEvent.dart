
import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:else_admin_two/event/BackgroundPicture.dart';
import 'package:else_admin_two/event/events_model.dart';
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
  TextEditingController _uidController = TextEditingController();
  TextEditingController _shopNumberController = TextEditingController();
  TextEditingController _contactController = TextEditingController();
  File image;
  String _status;
  List<String> statusList;
  String _startDate, _endDate;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _nameController.text = widget.event.name;
    _uidController.text = widget.event.uid;
    _descriptionController.text = widget.event.description;
    _status = widget.event.status;
    _startDate = widget.event.startDate.toString();
    _endDate = widget.event.endDate.toString();
    statusList = List();
    statusList.add("active");
    statusList.add("inactive");
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
                    decoration: const InputDecoration(labelText: 'Uid'),
                    controller: _uidController,
                    validator: (value) {
                      if (value == null || value.length == 0) {
                        return 'uid is mandatory';
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
                      children: <Widget>[BackgroundPicture(image),
                  GalleryImpl(onImageSelectedFromCameraOrGallery)])
                ],
              ),
            )
          ],
        ));
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
