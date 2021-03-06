import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class ImageSourceSheet extends StatelessWidget {

  final Function(File) onImageSelected;

  ImageSourceSheet({this.onImageSelected});

  @override
  Widget build(BuildContext context) {
    return BottomSheet(
      onClosing: (){},
      builder: (context) => Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          FlatButton(
            child: Text("Câmera"),
            onPressed: () async {
              File image = await ImagePicker.pickImage(source: ImageSource.camera);
              if(image != null) {
                onImageSelected(image);
              }
            },
          ),
          FlatButton(
            child: Text("Galeria"),
            onPressed: () async {
              File image = await ImagePicker.pickImage(source: ImageSource.gallery);
              if(image != null) {
                onImageSelected(image);
              }
            },
          )
        ],
      ),
    );
  }
}
