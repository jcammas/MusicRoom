import 'package:flutter/material.dart';
import '../../constant_colors.dart';
import '../../home/models/room.dart';
import '../../home/models/user.dart';

class GuestTile extends StatelessWidget {
  const GuestTile({Key? key, required this.guest, required this.onTap})
      : super(key: key);
  final UserApp guest;
  final VoidCallback onTap;
  static const double imageSize = 55.0;

  Widget _returnImage(UserApp guest) {
    try {
      return Image.network(guest.avatarUrl,
          width: imageSize, height: imageSize);
    } catch (e) {
      return const Padding(padding: EdgeInsets.only(left: imageSize));
    }
  }

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(guest.name),
      trailing: const Icon(Icons.chevron_right),
      leading: _returnImage(guest),
      onTap: onTap,
    );
  }
}

class RoomTile extends StatelessWidget {
  const RoomTile({Key? key, required this.room, this.onTap, this.icon})
      : super(key: key);
  final Room room;
  final VoidCallback? onTap;
  final Icon? icon;
  static const double imageSize = 55.0;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Padding(
          padding: EdgeInsets.only(left: 30),
          child: Text(room.name,
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16))),
      trailing: const Icon(
        Icons.check_circle,
        color: primaryColor,
      ),
      leading: room.sourcePlaylist.returnImage(),
      onTap: onTap,
    );
  }
}
