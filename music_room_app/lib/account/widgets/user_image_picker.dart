import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:music_room_app/services/constants.dart';
import '../../home/models/user.dart';

class UserImagePicker extends StatelessWidget {
  UserImagePicker(
      {required this.avatarUrl, this.user, required this.imagePickFn});

  final Future<void> Function(File pickedImage, UserApp? user) imagePickFn;
  final String avatarUrl;
  final UserApp? user;

  void _pickImage() async {
    final ImagePicker imagePicker = new ImagePicker();
    final pickedImageFile = await imagePicker.pickImage(
        source: ImageSource.gallery, imageQuality: 50, maxWidth: 150);
    if (pickedImageFile != null) {
       imagePickFn(File(pickedImageFile.path), user);
      };
    }

  @override
  Widget build(BuildContext context) {
    ImageProvider avatarImage;
    try {
      avatarImage = NetworkImage(avatarUrl);
    } on NetworkImageLoadException {
      avatarImage = NetworkImage(defaultAvatarUrl);
    }
    return Column(
      children: <Widget>[
        CircleAvatar(
          radius: 45,
          backgroundColor: Colors.grey,
          backgroundImage: avatarImage,
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
