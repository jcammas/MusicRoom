import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import '../../home/models/user.dart';

class UserImagePicker extends StatefulWidget {
  UserImagePicker(
      {required this.originalImageUrl, this.user,
      required this.imagePickFn});

  final void Function(File pickedImage, UserApp? user) imagePickFn;
  final String originalImageUrl;
  final UserApp? user;

  @override
  _UserImagePickerState createState() =>
      _UserImagePickerState(NetworkImage(originalImageUrl));
}

class _UserImagePickerState extends State<UserImagePicker> {
  File? _newImage;
  final NetworkImage _originalImage;
  bool isLocal = false;

  _UserImagePickerState(this._originalImage);

  void _pickImage() async {
    final ImagePicker imagePicker = new ImagePicker();
    final pickedImageFile = await imagePicker.pickImage(
        source: ImageSource.gallery, imageQuality: 50, maxWidth: 150);
    if (pickedImageFile != null) {
      setState(() {
        _newImage = File(pickedImageFile.path);
        isLocal = true;
      });
      widget.imagePickFn(
        _newImage!,
        widget.user
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        CircleAvatar(
          radius: 45,
          backgroundColor: Colors.grey,
          backgroundImage: isLocal ? null : _originalImage,
          foregroundImage: isLocal ? FileImage(_newImage!) : null,
        ),
        IconButton(
          color: Theme.of(context).primaryColor,
          onPressed: _pickImage,
          icon: Icon(Icons.image),
        ),
      ],
    );
  }
}
