import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';

class LocationProvider extends ChangeNotifier {
  TextEditingController addressController = TextEditingController();
  bool isFetching = false;

  /// Fetch current location and return position
  Future<Position?> fetchCurrentLocation(BuildContext context) async {
    try {
      isFetching = true;
      notifyListeners();

      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          throw Exception("Location permission denied");
        }
      }

      Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );

      List<Placemark> placemarks = await placemarkFromCoordinates(
        position.latitude,
        position.longitude,
      );

      Placemark place = placemarks[0];
      String formattedAddress =
          '${place.street}, ${place.subLocality}, ${place.locality}, ${place.administrativeArea}, ${place.country}';

      addressController.text = formattedAddress;
      notifyListeners();

      return position;
    } catch (e) {
      print("Error fetching location: $e");
      return null;
    } finally {
      isFetching = false;
      notifyListeners();
    }
  }

  /// Set manually selected location
  void setManualLocation(String address) {
    addressController.text = address;
    notifyListeners();
  }
}
