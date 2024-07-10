import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:notifybear/screens/auth_screens/login_page.dart';

class AuthWrapper extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          // Show a loading spinner
          return CircularProgressIndicator();
        }
        if (snapshot.hasData) {
          // User is logged in, navigate to HomePage
          return Scaffold();
        } else {
          // User is not logged in, navigate to LoginPage
          return LoginPage();
        }
      },
    );
  }
}
