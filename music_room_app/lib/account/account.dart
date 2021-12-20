import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:music_room_app/services/auth.dart';
import 'package:music_room_app/widgets/show_alert_dialog.dart';

// import 'widgets/AccountDrawer.dart';

class Account extends StatefulWidget {
  final String? email;
  final String? name;
  const Account({Key? key, this.name, this.email}) : super(key: key);

  static const String routeName = '/account';

  @override
  _AccountState createState() => _AccountState();

  Future<void> _confirmSignOut(BuildContext context) async {
    final auth = Provider.of<AuthBase>(context, listen: false);

    final didRequestSignOut = await showAlertDialog(
      context,
      title: 'Logout',
      content: 'Are you sure that you want to logout?',
      cancelActionText: 'Cancel',
      defaultActionText: 'Logout',
    );
    if (didRequestSignOut == true) {
      auth.signOut();
    }
  }
}

class _AccountState extends State<Account> {
  final nameController = TextEditingController();
  final passwordController = TextEditingController();

  _editModal(context) {
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
                        Navigator.pop(context);
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
                        Navigator.pop(context);
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
    return Scaffold(
        appBar: AppBar(
          backgroundColor: const Color(0XFF072BB8),
          title: const Text(
            "Account",
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.w600,
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text(
                'Logout',
                style: TextStyle(
                  fontSize: 18.0,
                  color: Colors.white,
                ),
              ),
              onPressed: () => widget._confirmSignOut(context),
            ),
          ],
        ),
        backgroundColor: Colors.grey[200],
        //drawer: const AccountDrawer(),
        body: SingleChildScrollView(
          child: Column(
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
                  "matoulet.cammas@gmail.com",
                  style: TextStyle(
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
                  _editModal(context);
                },
                child: Text(
                  "Edit my profil".toUpperCase(),
                  style: const TextStyle(fontWeight: FontWeight.w700),
                ),
              )
            ],
          ),
        ));
  }
}

// Photo de profil
// Nom / mail
// Editer le profil
