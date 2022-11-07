import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class UserImagePicker extends StatefulWidget {

  final void Function(File pickedImage) imagePickFn;

  const UserImagePicker({Key? key, required this.imagePickFn}) : super(key: key);

  @override
  State<UserImagePicker> createState() => _UserImagePickerState();
}

class _UserImagePickerState extends State<UserImagePicker> {

  XFile? _pickedImage;

  void pickImage() async {
   final pickedImageFile = await ImagePicker().pickImage(source: ImageSource.camera, imageQuality: 50, maxWidth: 150);
   setState(() {
     _pickedImage = pickedImageFile;
   });
  widget.imagePickFn(File(pickedImageFile!.path));
  }


  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        CircleAvatar(
          radius: 40,
          backgroundColor: Colors.grey,
          backgroundImage: _pickedImage != null ? FileImage(File(_pickedImage!.path)) : null,
        ),
        TextButton.icon(
          style: ButtonStyle(
              foregroundColor: MaterialStateProperty.all(Theme.of(context).primaryColor)
          ),
          onPressed: pickImage,
          label: Text('Add image'),
          icon: Icon(Icons.image),
        )
      ],
    );
  }
}
