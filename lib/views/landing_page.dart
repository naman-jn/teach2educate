import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:teach2educate/views/chat_screen.dart';
import 'package:teach2educate/views/login_page.dart';

class LandingPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: FirebaseAuth.instance.authStateChanges().first,
        builder: (context, snapshot) {
          if (snapshot.hasData) {}
          return snapshot.hasData ? ChatScreen() : LoginPage();
        });
  }
}
