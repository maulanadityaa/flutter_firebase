// WelcomeScreen.dart file
import 'dart:convert';

import 'package:flutter/material.dart';
import 'auth.dart';
import 'login_page.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:flutter_switch/flutter_switch.dart';

class WelcomeScreen extends StatefulWidget {
  WelcomeScreen({Key? key}) : super(key: key);

  @override
  State<WelcomeScreen> createState() => _WelcomeScreen();
}

class _WelcomeScreen extends State<WelcomeScreen> {
  TextEditingController nameController = TextEditingController();
  FirebaseDatabase database = FirebaseDatabase.instance;
  DatabaseReference ref = FirebaseDatabase.instance.ref();
  var username;
  var status;
  bool stats = false;

  @override
  void initState() {
    readData();
    // snackBar(context);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Flutter Example'),
        ),
        drawer: name != null
            ? Drawer(
                child: ListView(
                  padding: EdgeInsets.zero,
                  children: <Widget>[
                    DrawerHeader(
                      decoration: const BoxDecoration(
                        color: Colors.amberAccent,
                      ),
                      child: Column(
                        children: <Widget>[
                          Padding(
                            padding: EdgeInsets.zero,
                            child: CircleAvatar(
                              backgroundImage: NetworkImage(
                                imageUrl!,
                              ),
                              radius: 40,
                              backgroundColor: Colors.transparent,
                            ),
                          ),
                          const SizedBox(height: 10),
                          Text(
                            name!,
                            style: const TextStyle(
                                fontSize: 20,
                                color: Colors.black,
                                fontWeight: FontWeight.bold),
                          ),
                          const SizedBox(height: 5),
                          Text(
                            email!,
                            style: const TextStyle(
                                fontSize: 16,
                                color: Colors.black,
                                fontWeight: FontWeight.normal),
                          ),
                        ],
                      ),
                    ),
                    ListTile(
                        leading: const Icon(
                          Icons.exit_to_app,
                          color: Colors.red,
                        ),
                        title: const Text(
                          "Sign Out",
                          style: TextStyle(
                            fontSize: 18,
                            color: Colors.red,
                          ),
                        ),
                        onTap: () {
                          signOutGoogle();
                          Navigator.of(context).pushAndRemoveUntil(
                              MaterialPageRoute(builder: (context) {
                            return LoginPage();
                          }), ModalRoute.withName('/'));
                        }),
                  ],
                ),
              )
            : null,
        body: SingleChildScrollView(
            child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Card(
                  elevation: 4.0,
                  child: Column(
                    children: [
                      ListTile(
                        title: Text(email.toString()),
                        subtitle: Text(username ?? ''),
                        trailing: FaIcon(FontAwesomeIcons.solidUser),
                      ),
                      ButtonBar(
                        children: [
                          TextButton(
                            child: const Text('CONTACT AGENT'),
                            onPressed: () {/* ... */},
                          )
                        ],
                      )
                    ],
                  )),
              Card(
                clipBehavior: Clip.antiAlias,
                elevation: 4.0,
                child: Column(
                  children: [
                    Image.network(imageUrl!),
                    ListTile(
                      title: const Text('Avatar user'),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(15.0),
                child: TextFormField(
                  controller: nameController,
                  decoration: InputDecoration(
                    hintText: "Masukkan Username",
                    labelText: "username",
                    icon: const Icon(Icons.people),
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(5.0)),
                  ),
                  validator: (String? value) {
                    if (value != null && value.isEmpty) {
                      return 'Username tidak boleh kosong';
                    }
                    return null;
                  },
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // if (status == 'on') ...[snackBar(context)],
                  Column(
                    children: [
                      // snackBar(context),
                      FlutterSwitch(
                        showOnOff: true,
                        value: stats,
                        onToggle: (value) {
                          updateStatus(value);
                          snackBar(context, value);
                        },
                      ),
                      ElevatedButton(
                        onPressed: () {
                          // print(name);
                          // ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                          //   behavior: SnackBarBehavior.floating,
                          //   content: Text(nameController.text),
                          //   action: SnackBarAction(
                          //     label: 'CLOSE',
                          //     onPressed: ScaffoldMessenger.of(context)
                          //         .hideCurrentSnackBar,
                          //   ),
                          // ));
                          insertData(nameController.text);
                          // snackBar(context);
                        },
                        child: const Text("Set Username"),
                      ),
                    ],
                  ),
                ],
              ),
            ],
          ),
        )));
  }

  void insertData(String username) {
    try {
      ref.child(name!).update({"username": username});
      // ref.child("name").set({"username": "dajsdh"});
      readData();
      print(username);
    } catch (e) {
      print(e);
    }
  }

  void updateStatus(status) {
    // String stats;
    // if (status = true) {
    //   stats = 'on';
    // } else if(status = false) {
    //   stats = 'off';
    // }
    try {
      ref.child(name!).update({"status": status});
      // ref.child("name").set({"username": "dajsdh"});
      // readData();
      print(status);
      setState(() {
        stats = status;
      });
    } catch (e) {
      print(e);
    }
    readData();
  }

  void readData() {
    try {
      ref.child(name!).onValue.listen((DatabaseEvent event) {
        var json = jsonEncode(event.snapshot.value);
        // print(json);
        Map<String, dynamic> mapData = jsonDecode(json);

        print(mapData['status']);
        if (this.mounted) {
          setState(() {
            username = mapData['username'];
            stats = mapData['status'];
            // if (status == 'on') {
            //   stats = true;
            // } else {
            //   stats = false;
            // }
          });
        }
      });
      // snackBar(context);
    } catch (e) {
      print(e);
    }
  }

  void snackBar(BuildContext context, bool toogle) {
    final scaffold = ScaffoldMessenger.of(context);
    String val = toogle.toString();
    if (val == 'true') {
      scaffold.showSnackBar(
        SnackBar(
          content: const Text('Status ON'),
          action: SnackBarAction(
            label: 'CLOSE',
            onPressed: scaffold.hideCurrentSnackBar,
            textColor: Colors.black,
          ),
          behavior: SnackBarBehavior.floating,
          duration: Duration(seconds: 2),
          backgroundColor: Colors.green,
        ),
      );
    } else {
      scaffold.showSnackBar(
        SnackBar(
          content: const Text('Status OFF'),
          action: SnackBarAction(
            label: 'CLOSE',
            onPressed: scaffold.hideCurrentSnackBar,
            textColor: Colors.black,
          ),
          behavior: SnackBarBehavior.floating,
          duration: Duration(seconds: 2),
          backgroundColor: Colors.red,
        ),
      );
    }
  }
}
