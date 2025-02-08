import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:motion_toast/motion_toast.dart';
import 'package:provider/provider.dart';

import '../Controller/Provider/ImageHandleProvider.dart';

class CommonFunctions {
  static List<String> cities = ['Karachi', 'Lahore', 'Islamabad', 'Rawalpindi', 'Faisalabad'];
  static List<String> propertyType = ['Rent', 'Sale'];
  static List<String> projectType = ['Commercial', 'Plot', 'Home', 'Flat'];
  static  List<String> countries = ['Square Feet', 'Square Yards', 'Square Meters', 'Marla','Kanal'];
  static String storageBaseURL = 'gs://pakhomes-6a9f4.firebasestorage.app';
  static commonSpace(double? height, double? width) {
    return SizedBox(height: height ?? 0, width: width ?? 0,);
  }
  static showSuccessToast(
      {required BuildContext context, required String message}) {
    return MotionToast.success(
      title: const Text('Success'),
      description: Text(message),
      position: MotionToastPosition.top,
    ).show(context);
  }

  static showErrorToast(
      {required BuildContext context, required String message}) {
    return MotionToast.error(
      title: const Text('Error'),
      description: Text(message),
      position: MotionToastPosition.top,
    ).show(context);
  }

  static showWarningToast(
      {required BuildContext context, required String message}) {
    return MotionToast.warning(
      title: const Text('Opps!'),
      description: Text(message),
      position: MotionToastPosition.top,
    ).show(context);
  }
  static void showPicker(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return SafeArea(
          child: Wrap(
            children: <Widget>[
              ListTile(
                leading: Icon(Icons.photo_library),
                title: Text('Photo Library'),
                onTap: () async {
                  Navigator.pop(context);
                  await context.read<ImageHandlerProvider>().pickImages();
                },
              ),
              ListTile(
                leading: Icon(Icons.camera_alt),
                title: Text('Camera'),
                onTap: () async {
                  Navigator.pop(context);
                  await context.read<ImageHandlerProvider>().pickImageFromCamera();
                },
              ),
            ],
          ),
        );
      },
    );
  }
}