import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'landing.dart';
import 'login.dart';

class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Scaffold(
            body: Center(
              child: CircularProgressIndicator(),
            ),
          );
        } else {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            if (snapshot.hasData && snapshot.data != null) {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => LandingPage()),
              );
            } else {
              print('User is not Signed');
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => MyLogin()),
              );
            }
          });

          // Return an empty container to prevent build errors
          return const Scaffold(
            body: Center(
              child: CircularProgressIndicator(),
            ),
          );
        }
      },
    );
  }
}
