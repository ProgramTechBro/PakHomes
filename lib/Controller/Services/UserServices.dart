import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
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
    try {
      await auth.signInWithEmailAndPassword(email: email, password: password)
          .then((userCredential) async {
        final user = userCredential.user;
        if (user != null) {
          CommonFunctions.showSuccessToast(context: context, message: 'Login Successfully');
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => LandingPage()),
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
    final provider=Provider.of<UserProvider>(context,listen: false);
    try{
      User? user = await signupWithEmailAndPassword(email, password);
      if(user!=null)
      {
        await FirebaseFirestore.instance.collection('users').doc(user.uid).set({
          'username': userName,
          'email': email,
          'full_name': fullName,
          'contact_number': contactNo,
          'address': address,
          'created_at': Timestamp.now(),
        });
      }
      provider.updateRegisteringStatus();
      CommonFunctions.showSuccessToast(context: context, message: 'Register Successfully');

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