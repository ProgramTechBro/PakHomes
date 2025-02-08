import 'dart:convert';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../Model/Property.dart';

class PropertyProvider extends ChangeNotifier {
  List<Property> _properties = [];
  bool isLoading = true;
  bool isLoadingSavedProperties = true;
  Map<String, List<Property>> savedProperties = {};
  Map<String,List<String>> savedStatus = {}; // Stores saved properties per user
  Map<String, bool> savingStatus = {};
  final FirebaseAuth auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  List<Property> get properties => _properties;
  PropertyProvider() {
    loadSavedProperties();
  }


  /// 🔴 STREAM FUNCTION: Fetch Real-Time Updates from Firestore
  Stream<List<Property>> streamProperties() {
    return FirebaseFirestore.instance
        .collection('properties')
        .snapshots()
        .map((snapshot) {
      return snapshot.docs.map((doc) => Property.fromSnapshot(doc)).toList();
    });
  }

  /// 📥 Fetch Properties Initially and Save to SharedPreferences
  Future<void> fetchProperties() async {
    try {
      isLoading = true;
      notifyListeners();

      QuerySnapshot snapshot = await FirebaseFirestore.instance
          .collection('properties')
          .get();

      List<Property> propertyList = snapshot.docs.map((doc) {
        return Property.fromSnapshot(doc);
      }).toList();

      _properties = propertyList;
      SharedPreferences prefs = await SharedPreferences.getInstance();
      List<String> propertyJsonList =
      _properties.map((property) => json.encode(property.toMap())).toList();
      prefs.setStringList('properties', propertyJsonList);

      isLoading = false;
      notifyListeners();
    } catch (e) {
      print("Error fetching properties: $e");
      isLoading = false;
      notifyListeners();
    }
  }

  /// 📥 Load Properties from SharedPreferences if Available
  Future<void> loadPropertiesFromPrefs() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String>? propertyJsonList = prefs.getStringList('properties');

    if (propertyJsonList != null) {
      _properties = propertyJsonList
          .map((jsonStr) =>
          Property.fromMap(json.decode(jsonStr) as Map<String, dynamic>))
          .toList();
      isLoading = false;
      notifyListeners();
    } else {
      fetchProperties();
    }
  }
 ///Main
  // Future<void> loadSavedProperties() async {
  //   final SharedPreferences prefs = await SharedPreferences.getInstance();
  //   String? savedPropertiesData = prefs.getString('savedProperties');
  //
  //   if (savedPropertiesData != null && savedPropertiesData.isNotEmpty) {
  //     try {
  //       // Ensure it's a valid JSON object
  //       final dynamic decodedData = jsonDecode(savedPropertiesData);
  //
  //       if (decodedData is Map<String, dynamic>) {
  //         savedProperties = decodedData.map<String, List<Property>>(
  //               (key, value) => MapEntry(
  //             key,
  //             (value as List<dynamic>).map<Property>(
  //                   (item) => Property.fromMap(item as Map<String, dynamic>),
  //             ).toList(),
  //           ),
  //         );
  //       } else {
  //         print("Error: Decoded data is not a Map<String, dynamic>");
  //         savedProperties = {};
  //       }
  //     } catch (e) {
  //       print("Error parsing saved properties: $e");
  //       savedProperties = {}; // Reset on error
  //     }
  //   } else {
  //     savedProperties = {};
  //   }
  // }
  ///version 2
  // Future<void> loadSavedProperties() async {
  //   final SharedPreferences prefs = await SharedPreferences.getInstance();
  //   String? savedPropertiesData = prefs.getString('savedProperties');
  //
  //   if (savedPropertiesData != null && savedPropertiesData.isNotEmpty) {
  //     try {
  //       final dynamic decodedData = jsonDecode(savedPropertiesData);
  //
  //       if (decodedData is Map<String, dynamic>) {
  //         savedProperties = decodedData.map<String, List<Property>>(
  //               (key, value) => MapEntry(
  //             key,
  //             (value as List<dynamic>)
  //                 .map<Property>((item) => Property.fromMap(item as Map<String, dynamic>))
  //                 .toList(),
  //           ),
  //         );
  //         return; // Stop execution if data is found locally
  //       } else {
  //         print("Error: Decoded data is not a Map<String, dynamic>");
  //       }
  //     } catch (e) {
  //       print("Error parsing saved properties: $e");
  //     }
  //   }
  //
  //   // If no local data, fetch from Firestore
  //   try {
  //     final FirebaseFirestore firestore = FirebaseFirestore.instance;
  //     final String uid = FirebaseAuth.instance.currentUser?.uid ?? '';
  //
  //     if (uid.isNotEmpty) {
  //       final DocumentSnapshot<Map<String, dynamic>> doc =
  //       await firestore.collection('savedProperties').doc(uid).get();
  //
  //       if (doc.exists && doc.data() != null) {
  //         print('here i come because data is there');
  //         final Map<String, dynamic> data = doc.data()!;
  //         savedProperties = data.map<String, List<Property>>(
  //               (key, value) => MapEntry(
  //             key,
  //             (value as List<dynamic>)
  //                 .map<Property>((item) => Property.fromMap(item as Map<String, dynamic>))
  //                 .toList(),
  //           ),
  //         );
  //
  //         // Save fetched data to SharedPreferences
  //         await prefs.setString('savedProperties', jsonEncode(savedProperties));
  //       } else {
  //         print("No properties found in Firestore for UID: $uid");
  //         savedProperties = {};
  //       }
  //     } else {
  //       print("No user logged in.");
  //       savedProperties = {};
  //     }
  //   } catch (e) {
  //     print("Error fetching properties from Firestore: $e");
  //     savedProperties = {};
  //   }
  // }
  ///Version 3
  // Future<void> loadSavedProperties() async {
  //   final SharedPreferences prefs = await SharedPreferences.getInstance();
  //   String? savedPropertiesData = prefs.getString('savedProperties');
  //
  //   if (savedPropertiesData != null && savedPropertiesData.isNotEmpty) {
  //     try {
  //       final dynamic decodedData = jsonDecode(savedPropertiesData);
  //
  //       if (decodedData is Map<String, dynamic>) {
  //         savedProperties = decodedData.map<String, List<Property>>(
  //               (key, value) => MapEntry(
  //             key,
  //             (value as List<dynamic>)
  //                 .map<Property>((item) => Property.fromMap(item as Map<String, dynamic>))
  //                 .toList(),
  //           ),
  //         );
  //         return; // Stop execution if data is found locally
  //       } else {
  //         print("Error: Decoded data is not a Map<String, dynamic>");
  //       }
  //     } catch (e) {
  //       print("Error parsing saved properties: $e");
  //     }
  //   }
  //
  //   // If no local data, fetch from Firestore
  //   try {
  //     final FirebaseFirestore firestore = FirebaseFirestore.instance;
  //     final String uid = FirebaseAuth.instance.currentUser?.uid ?? '';
  //
  //     if (uid.isNotEmpty) {
  //       print('Hello there i am go');
  //       final QuerySnapshot<Map<String, dynamic>> querySnapshot =
  //       await firestore.collection('SavedProperties')
  //           .doc(uid)
  //           .collection('Properties')
  //           .get();
  //
  //       if (querySnapshot.docs.isNotEmpty) {
  //         print('Documents found: ${querySnapshot.docs.length}');
  //         print('Fetching properties from Firestore...');
  //
  //         savedProperties = {
  //           uid: querySnapshot.docs.map<Property>((doc) {
  //             final Map<String, dynamic> data = doc.data();
  //             return Property.fromMap(data);
  //           }).toList(),
  //         };
  //
  //         // Save fetched data to SharedPreferences
  //         await prefs.setString('savedProperties', jsonEncode(savedProperties));
  //       } else {
  //         print("No properties found in Firestore for UID: $uid");
  //         savedProperties = {};
  //       }
  //     } else {
  //       print("No user logged in.");
  //       savedProperties = {};
  //     }
  //   } catch (e) {
  //     print("Error fetching properties from Firestore: $e");
  //     savedProperties = {};
  //   }
  // }
  ///version 4
  // Future<void> loadSavedProperties() async {
  //   final SharedPreferences prefs = await SharedPreferences.getInstance();
  //   String? savedPropertiesData = prefs.getString('savedProperties');
  //
  //   if (savedPropertiesData != null && savedPropertiesData.isNotEmpty) {
  //     try {
  //       final dynamic decodedData = jsonDecode(savedPropertiesData);
  //
  //       if (decodedData is Map<String, dynamic>) {
  //         savedProperties = decodedData.map<String, List<Property>>(
  //               (key, value) => MapEntry(
  //             key,
  //             (value as List<dynamic>)
  //                 .map<Property>((item) => Property.fromMap(item as Map<String, dynamic>))
  //                 .toList(),
  //           ),
  //         );
  //         return; // Stop execution if data is found locally
  //       } else {
  //         print("Error: Decoded data is not a Map<String, dynamic>");
  //       }
  //     } catch (e) {
  //       print("Error parsing saved properties: $e");
  //     }
  //   }
  //
  //   // If no local data, fetch from Firestore
  //   try {
  //     final FirebaseFirestore firestore = FirebaseFirestore.instance;
  //     final String uid = FirebaseAuth.instance.currentUser?.uid ?? '';
  //
  //     if (uid.isNotEmpty) {
  //       print('Hello there I am go');
  //       final QuerySnapshot<Map<String, dynamic>> querySnapshot =
  //       await firestore.collection('SavedProperties')
  //           .doc(uid)
  //           .collection('Properties')
  //           .get();
  //
  //       if (querySnapshot.docs.isNotEmpty) {
  //         print('Documents found: ${querySnapshot.docs.length}');
  //         print('Fetching properties from Firestore...');
  //
  //         savedProperties = {
  //           uid: querySnapshot.docs.map<Property>((doc) {
  //             final Map<String, dynamic> data = doc.data();
  //             return Property.fromMap(data);
  //           }).toList(),
  //         };
  //
  //         // Save fetched data to SharedPreferences in the correct format
  //         await prefs.setString(
  //           'savedProperties',
  //           jsonEncode(
  //             savedProperties.map(
  //                   (key, value) => MapEntry(
  //                 key,
  //                 value.map((property) => property.toMap()).toList(), // Convert objects to maps
  //               ),
  //             ),
  //           ),
  //         );
  //       } else {
  //         print("No properties found in Firestore for UID: $uid");
  //         savedProperties = {};
  //       }
  //     } else {
  //       print("No user logged in.");
  //       savedProperties = {};
  //     }
  //   } catch (e) {
  //     print("Error fetching properties from Firestore: $e");
  //     savedProperties = {};
  //   }
  // }
  Future<void> loadSavedProperties() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final String uid = FirebaseAuth.instance.currentUser?.uid ?? '';

    if (uid.isEmpty) {
      print("No user logged in.");
      savedProperties = {};
      return;
    }

    String? savedPropertiesData = prefs.getString('savedProperties');

    bool shouldFetchFromFirestore = true;

    if (savedPropertiesData != null && savedPropertiesData.isNotEmpty) {
      try {
        final dynamic decodedData = jsonDecode(savedPropertiesData);

        if (decodedData is Map<String, dynamic>) {
          // Load data for the current user if available
          if (decodedData.containsKey(uid)) {
            print('Yes Data is there');
            savedProperties = {
              uid: (decodedData[uid] as List<dynamic>)
                  .map<Property>((item) => Property.fromMap(item as Map<String, dynamic>))
                  .toList(),
            };
            print("Loaded saved properties from Shared Preferences for user: $uid");
            shouldFetchFromFirestore = false; // No need to fetch from Firestore
          } else {
            print("No saved properties found for the current user in Shared Preferences.");
          }
        } else {
          print("Error: Decoded data is not a Map<String, dynamic>");
        }
      } catch (e) {
        print("Error parsing saved properties: $e");
      }
    } else {
      print("No saved properties found in Shared Preferences.");
    }

    // If the user’s data was not found, fetch from Firestore
    if (shouldFetchFromFirestore) {
      try {
        final FirebaseFirestore firestore = FirebaseFirestore.instance;

        print('Fetching properties from Firestore for UID: $uid...');
        final QuerySnapshot<Map<String, dynamic>> querySnapshot =
        await firestore.collection('SavedProperties')
            .doc(uid)
            .collection('Properties')
            .get();

        if (querySnapshot.docs.isNotEmpty) {
          print('Documents found: ${querySnapshot.docs.length}');

          savedProperties = {
            uid: querySnapshot.docs.map<Property>((doc) {
              final Map<String, dynamic> data = doc.data();
              return Property.fromMap(data);
            }).toList(),
          };

          // Save fetched data to SharedPreferences
          await prefs.setString(
            'savedProperties',
            jsonEncode(
              savedProperties.map(
                    (key, value) => MapEntry(
                  key,
                  value.map((property) => property.toMap()).toList(), // Convert objects to maps
                ),
              ),
            ),
          );

          print("Saved properties from Firestore to Shared Preferences for user: $uid");
        } else {
          print("No properties found in Firestore for UID: $uid");
          savedProperties = {};
        }
      } catch (e) {
        print("Error fetching properties from Firestore: $e");
        savedProperties = {};
      }
    }
  }





  Future<void> loadSavingProperties() async {
    isLoadingSavedProperties = true;
    notifyListeners();

    final SharedPreferences prefs = await SharedPreferences.getInstance();
    String? savedPropertiesData = prefs.getString('savedProperties');

    if (savedPropertiesData != null && savedPropertiesData.isNotEmpty) {
      try {
        final Map<String, dynamic> decodedData = jsonDecode(savedPropertiesData) as Map<String, dynamic>;

        savedProperties = decodedData.map<String, List<Property>>(
              (key, value) => MapEntry(
            key,
            (value as List<dynamic>).map<Property>(
                  (item) => Property.fromMap(item as Map<String, dynamic>),
            ).toList(),
          ),
        );
      } catch (e) {
        print("Error loading saved properties: $e");
        savedProperties = {}; // Reset on error
      }
    } else {
      savedProperties = {};
    }

    isLoadingSavedProperties = false;
    notifyListeners();
  }


  List<Property> getSavedPropertiesForCurrentUser() {
    final String? userId = auth.currentUser?.uid;
    if (userId == null) {
      return [];
    }
    return savedProperties[userId] ?? [];
  }


  Future<void> toggleSaveProperty(BuildContext context, Property property) async {
    final String userId = auth.currentUser!.uid;
    final SharedPreferences prefs = await SharedPreferences.getInstance();

    if (savedProperties.isEmpty) {
      await loadSavedProperties();
    }

    if (!savedProperties.containsKey(userId)) {
      savedProperties[userId] = [];
    }

    bool isSaved = savedProperties[userId]!.any((p) => p.propertyId == property.propertyId);

    if (isSaved) {
      savedProperties[userId]!.removeWhere((p) => p.propertyId == property.propertyId);
      await _firestore
          .collection("SavedProperties")
          .doc(userId)
          .collection("Properties")
          .doc(property.propertyId)
          .delete();
      _showSnackbar(context, "Property Unsaved Successfully", Colors.red);
    } else {
      savedProperties[userId]!.add(property);
      await _firestore
          .collection("SavedProperties")
          .doc(userId)
          .collection("Properties")
          .doc(property.propertyId)
          .set(property.toMap());
      _showSnackbar(context, "Property Saved Successfully", Colors.blue);
    }
    final Map<String, dynamic> serializedData = savedProperties.map(
          (key, value) => MapEntry(
        key,
        value.map((p) => p.toMap()).toList(),
      ),
    );

    await prefs.setString('savedProperties', jsonEncode(serializedData));

    notifyListeners();
  }



  /// **🎯 Show Snackbar**
  void _showSnackbar(BuildContext context, String message, Color color) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message, style: const TextStyle(color: Colors.white)),
        backgroundColor: color,
        duration: const Duration(seconds: 2),
      ),
    );
  }

}
