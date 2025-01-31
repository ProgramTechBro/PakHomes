import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class ImageHandlerProvider with ChangeNotifier {
  final List<File> _imageFiles = [];

  List<File> get imageFiles => _imageFiles;
  Future<void> pickImages() async {
    final pickedFiles = await ImagePicker().pickMultiImage();
    if (pickedFiles != null) {
      _imageFiles.addAll(pickedFiles.map((e) => File(e.path)));
      notifyListeners(); // Notify listeners to update the UI
    }
  }
  Future<void> pickImageFromCamera() async {
    final pickedFile = await ImagePicker().getImage(source: ImageSource.camera);
    if (pickedFile != null) {
      _imageFiles.add(File(pickedFile.path));
      notifyListeners(); // Notify listeners to update the UI
    }
  }
  void removeImage(int index) {
    _imageFiles.removeAt(index);
    notifyListeners(); // Notify listeners to update the UI
  }
  void clearImageFiles() {
    imageFiles.clear();
    notifyListeners();
  }
}
