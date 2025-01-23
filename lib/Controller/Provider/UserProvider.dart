import 'package:flutter/cupertino.dart';
class UserProvider with ChangeNotifier{
 bool isLogging=false;
 bool isRegistering=false;
 void updateLoggingStatus(){
   isLogging=!isLogging;
   notifyListeners();
 }
 void updateRegisteringStatus(){
   isRegistering=!isRegistering;
   notifyListeners();
 }
}