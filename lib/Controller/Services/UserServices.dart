import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:pakhomes/Controller/Provider/UserProviderLocalStorage.dart';
import 'package:pakhomes/landing.dart';
import 'package:provider/provider.dart';
import '../../Commons/CommonFunctions.dart';
import '../../register.dart';
import '../Provider/UserProvider.dart';

class UserServices{
  FirebaseAuth auth=FirebaseAuth.instance;
  //Login Function

  Future<void> signIn({required BuildContext context, required String email, required String password}) async {
    final provider=Provider.of<UserProvider>(context,listen: false);
    final userProvider = Provider.of<UserProviderLocalData>(context, listen: false);
    try {
      await auth.signInWithEmailAndPassword(email: email, password: password)
          .then((userCredential) async {
        final user = userCredential.user;
        if (user != null) {
          await userProvider.fetchUserDetails(email);
          CommonFunctions.showSuccessToast(context: context, message: 'Login Successfully');
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => HomeScreen()),
          );
          provider.updateLoggingStatus();
        } else {
          CommonFunctions.showErrorToast(context: context, message: 'Login Failed');
          provider.updateLoggingStatus();
        }
      }).catchError((e) {
        print("Error: $e");
        String errorMessage;
        if (e is FirebaseAuthException) {
          if (e.code == 'invalid-credential') {
            errorMessage = 'Invalid Credential';
          } else if (e.code == 'wrong-password') {
            errorMessage = 'Wrong password';
          } else {
            print('123');
            errorMessage = 'Error occurred';
          }
        } else {
          errorMessage = 'Error occurred';
        }
        CommonFunctions.showErrorToast(context: context, message: errorMessage);
        provider.updateLoggingStatus();
      });
    } catch (e) {
      CommonFunctions.showErrorToast(context: context, message: 'Error occurred');
      provider.updateLoggingStatus();
    }
  }

  //RegisterFunction
  Future<void> createUser({required BuildContext context,required String userName,required String fullName,required String email,required String password,required String contactNo,required String address})async
  {
    final userProvider = Provider.of<UserProviderLocalData>(context, listen: false);
    final provider=Provider.of<UserProvider>(context,listen: false);
    try{
      User? user = await signupWithEmailAndPassword(email, password);
      if(user!=null)
      {
        await FirebaseFirestore.instance.collection('users').doc(user.uid).set({
          'fullName': fullName,
          'username': userName,
          'email': email,
          'contact': contactNo,
          'address': address,
          'imageUrl':'NULL',
        });
      }
      await userProvider.fetchUserDetails(email);
      provider.updateRegisteringStatus();
      CommonFunctions.showSuccessToast(context: context, message: 'Register Successfully');
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => HomeScreen()),
      );

    }catch(e)
    {
      provider.updateRegisteringStatus();
      CommonFunctions.showErrorToast(context: context, message: 'Email Already used');
    }
  }
  Future<User?> signupWithEmailAndPassword(String email, String password) async {
    try {
      UserCredential userCredential = await auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      return userCredential.user;
    } catch (e) {
      print("Registration error: $e");
      return null;
    }
  }
}