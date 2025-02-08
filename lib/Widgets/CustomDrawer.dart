import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../SavedScreen.dart';
import '../UsersScreen.dart';
import '../login.dart';
class CustomDrawer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final screenHeight=MediaQuery.of(context).size.height;
    final screenWidth=MediaQuery.of(context).size.width;
    return Drawer(
      child: Column(
        children: [
          // Header Section
          DrawerHeader(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [Colors.blue, Colors.lightBlueAccent],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
            child: Center(
              child: Image.asset(
                'assets/images/logo.png',
                width: screenHeight*0.4,
                height: screenWidth*0.8,
              ),
            ),
          ),
          // Message ListTile
          ListTile(
            leading: Icon(Icons.message, color: Colors.blue),
            title: Text('Message'),
            onTap: () {
              Navigator.of(context).pop();
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => UsersScreen()),
              );
            },
          ),
          // Saved ListTile
          ListTile(
            leading: Icon(Icons.history, color: Colors.orange),
            title: Text('Saved'),
            onTap: () {
              Navigator.of(context).pop();
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => SavedScreen()),
              );
            },
          ),
          // Logout ListTile
          ListTile(
            leading: Icon(Icons.logout, color: Colors.red),
            title: Text('Logout'),
            onTap: () async {
              await FirebaseAuth.instance.signOut();
              Navigator.of(context).pushReplacement(
                MaterialPageRoute(builder: (context) => MyLogin()),
              );
            },
          ),
        ],
      ),
    );
  }
}
