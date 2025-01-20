import 'package:flutter/material.dart';
import 'package:pakhomes/property_page.dart';
import 'package:pakhomes/uploadproperty.dart';
import 'firebase_options.dart';
import 'login.dart';
import 'register.dart';
import 'landing.dart';
import 'editprofile.dart';
import 'filterform.dart';
import 'package:firebase_core/firebase_core.dart';



void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(MyApp());
}



class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      initialRoute: 'login',
      routes: {
        'login': (context) => MyLogin(),
        'register': (context) => MyRegister(),
        'landing': (context) => LandingPage(),
        'editprofile': (context) => EditProfile(),
        'filterform': (context) => FilterForm(),
        'uploadproperty': (context) => UploadProperty(),
        'property_page' : (context) => PropertyPage(image: '', propertyId: '',),
      },
      home: const PropertyPage(image: 'assets/sample_image.jpg', propertyId: '',),
    );
  }
}

