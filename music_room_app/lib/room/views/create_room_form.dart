import 'package:flutter/material.dart';
import 'package:music_room_app/widgets/custom_text_field.dart';

import '../../home/models/playlist.dart';

class CreateRoomForm extends StatefulWidget {
  @override
  State<CreateRoomForm> createState() => _CreateRoomFormState();
}

class _CreateRoomFormState extends State<CreateRoomForm> {
  Playlist? playlist;

  @override
  Widget build(context) {
    return SingleChildScrollView(
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10),
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(10.0),
            topRight: Radius.circular(10.0),
          ),
        ),
        alignment: Alignment.center,
        child: Container(
          padding: const EdgeInsets.all(15),
          child: Column(
            children: <Widget>[
              Align(
                alignment: Alignment.centerLeft,
                child: IconButton(
                    onPressed: () => Navigator.pop(context),
                    icon: Icon(Icons.arrow_back)),
              ),
              CustomTextField(title: "Event name :"),
              SizedBox(
                height: MediaQuery.of(context).size.height * 0.03,
              ),
              ListTile(
                title: playlist == null
                    ? Text('Choose a playlist')
                    : Text(playlist!.name),
                trailing:
                    playlist == null ? const Icon(Icons.chevron_right) : null,
                leading: playlist == null
                    ? Padding(padding: EdgeInsets.only(left: 55.0))
                    : playlist!.returnImage(),
                onTap: () => {},
              ),
              SizedBox(
                height: MediaQuery.of(context).size.height * 0.05,
              ),
              ElevatedButton(
                  style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all(
                      const Color(0XFF072BB8),
                    ),
                    shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                      RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                  ),
                  onPressed: () {
                    setState(() {});
                  },
                  child: Text(
                    "Create !",
                  )),
            ],
          ),
        ),
      ),
    );
  }
}
