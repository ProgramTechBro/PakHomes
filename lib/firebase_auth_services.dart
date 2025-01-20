import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';

class FirebaseAuthServices{
  FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<User?> signupWithEmailAndPassword(String fullName, String email, String password, String contact, String address) async{
    try{
      UserCredential credential = await _auth.createUserWithEmailAndPassword(email: email, password: password);
      User? user = credential.user;
      if (user != null) {
        // Set default values in Firestore
        await _firestore.collection('users').doc(user.uid).set({
          'full_name': fullName,
          'email': email,
          'contact': contact.isNotEmpty ? contact : '',
          'address': address.isNotEmpty ? address : '',
          // You typically shouldn't store the password in plaintext
        });
      }
    } catch (e) {
      print('Error during registration: $e');
    }
  }

  Future<User?> signinWithEmailAndPassword(String email, String password) async{
    try{
      UserCredential credential = await _auth.signInWithEmailAndPassword(email: email, password: password);
      return credential.user;
    } catch (e) {
      print("Some Error Occured");
    }
    return null;
  }
}