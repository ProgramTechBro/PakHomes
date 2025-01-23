import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:video_player/video_player.dart';
import 'package:location/location.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:path/path.dart' as path;
import 'package:firebase_auth/firebase_auth.dart';
//import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
class UploadProperty extends StatefulWidget {
  @override
  _UploadPropertyState createState() => _UploadPropertyState();
}

class _UploadPropertyState extends State<UploadProperty> {
  String? _selectedCity;
  String? _selectedProjectType;
  String? _selectedAreaType;
  String? _selectedPropertyFor; // Add this variable
  TextEditingController _descriptionController = TextEditingController();
  TextEditingController _projectTitleController = TextEditingController();
  TextEditingController _priceRangeController = TextEditingController();
  TextEditingController _locationController = TextEditingController();
  TextEditingController _minAreaController = TextEditingController();
  TextEditingController _maxAreaController = TextEditingController();
  List<File> _imageFiles = []; // List to hold selected image files
  List<File> _videoFiles = []; // List to hold selected video files
  List<VideoPlayerController> _videoControllers = []; // List to hold video player controllers
  final user = FirebaseAuth.instance.currentUser;
  final FirebaseStorage _firebaseStorage = FirebaseStorage.instance;
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<void> selectImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      // If a file was picked, save it to the list and print the path
      setState(() {
        _imageFiles.add(File(pickedFile.path));
      });
      print('Image selected: ${pickedFile.path}');
    } else {
      // If no file was picked, print a message
      print('No image selected');
    }
  }
  Future<void> selectVideo() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickVideo(source: ImageSource.gallery);
    if (pickedFile != null) {
      print('Picked file path: ${pickedFile.path}');
      setState(() {
        _videoFiles.add(File(pickedFile.path));
      });
      //print('Video selected: ${pickedFile.path}');
      print('Video files list updated: ${_videoFiles.map((file) => file.path).toList()}');
    } else {
      print('No video selected');
    }
  }
  Future<void> uploadProperty() async {
    try {
      final user = _firebaseAuth.currentUser;
      if (user == null) {
        print("User is not authenticated");
        return;
      }
      print("User ID: ${user.uid}");

      final propertyId = DateTime.now().millisecondsSinceEpoch.toString();
      print("Generated Property ID: $propertyId");

      // Check image files
      if (_imageFiles == null || _imageFiles.isEmpty) {
        print("No images selected for upload.");
        return;
      }

      // Upload images
      final imageUrls = [];
      for (var imageFile in _imageFiles) {
        if (!imageFile.existsSync()) {
          print("Image file does not exist: ${imageFile.path}");
          continue;
        }
        print("Uploading image: ${imageFile.path}");
        final fileName = imageFile.path.split('/').last;
        final storageRef = _firebaseStorage
            .ref()
            .child('properties/${user.uid}/$propertyId/images/$fileName');
        await storageRef.putFile(imageFile);
        final downloadUrl = await storageRef.getDownloadURL();
        print("Uploaded image URL: $downloadUrl");
        imageUrls.add(downloadUrl);
      }

      // Check video files
      if (_videoFiles == null || _videoFiles.isEmpty) {
        print("No videos selected for upload.");
        return;
      }
        // Upload videos
        final videoUrls = [];
        for (var videoFile in _videoFiles) {
          if (!videoFile.existsSync()) {
            print("Video file does not exist: ${videoFile.path}");
            continue;
          }
          print("Uploading video: ${videoFile.path}");
          final fileName = videoFile.path.split('/').last;
          final storageRef = _firebaseStorage
              .ref()
              .child('properties/${user.uid}/$propertyId/videos/$fileName');
          await storageRef.putFile(videoFile);
          final downloadUrl = await storageRef.getDownloadURL();
          print("Uploaded video URL: $downloadUrl");
          videoUrls.add(downloadUrl);
        }


      // Prepare Firestore data
      final propertyData = {
        'description': _descriptionController.text,
        'city': _selectedCity,
        'projectType': _selectedProjectType,
        'images': imageUrls,
        'videos': videoUrls,
        'propertyId': propertyId,
        'userId': user.uid,
        'timestamp': FieldValue.serverTimestamp(),
      };

      print("Saving property data to Firestore: $propertyData");

      // Save property data to Firestore
      await _firestore
          .collection('properties')
          .doc(user.uid)
          .collection('userProperties')
          .doc(propertyId)
          .set(propertyData);

      print("Property successfully uploaded!");
    } catch (e, stackTrace) {
      print("Error uploading property: $e");
      print("Stack trace: $stackTrace");
    }
  }


  @override
  void dispose() {
    for (var controller in _videoControllers) {
      controller.dispose();
    } // Dispose of all video controllers}
    super.dispose();}
  Future<void> _pickImages() async {
    final pickedFiles = await ImagePicker().pickMultiImage();
    if (pickedFiles != null) {
      setState(() {
        _imageFiles.addAll(pickedFiles.map((e) => File(e.path)));
      }
      );
    }
  }
  Future<void> _pickImageFromCamera() async {
    final pickedFile = await ImagePicker().getImage(source: ImageSource.camera);
    if (pickedFile != null) {
      setState(() {
        _imageFiles.add(File(pickedFile.path));
      }
      );
    }
  }
  Future<void> _pickVideos() async {
    final pickedFile = await ImagePicker().getVideo(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _videoFiles.add(File(pickedFile.path));
        var controller = VideoPlayerController.file(File(pickedFile.path))
          ..initialize().then((_) {
            setState(() {});
          }
          );
        _videoControllers.add(controller);
      }
      );
    }
  }
  Future<void> _pickVideoFromCamera() async {
    final pickedFile = await ImagePicker().getVideo(source: ImageSource.camera);
    if (pickedFile != null) {
      setState(() {
        _videoFiles.add(File(pickedFile.path));
        var controller = VideoPlayerController.file(File(pickedFile.path))
          ..initialize().then((_) {
            setState(() {});
          }
          );
        _videoControllers.add(controller);
      }
      );
    }
  }
  void _removeImage(int index) {
    setState(()
    {
      _imageFiles.removeAt(index);
    }
    );
  }
  void _removeVideo(int index) {
    setState(()
    {
      _videoFiles.removeAt(index);
      _videoControllers[index].dispose();
      _videoControllers.removeAt(index);
    }
    );
  }
  Widget _buildImagePreview(int index) {
    return Stack(
      children: [
        Image.file(
          _imageFiles[index],
          height: 150,
          width: 150,
          fit: BoxFit.cover,),
        Positioned(
          top: 0,
          right: 0,
          child: GestureDetector(
            onTap: () => _removeImage(index),
            child: Container(
              color: Colors.black54,
              child: Icon(Icons.close, color: Colors.white),
            ),
          ),
        ),
      ],
    );
  }
  Widget _buildVideoPreview(int index) {
    return Stack(
      children: [
        AspectRatio(
          aspectRatio: _videoControllers[index].value.aspectRatio,
          child: VideoPlayer(_videoControllers[index]),
        ),
        Positioned(
          top: 0,
          right: 0,
          child: GestureDetector(
            onTap: () => _removeVideo(index),
            child: Container(
              color: Colors.black54,
              child: Icon(Icons.close, color: Colors.white),
            ),
          ),
        ),
      ],
    );
  }
  Widget _buildUploadPreview() {
    return _imageFiles.isEmpty && _videoFiles.isEmpty
        ? Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(Icons.image, size: 50, color: Color(0xFF007BFF)),
        Text(
          'Upload Image/Videos',
          style: TextStyle(color: Color(0xFF007BFF)),
        ),
      ],
    )
        : ListView.builder(
      scrollDirection: Axis.horizontal,
      itemCount: _imageFiles.length + _videoFiles.length,
      itemBuilder: (context, index) {
        if (index < _imageFiles.length) {
          return _buildImagePreview(index);
        } else {
          int videoIndex = index - _imageFiles.length;
          return _buildVideoPreview(videoIndex);
        }
        },
    );
  }
  Future<void> _openMap() async {
    final LatLng? selectedLocation = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => MapPicker(),
      ),
    );
    if (selectedLocation != null) {
      _locationController.text = '${selectedLocation.latitude}, ${selectedLocation.longitude}';
      setState(() {}); // Ensure the UI reflects the updated location
    }
  }
  void _showPicker(BuildContext context) {
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
                  await _pickImages();
                  },
              ),
              ListTile(
                leading: Icon(Icons.camera_alt),
                title: Text('Camera'),
                onTap: () async
                {
                  Navigator.pop(context);
                  await _pickImageFromCamera();
                  },
              ),
              ListTile(
                leading: Icon(Icons.video_library),
                title: Text('Video Library'),
                onTap: () async {
                  Navigator.pop(context);
                  await _pickVideos();
                  },
              ),
              ListTile(
                leading: Icon(Icons.videocam),
                title: Text('Video Camera'),
                onTap: () async {
                  Navigator.pop(context);
                  await _pickVideoFromCamera();
                  },
              ),
            ],
          ),
        );
        },
    );
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xFF007BFF),
        title: Text('Upload Property'),
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () {
            Navigator.pop(context);
            },
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: <Widget>[
              GestureDetector(
                onTap: () {
                  _showPicker(context);
                  },
                child: Container(
                  height: 150,
                  color: Colors.blue[50],
                  child: Center(
                    child: _buildUploadPreview(),
                  ),
                ),
              ),
              SizedBox(height: 20),
              DropdownButtonFormField<String>(
                decoration: InputDecoration(
                  labelText: 'Property For',
                  prefixIcon: Icon(Icons.business, color: Colors.blue),),
                items: ['Rent', 'Sale'].map((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value),);
                }
                ).toList(),
                onChanged: (newValue) {
                  setState(()
                  {
                    _selectedPropertyFor = newValue;
                  }
                  );
                  },
                iconEnabledColor: Colors.blue,),
              SizedBox(height: 20),
              TextFormField(
                controller: _descriptionController,
                decoration: InputDecoration(
                  labelText: 'Description',
                ),
              ),
              DropdownButtonFormField<String>(
                decoration: InputDecoration(
                  labelText: 'City',
                  prefixIcon: Icon(Icons.location_city, color: Colors.blue),
                ),
                items: [
                  DropdownMenuItem(
                    value: 'Karachi',
                    child: Row(
                      children: [
                        Icon(Icons.location_on, color: Colors.blue),
                        SizedBox(width: 8),
                        Text('Karachi'),
                      ],
                    ),
                  ),
                  DropdownMenuItem(
                    value: 'Lahore',
                    child: Row(
                      children: [
                        Icon(Icons.location_on, color: Colors.blue),
                        SizedBox(width: 8),
                        Text('Lahore'),
                      ],
                    ),
                  ),
                  DropdownMenuItem(
                    value: 'Islamabad',
                    child: Row(
                      children: [
                        Icon(Icons.location_on, color: Colors.blue),
                        SizedBox(width: 8),
                        Text('Islamabad'),
                      ],
                    ),
                  ),
                  DropdownMenuItem(
                    value: 'Rawalpindi',
                    child: Row(
                      children: [
                        Icon(Icons.location_on, color: Colors.blue),
                        SizedBox(width: 8),
                        Text('Rawalpindi'),
                      ],
                    ),
                  ),
                  DropdownMenuItem(
                    value: 'Faisalabad',
                    child: Row(
                      children: [
                        Icon(Icons.location_on, color: Colors.blue),
                        SizedBox(width: 8),
                        Text('Faisalabad'),
                      ],
                    ),
                  ),
                ],
                onChanged: (newValue) {
                  setState(()
                  {
                    _selectedCity = newValue;
                  }
                  );
                  },
                iconEnabledColor: Colors.blue,
              ),
              TextFormField(
                controller: _projectTitleController,
                decoration: InputDecoration(
                  labelText: 'Project Title',
                  prefixIcon: Icon(Icons.title, color: Colors.blue),
                ),
              ),
              DropdownButtonFormField<String>(
                decoration: InputDecoration(
                  labelText: 'Project Type',
                  prefixIcon: Icon(Icons.category, color: Colors.blue),
                ),
                items: ['Commercial', 'Plots', 'Home/Flats'].map((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value),);
                }
                ).toList(),
                onChanged: (newValue) {
                  setState(() {
                    _selectedProjectType = newValue;
                  }
                  );
                  },
                iconEnabledColor: Colors.blue,),
              DropdownButtonFormField<String>(
                decoration: InputDecoration(
                  labelText: 'Area Type',
                  prefixIcon: Icon(Icons.layers, color: Colors.blue),),
                items: [
                  'Square Feet',
                  'Square Yards',
                  'Square Meters',
                  'Marla',
                  'Kanal'
                ].map((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value),);
                }
                ).toList(),
                onChanged: (newValue) {
                  setState(() {
                    _selectedAreaType = newValue;
                  }
                  );
                  },
                iconEnabledColor: Colors.blue,),
              TextFormField(
                controller: _minAreaController,
                decoration: InputDecoration(
                  labelText: 'Area Size',
                  prefixIcon: Icon(Icons.square_foot, color: Colors.blue),
                ),
                keyboardType: TextInputType.number,), // TextFormField(//   controller: _maxAreaController,//   decoration: InputDecoration(//     labelText: 'Area (Max)',//     prefixIcon: Icon(Icons.square_foot, color: Colors.blue),//   ),//   keyboardType: TextInputType.number,// ),
              TextFormField(
                controller: _priceRangeController,
                decoration: InputDecoration(
                  labelText: 'Price Range',
                  prefixIcon: Icon(Icons.attach_money, color: Colors.blue),
                ),
                keyboardType: TextInputType.number,),
              GestureDetector(
                onTap: _openMap,
                child: AbsorbPointer(
                  child: TextFormField(
                    controller: _locationController,
                    decoration: InputDecoration(
                      labelText: 'Choose Location',
                      prefixIcon: Icon(Icons.map, color: Colors.blue),
                    ),
                  ),
                ),
              ),
              SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  OutlinedButton(
                    onPressed: () {
                      setState(() {
                        _descriptionController.clear();
                        _selectedCity = null;
                        _selectedProjectType = null;
                        _selectedAreaType = null;
                        _selectedPropertyFor = null;
                        _projectTitleController.clear();
                        _priceRangeController.clear();
                        _locationController.clear();
                        _minAreaController.clear();
                        _maxAreaController.clear();
                        _imageFiles.clear(); // Clear selected image files
                        for (var controller in _videoControllers) {
                          controller.pause();
                        }// Pause all video controllers
                        _videoFiles.clear(); // Clear selected video files
                        _videoControllers.clear();
                      }
                      );
                      }, // Clear video controllers
                    child: Text('Cancel'),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      uploadProperty();
                      setState(() {
                        _descriptionController.clear();
                        _selectedCity = null;
                        _selectedProjectType = null;
                        _selectedAreaType = null;
                        _selectedPropertyFor = null;
                        _projectTitleController.clear();
                        _priceRangeController.clear();
                        _locationController.clear();
                        _minAreaController.clear();
                        _maxAreaController.clear();
                       _imageFiles.clear(); // Clear selected image files
                        for (var controller in _videoControllers) {
                          controller.pause();
                        }// Pause all video controllers
                        _videoFiles.clear(); // Clear selected video files
                        _videoControllers.clear();
                      });
                    },
                    child: Text('Upload', style: TextStyle(color: Colors.white)),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue,),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
getApplicationDocumentsDirectory() {
}
class MapPicker extends StatefulWidget {
  @override
  _MapPickerState createState() => _MapPickerState();
}
class _MapPickerState extends State<MapPicker> {
  LatLng? _initialPosition;
  LatLng? _selectedPosition;
  GoogleMapController? _locationController;
  Location _location = Location();
  @override
  void initState() {
    super.initState();
    _getUserLocation();
  }
  Future<void> _getUserLocation() async {
    // Check if location services are enabled
    bool serviceEnabled = await _location.serviceEnabled();
    if (!serviceEnabled) {
      serviceEnabled = await _location.requestService();
      if (!serviceEnabled) return;
    }
    // Check for location permission
    PermissionStatus permissionGranted = await _location.hasPermission();
    if (permissionGranted == PermissionStatus.denied) {
      permissionGranted = await _location.requestPermission();
      if (permissionGranted != PermissionStatus.granted) return;
    }
    // Get the current location
    final userLocation = await _location.getLocation();
    setState(() {
      _initialPosition = LatLng(userLocation.latitude!, userLocation.longitude!);
      _selectedPosition = _initialPosition;
    });
  }
  void _onMapTap(LatLng position) {
    setState(() {
      _selectedPosition = position;
    });
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Pick a Location"),
      ),
      body: _initialPosition == null
          ? Center(child: CircularProgressIndicator())
          : GoogleMap(
        initialCameraPosition: CameraPosition(
          target: _initialPosition!,
          zoom: 14,
        ),
        onMapCreated: (controller) => _locationController = controller,
        onTap: _onMapTap,
        markers: _selectedPosition != null
            ? {
          Marker(
            markerId: MarkerId('selected-position'),
            position: _selectedPosition!,
          ),
        }
            : {},
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          if (_selectedPosition != null) {
            Navigator.pop(context, _selectedPosition); // Return the selected position
          } else {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Please select a location')),
            );
          }
        },
        child: const Icon(Icons.check),
      ),
    );
  }
}
