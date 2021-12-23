import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:music_room_app/home/models/user.dart';
import 'package:music_room_app/services/auth.dart';
import 'package:music_room_app/services/database.dart';
import 'package:provider/provider.dart';

// import 'widgets/AccountDrawer.dart';

class AccountForm extends StatefulWidget {
  final String? email;
  final String? name;

  const AccountForm({Key? key, this.name, this.email}) : super(key: key);

  @override
  _AccountFormState createState() => _AccountFormState();
}

class _AccountFormState extends State<AccountForm> {
  final nameController = TextEditingController();
  final passwordController = TextEditingController();
  String tempName = '';
  String tempPassword = '';

  _updateName(String value) => tempName = value;

  _updatePassword(String value) => tempPassword = value;

  _updateUserDB(UserApp? user, User? currentUser, Database db) async {
    if (user != null && tempName != '') {
      user.name = tempName;
      await db.updateUser(user);
    }
    if (currentUser != null && tempPassword != '') {
      await currentUser.updatePassword(tempPassword);
    }
    if (currentUser != null && tempName != '') {
      await currentUser.updateDisplayName(tempName);
    }
    if (tempName != '' || tempPassword != 'null') {
      Navigator.of(context).pop();
    }
  }

  _editModal(context, UserApp? user, User? currentUser, Database db) {
    showDialog(
      context: context,
      barrierColor: Colors.black12,
      builder: (BuildContext context) {
        return Dialog(
          insetPadding:
              const EdgeInsets.symmetric(horizontal: 15, vertical: 100),
          backgroundColor: Colors.transparent,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.0)),
          child: Card(
            color: Colors.white,
            elevation: 5,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Row(
                  children: [
                    Flexible(
                      child: Center(
                        child: Container(
                          padding: const EdgeInsets.symmetric(vertical: 10),
                          child: const Text(
                            "Edit my profil",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: Color(0XFF434343),
                              fontWeight: FontWeight.w600,
                              fontSize: 20,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                ListTile(
                  title: TextFormField(
                    controller: nameController,
                    autofocus: false,
                    obscureText: false,
                    decoration: InputDecoration(
                      icon: const Icon(Icons.account_circle_rounded,
                          color: Colors.black),
                      border: const UnderlineInputBorder(),
                      hintText: 'Name',
                      hintStyle: Theme.of(context).textTheme.subtitle1,
                    ),
                    onChanged: _updateName,
                    textInputAction: TextInputAction.next,
                  ),
                ),
                ListTile(
                  title: TextFormField(
                    controller: passwordController,
                    autofocus: false,
                    obscureText: false,
                    decoration: InputDecoration(
                      icon: const Icon(Icons.password_rounded,
                          color: Colors.black),
                      border: const UnderlineInputBorder(),
                      hintText: 'Password',
                      hintStyle: Theme.of(context).textTheme.subtitle1,
                    ),
                    onChanged: _updatePassword,
                  ),
                ),
                SizedBox(
                  height: MediaQuery.of(context).size.height * 0.05,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    ElevatedButton(
                      style: ButtonStyle(
                        backgroundColor: MaterialStateProperty.all(
                          const Color(0XFF04BE96),
                        ),
                      ),
                      onPressed: () {
                        _updateUserDB(user, currentUser, db);
                      },
                      child: Text(
                        "Confirm".toUpperCase(),
                        style: const TextStyle(fontWeight: FontWeight.w700),
                      ),
                    ),
                    SizedBox(
                      width: MediaQuery.of(context).size.width * 0.03,
                    ),
                    ElevatedButton(
                      style: ButtonStyle(
                        backgroundColor: MaterialStateProperty.all(
                          const Color(0XFFB90808),
                        ),
                      ),
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                      child: Text(
                        "Cancel".toUpperCase(),
                        style: const TextStyle(fontWeight: FontWeight.w700),
                      ),
                    ),
                  ],
                )
              ],
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final db = Provider.of<Database>(context, listen: false);
    final auth = Provider.of<AuthBase>(context, listen: false);
    return StreamBuilder<UserApp>(
      stream: db.userStream(),
      builder: (context, snapshot) {
        final user = snapshot.data;
        return Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.02,
            ),
            Center(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: CircleAvatar(
                  radius: 45,
                  child: ClipOval(
                    child: Image.asset("images/pp.jpg"),
                  ),
                ),
              ),
            ),
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.02,
            ),
            Container(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                user == null ? '' : user.name,
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w600,
                  color: Color(0XFF434343),
                ),
              ),
            ),
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.02,
            ),
            Container(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                user == null ? 'No User Connected' : user.email,
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w600,
                  color: Color(0XFF434343),
                ),
              ),
            ),
            ElevatedButton(
              style: ButtonStyle(
                backgroundColor: MaterialStateProperty.all(
                  const Color(0XFF434343),
                ),
              ),
              onPressed: () {
                _editModal(context, user, auth.currentUser, db);
              },
              child: Text(
                "Edit my profil".toUpperCase(),
                style: const TextStyle(fontWeight: FontWeight.w700),
              ),
            )
          ],
        );
      },
    );
  }
}

// Photo de profil
// Nom / mail
// Editer le profil
