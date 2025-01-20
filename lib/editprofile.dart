import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;

class EditProfile extends StatefulWidget {
  const EditProfile({super.key});

  @override
  State<EditProfile> createState() => _EditProfileState();
}
class _EditProfileState extends State<EditProfile> {
  bool isObscurePassword = true;
  File? _image;
  String? _profileImageUrl;

  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _contactController = TextEditingController();
  final _addressController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _loadUserData();
    _fetchUserData();  // Load user data when the page loads
  }

  Future<void> _loadUserData() async {
    User? user = _auth.currentUser;
    if (user != null) {
      DocumentSnapshot userData = await _firestore.collection('users').doc(user.uid).get();
      if (userData.exists) {
        setState(() {
          _nameController.text = userData['full_name'] ?? '';
          _emailController.text = userData['email'] ?? '';
          _contactController.text = userData['contact'] ?? '';
          _addressController.text = userData['address'] ?? '';
          _profileImageUrl = userData['profile_image'] ?? '';
        });
      }
    }
  }
  Future<void> _pickImage() async {
    final pickedFile = await ImagePicker().pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _image = File(pickedFile.path);
      });
    }
  }
  Future<void> _saveChanges() async {
    User? user = _auth.currentUser;

    if (user != null) {
      try {
        String imageUrl = '';

        // Check if an image is selected, then upload it to Firebase Storage
        if (_image != null) {
          // Use the specific storage bucket path
          firebase_storage.Reference storageReference = firebase_storage.FirebaseStorage.instance
              .refFromURL('gs://pakhomes-6a9f4.firebasestorage.app')
              .child('user_profile_pictures')
              .child('${user.uid}.jpg');  // Store image with user UID as the name

          firebase_storage.UploadTask uploadTask = storageReference.putFile(_image!);

          // Await the upload task and get the download URL for the image
          await uploadTask.whenComplete(() async {
            imageUrl = await storageReference.getDownloadURL();
          });
        }
        // Update Firestore with the user data and image URL (if uploaded)
        await _firestore.collection('users').doc(user.uid).update({
          'full_name': _nameController.text,
          'email': _emailController.text,
          'contact': _contactController.text,
          'address': _addressController.text,
          if (imageUrl.isNotEmpty) 'profile_image': imageUrl, // Save image URL if available
        });

        // Optionally, update email or password in Firebase Auth if needed
        if (user.email != _emailController.text) {
          await user.updateEmail(_emailController.text);
        }
        if (_passwordController.text.isNotEmpty) {
          await user.updatePassword(_passwordController.text);
        }

        ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Profile updated successfully')));

      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Error updating profile: $e')));
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('No user is currently logged in.')));
    }
  }
  Future<void> _fetchUserData() async {
    User? user = _auth.currentUser;

    if (user != null) {
      try {
        // Attempt to fetch the user document from Firestore
        DocumentSnapshot<Map<String, dynamic>> userDoc = await _firestore
            .collection('users')
            .doc(user.uid)
            .get();

        // Check if the document exists
        if (userDoc.exists) {
          // Populate the text fields with data from Firestore
          Map<String, dynamic> data = userDoc.data()!;

          _nameController.text = data['full_name'] ?? '';
          _emailController.text = data['email'] ?? '';
          _contactController.text = data['contact'] ?? '';
          _addressController.text = data['address'] ?? '';

          // Set the profile image if it exists
          if (data['profile_image'] != null && data['profile_image'].isNotEmpty) {
            setState(() {
              _imageUrl = data['profile_image'];
            });
          }
        } else {
          // Document does not exist, create a new document with initial values
          await _firestore.collection('users').doc(user.uid).set({
            'full_name': '',
            'email': user.email ?? '',
            'contact': '',
            'address': '',
            'profile_image': ''
          });
        }
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Error fetching user data: $e')));
      }
    }
  }
  Future<void> _uploadImageToStorage(File imageFile) async {
    User? user = _auth.currentUser;
    if (user != null) {
      try {
        // Define storage path and upload
        firebase_storage.Reference storageReference = firebase_storage
            .FirebaseStorage.instance
            .ref()
            .child('user_profile_picture/${user.uid}');
        firebase_storage.UploadTask uploadTask = storageReference.putFile(imageFile);

        // Wait for the upload to complete and get the download URL
        await uploadTask.whenComplete(() async {
          String downloadUrl = await storageReference.getDownloadURL();
          setState(() {
            _imageUrl = downloadUrl;  // Update the image URL to save in Firestore
          });
        });
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Error uploading image: $e')));
      }
    }
  }

  Future<void> _saveUserProfile() async {
    User? user = _auth.currentUser;
    if (user != null) {
      try {
        // Save the updated data to Firestore
        await _firestore.collection('users').doc(user.uid).update({
          'full_name': _nameController.text,
          'email': _emailController.text,
          'contact': _contactController.text,
          'address': _addressController.text,
          'profile_image': _imageUrl  // Make sure _imageUrl is updated with the storage link
        });
        ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Profile updated successfully')));
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Error updating profile: $e')));
      }
    }
  }

  String? _imageUrl;
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xFF007BFF),
        title: Text('Profile'),
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: Container(
        padding: EdgeInsets.only(left: 15, top: 20, right: 15),
        child: GestureDetector(
          onTap: () {
            FocusScope.of(context).unfocus();
          },
          child: ListView(
            children: [
              Center(
                child: Stack(
                  children: [
                    Container(
                      width: 130,
                      height: 130,
                      decoration: BoxDecoration(
                        border: Border.all(width: 4, color: Colors.white),
                        boxShadow: [
                          BoxShadow(
                            spreadRadius: 2,
                            blurRadius: 10,
                            color: Colors.black.withOpacity(0.1),
                          )
                        ],
                        shape: BoxShape.circle,
                        image: DecorationImage(
                          fit: BoxFit.cover,
                          image: _image == null
                              ? (_profileImageUrl != null && _profileImageUrl!.isNotEmpty
                              ? NetworkImage(_profileImageUrl!) as ImageProvider
                              : AssetImage('assets/default_profile.png'))
                              : FileImage(_image!) as ImageProvider,
                        ),
                      ),
                    ),
                    Positioned(
                      bottom: 0,
                      right: 0,
                      child: GestureDetector(
                        onTap: _pickImage,
                        child: Container(
                          height: 40,
                          width: 40,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            border: Border.all(width: 4, color: Colors.white),
                            color: Colors.blue,
                          ),
                          child: Icon(Icons.edit, color: Colors.white),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 30),
              buildTextField("Full Name", _nameController, false),
              buildTextField("Email", _emailController, false),
              buildTextField("Password", _passwordController, true),
              buildTextField("Contact", _contactController, false),
              buildTextField("Address", _addressController, false),
              SizedBox(height: 30),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  OutlinedButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: Text(
                      "CANCEL",
                      style: TextStyle(fontSize: 15, letterSpacing: 2, color: Colors.black),
                    ),
                    style: OutlinedButton.styleFrom(
                      padding: EdgeInsets.symmetric(horizontal: 50),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                    ),
                  ),
                  ElevatedButton(
                    onPressed: _saveChanges,
                    child: Text(
                      "SAVE",
                      style: TextStyle(fontSize: 15, letterSpacing: 2, color: Colors.white),
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue,
                      padding: EdgeInsets.symmetric(horizontal: 50),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
  Widget buildTextField(String labelText, TextEditingController controller, bool isPasswordTextField) {
    return Padding(
      padding: EdgeInsets.only(bottom: 30),
      child: TextField(
        controller: controller,
        obscureText: isPasswordTextField ? isObscurePassword : false,
        decoration: InputDecoration(
          suffix: isPasswordTextField
              ? IconButton(
            icon: Icon(Icons.remove_red_eye, color: Colors.grey),
            onPressed: () {
              setState(() {
                isObscurePassword = !isObscurePassword;
              });
            },
          )
              : null,
          contentPadding: EdgeInsets.only(bottom: 5),
          labelText: labelText,
          floatingLabelBehavior: FloatingLabelBehavior.always,
          hintText: labelText,
          hintStyle: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: Colors.grey,
          ),
        ),
      ),
    );
  }
}