import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';
import 'package:geocoding/geocoding.dart';
import '../Controller/Provider/LocationProvider.dart';

class MapScreen extends StatefulWidget {
  @override
  _MapScreenState createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  late GoogleMapController _mapController;
  LatLng? _selectedLocation;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<LocationProvider>(context, listen: false)
          .fetchCurrentLocation(context)
          .then((position) {
        if (position != null) {
          setState(() {
            _selectedLocation = LatLng(position.latitude, position.longitude);
          });
        }
      });
    });
  }

  /// Fetch Address from Coordinates
  Future<String> _getAddressFromLatLng(LatLng position) async {
    try {
      List<Placemark> placemarks = await placemarkFromCoordinates(
        position.latitude,
        position.longitude,
      );

      if (placemarks.isNotEmpty) {
        Placemark place = placemarks.first;
        return '${place.street}, ${place.subLocality}, ${place.locality}, ${place.administrativeArea}, ${place.country}';
      }
    } catch (e) {
      print("Error fetching address: $e");
    }
    return "Unknown Location";
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Select Location")),
      body: Consumer<LocationProvider>(
        builder: (context, locationProvider, child) {
          return GoogleMap(
            initialCameraPosition: CameraPosition(
              target: _selectedLocation ?? LatLng(33.6844, 73.0479), // Default to Islamabad
              zoom: 14,
            ),
            onMapCreated: (GoogleMapController controller) {
              _mapController = controller;
            },
            markers: _selectedLocation != null
                ? {
              Marker(
                markerId: MarkerId("selected-location"),
                position: _selectedLocation!,
                draggable: true,
                icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueRed),
                onDragEnd: (newPosition) {
                  setState(() {
                    _selectedLocation = newPosition;
                  });
                },
              ),
            }
                : {},
            onTap: (LatLng tappedPosition) {
              setState(() {
                _selectedLocation = tappedPosition;
              });
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () async {
          if (_selectedLocation != null) {
            String address = await _getAddressFromLatLng(_selectedLocation!);
            Provider.of<LocationProvider>(context, listen: false)
                .setManualLocation(address);
            Navigator.pop(context);
          }
        },
        label: Text("Confirm Location"),
        icon: Icon(Icons.check),
      ),
    );
  }
}
