import 'dart:io';

import 'package:else_admin_two/utils/SizeConfig.dart';
import 'package:flutter/material.dart';

class BackgroundPicture extends StatelessWidget {
  final File image;
  BackgroundPicture(this.image);
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    if (image != null) {
      return Container(
          width: SizeConfig.blockSizeHorizontal * 40,
          height: SizeConfig.blockSizeVertical * 20,
          child: Image(
            fit: BoxFit.cover,
            image: FileImage(image),
          ));
    } else {
      return Text('pick an image from the gallery');
    }
  }
}