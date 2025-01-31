import 'dart:developer';
import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:pakhomes/Controller/Provider/ImageHandleProvider.dart';
import 'package:provider/provider.dart';
import 'package:uuid/uuid.dart';
import '../../Commons/CommonFunctions.dart';
import '../../Model/Property.dart';
import '../Provider/AddPropertyProvider.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;

class AddPropertyServices{
  FirebaseAuth auth=FirebaseAuth.instance;
  FirebaseStorage storage=FirebaseStorage.instance;
  FirebaseFirestore firestore=FirebaseFirestore.instance;


  Future<void> uploadImagesToFirebaseStorage({
    required List<File> images,
    required BuildContext context,
  }) async {
    if (images.isEmpty) {
      print('No images to upload');
      return;
    }

    Uuid uuid = Uuid();
    String propertyID = 'PAD${uuid.v4().substring(0, 5).toUpperCase()}';

    // Firebase Storage base URL
    String storageBaseURL = 'gs://pakhomes-6a9f4.firebasestorage.app';

    for (int i = 0; i < images.length; i++) {
      String imageName = '$propertyID-${i + 1}.jpg';

      // Create storage reference using refFromURL
      firebase_storage.Reference storageReference =
      firebase_storage.FirebaseStorage.instance
          .refFromURL(storageBaseURL)
          .child('Property_Images')
          .child(propertyID)
          .child(imageName);

      print('Uploading to: ${storageReference.fullPath}');

      try {
        if (!images[i].existsSync()) {
          print('File does not exist: ${images[i].path}');
          continue;
        }

        // Upload image
        firebase_storage.UploadTask uploadTask =
        storageReference.putFile(images[i]);

        // Wait for upload to complete and get the download URL
        await uploadTask;
        String imageURL = await storageReference.getDownloadURL();

        print('Image uploaded: $imageURL');

        Provider.of<AddProperty>(context, listen: false)
            .updateProductImagesURL(imagesURLs: imageURL);

        Provider.of<AddProperty>(context, listen: false)
            .updatePropertyId(propertyID);
      } catch (e) {
        print('Error uploading image $imageName: $e');
      }
    }
  }

  // Future<void> uploadImagesToFirebaseStorage({
  //   required List<File> images,  // Accept list of files
  //   required BuildContext context,
  // }) async {
  //   String sellerUID = auth.currentUser!.email!;
  //   Uuid uuid = const Uuid();
  //   String propertyID = 'PAD${uuid.v4().substring(0, 5).toUpperCase()}';
  //   Reference propertyFolderRef = storage
  //       .ref()
  //       .child('Property_Images')
  //       .child(propertyID); // Property ID folder
  //   for (int i = 0; i < images.length; i++) {
  //     String imageName = '$propertyID-${i + 1}.jpg';  // Different name for each image
  //     Reference ref = propertyFolderRef.child(imageName); // Create reference for each image under the same property folder
  //
  //     try {
  //       await ref.putFile(images[i]);
  //       String imageURL = await ref.getDownloadURL();
  //       Provider.of<AddProperty>(context, listen: false).updateProductImagesURL(
  //         imagesURLs: imageURL,
  //       );
  //       Provider.of<AddProperty>(context, listen: false).updatePropertyId(propertyID);
  //     } catch (e) {
  //       print('Error uploading image $imageName: $e');
  //     }
  //   }
  // }
  Future<void> addProduct({
    required BuildContext context,
    required Property propertyModel,
    required String propertyId, // Added propertyId as a parameter
  }) async {
    try {
      await firestore
          .collection('properties')
          .doc(propertyId) // Use propertyId as document ID
          .set(propertyModel.toMap()); // Set property details as document fields

      log('Data Added');
      CommonFunctions.showSuccessToast(
          context: context, message: 'Property Added Successfully');
      Provider.of<AddProperty>(context,listen: false).emptyImageUrls();
      Provider.of<AddProperty>(context,listen: false).emptyPropertyId();
      Provider.of<ImageHandlerProvider>(context,listen: false).clearImageFiles();

    } catch (e) {
      log('Error adding property: $e');
      CommonFunctions.showErrorToast(context: context, message: e.toString());
    }
  }

}