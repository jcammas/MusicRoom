import 'package:flutter/material.dart';
import '../../home/models/user.dart';

class GuestTile extends StatelessWidget {
  const GuestTile({Key? key, required this.guest, required this.onTap})
      : super(key: key);
  final UserApp guest;
  final VoidCallback onTap;
  static const double imageSize = 55.0;

  Widget _returnImage(UserApp guest) {
    try {
      return Image.network(guest.avatarUrl, width: imageSize,
          height: imageSize);
      } catch(e) {
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
