// login_page.dart file
import 'package:flutter/material.dart';
import 'package:auth_buttons/auth_buttons.dart';
import 'welcome_screen.dart';
import 'auth.dart';

class LoginPage extends StatefulWidget {
  @override
  LoginPageState createState() => LoginPageState();
}

class LoginPageState extends State<LoginPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: Colors.white,
        child: Center(
          child: Column(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              const Image(
                  image: AssetImage("assets/logo.png"),
                  height: 150,
                  width: 150),
              const SizedBox(height: 50),
              GoogleAuthButton(
                  onPressed: () {
                    signInWithGoogle().whenComplete(() {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (context) {
                            return WelcomeScreen();
                          },
                        ),
                      );
                    });
                  },
                  darkMode: false),
            ],
          ),
        ),
      ),
    );
  }
}
