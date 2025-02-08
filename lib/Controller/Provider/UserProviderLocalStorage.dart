import 'dart:io';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:image_picker/image_picker.dart';
import 'package:pakhomes/Commons/CommonFunctions.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../Model/UserModel.dart';


class UserProviderLocalData with ChangeNotifier {
  UserModel? _user;
  File? _selectedImage;
  bool isLoading = false;
  int _selectedCategoryIndex = 0;
  int get selectedCategoryIndex => _selectedCategoryIndex;

  UserModel? get user => _user;
  File? get selectedImage => _selectedImage;

  void setSelectedCategory(int index) {
    _selectedCategoryIndex = index;
    notifyListeners();
  }
  /// Fetch user details from Firestore using email
  Future<void> fetchUserDetails(String email) async {
    try {
      var snapshot = await FirebaseFirestore.instance
          .collection('users')
          .where('email', isEqualTo: email)
          .limit(1)
          .get();

      if (snapshot.docs.isNotEmpty) {
        _user = UserModel.fromSnapshot(snapshot.docs.first);
        await saveUserToLocal(_user!); // Save user data locally
        notifyListeners();
      }
    } catch (e) {
      print("Error fetching user: $e");
    }
  }

  /// Save user data to SharedPreferences
  Future<void> saveUserToLocal(UserModel user) async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setString('user_data', user.toJson());
  }

  /// Load user data from SharedPreferences
  Future<void> loadUserFromLocal() async {
    final prefs = await SharedPreferences.getInstance();
    String? userData = prefs.getString('user_data');

    if (userData != null) {
      _user = UserModel.fromJson(userData);
      notifyListeners();
    }
  }

  /// Pick Image from Camera or Gallery
  Future<void> pickImage(ImageSource source) async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: source);

    if (pickedFile != null) {
      _selectedImage = File(pickedFile.path);
      notifyListeners();
    }
  }

  /// Upload Image to Firebase Storage
  Future<String?> uploadImageToStorage(String email) async {
    String storageBaseURL = CommonFunctions.storageBaseURL;
    if (_selectedImage == null) return null;

    try {
      final ref = FirebaseStorage.instance
          .refFromURL(storageBaseURL)
          .child('user_images')
          .child('$email.jpg');

      await ref.putFile(_selectedImage!);
      return await ref.getDownloadURL();
    } catch (e) {
      print("Error uploading image: $e");
      return null;
    }
  }
  void updateUserUpdatingProfile(){
    isLoading = true;
    notifyListeners();

  }
  /// Update user details in Firestore
  Future<void> updateUserDetails(UserModel updatedUser, BuildContext context) async {
    if (updatedUser.email == null) return;
    try {
      var querySnapshot = await FirebaseFirestore.instance
          .collection('users')
          .where('email', isEqualTo: updatedUser.email)
          .get();

      if (querySnapshot.docs.isNotEmpty) {
        await querySnapshot.docs.first.reference.update(updatedUser.toMap());
      }
      _user = updatedUser;
      _selectedImage = null;
      await saveUserToLocal(updatedUser);
      notifyListeners();
      CommonFunctions.showSuccessToast(context: context, message: 'Profile Updated Sucessfully');
    } catch (e) {
      print("Error updating user: $e");
      CommonFunctions.showErrorToast(context: context, message: 'Failed to Update Profile');
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

}
