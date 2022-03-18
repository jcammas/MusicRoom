import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import '../../home/models/user.dart';

class AvatarTile extends StatelessWidget {
  AvatarTile({this.user, required this.imagePickFn});

  final Future<void> Function(File pickedImage, UserApp? user) imagePickFn;
  final UserApp? user;

  void _pickImage() async {
    final ImagePicker imagePicker = new ImagePicker();
    final pickedImageFile = await imagePicker.pickImage(
        source: ImageSource.gallery, imageQuality: 70, maxWidth: 200);
    if (pickedImageFile != null) {
      imagePickFn(File(pickedImageFile.path), user);
    }
    ;
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 30),
      child: InkWell(
        onTap: _pickImage,
        customBorder: CircleBorder(),
        child: CircleAvatar(
          radius: 45,
          backgroundColor: Colors.grey,
          backgroundImage: NetworkImage(defaultAvatarUrl),
          foregroundImage: user == null ? null : user!.getAvatar(),
        ),
      ),
    );
  }
}
