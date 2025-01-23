import 'package:device_preview/device_preview.dart';
import 'package:flutter/material.dart';
import 'package:pakhomes/HomeScreen.dart';
import 'package:pakhomes/property_page.dart';
import 'package:pakhomes/uploadproperty.dart';
import 'package:provider/provider.dart';
import 'Controller/Provider/UserProvider.dart';
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
  runApp(DevicePreview(
      enabled: true,
      builder:(context) =>MyApp()));
}



class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<UserProvider>(create: (context)=>UserProvider()),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        initialRoute: 'Home',
        home: HomeScreen(),
      ),
    );
  }
}

