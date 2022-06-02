// WelcomeScreen.dart file
import 'dart:convert';

import 'package:flutter/material.dart';
import 'auth.dart';
import 'login_page.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

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

  @override
  void initState() {
    readData();
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
              TextFormField(
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
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Column(
                    children: [
                      ElevatedButton(
                        onPressed: () {
                          // print(name);
                          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                            behavior: SnackBarBehavior.floating,
                            content: Text(nameController.text),
                            action: SnackBarAction(
                              label: 'CLOSE',
                              onPressed: ScaffoldMessenger.of(context)
                                  .hideCurrentSnackBar,
                            ),
                          ));
                          insertData(nameController.text);
                        },
                        child: const Text("Set Username"),
                      ),
                    ],
                  ),
                ],
              ),
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
              )
            ],
          ),
        )));
  }

// class WelcomeScreen extends StatelessWidget {

//   }

  void insertData(String username) {
    try {
      ref.child(name!).set({"username": username});
      // ref.child("name").set({"username": "dajsdh"});
      readData();
      print(username);
    } catch (e) {
      print(e);
    }
  }

  void readData() {
    try {
      ref.child(name!).once().then((DatabaseEvent event) {
        var json = jsonEncode(event.snapshot.value);
        print(json);
        Map<String, dynamic> mapData = jsonDecode(json);

        setState(() {
          username = mapData['username'];
        });
      });
    } catch (e) {
      print(e);
    }
  }
}
