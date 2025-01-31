import 'package:device_preview/device_preview.dart';
import 'package:flutter/material.dart';
import 'package:pakhomes/Controller/Provider/AddPropertyProvider.dart';
import 'package:pakhomes/HomeScreen.dart';
import 'package:provider/provider.dart';
import 'Controller/Provider/FormProvider.dart';
import 'Controller/Provider/ImageHandleProvider.dart';
import 'Controller/Provider/LocationProvider.dart';
import 'Controller/Provider/UserProvider.dart';
import 'firebase_options.dart';
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
        ChangeNotifierProvider<LocationProvider>(create: (context)=>LocationProvider()),
        ChangeNotifierProvider<FormProvider>(create: (context)=>FormProvider()),
        ChangeNotifierProvider<ImageHandlerProvider>(create: (context)=>ImageHandlerProvider()),
        ChangeNotifierProvider<AddProperty>(create: (context)=>AddProperty()),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        initialRoute: 'Home',
        home: HomeScreen(),
      ),
    );
  }
}

