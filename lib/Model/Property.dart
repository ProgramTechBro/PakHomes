import 'dart:convert';
import 'package:cloud_firestore/cloud_firestore.dart';

class Property {
  final String? propertyType;
  final String? propertyId;
  final String? projectType;
  final String? description;
  final String? city;
  final String? projectTitle;
  final String? areaType;
  final String? areaSize;
  final int? price;
  final String? location;
  final List<String>? images;
  final String? ownerId;

  Property({
    this.propertyType,
    this.propertyId,
    this.projectType,
    this.description,
    this.city,
    this.projectTitle,
    this.areaType,
    this.areaSize,
    this.price,
    this.location,
    this.images,
    this.ownerId,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'propertyType': propertyType,
      'propertyId':propertyId,
      'projectType':projectType,
      'description': description,
      'city': city,
      'projectTitle': projectTitle,
      'areaType': areaType,
      'areaSize': areaSize,
      'price': price,
      'location': location,
      'images': images,
      'ownerId': ownerId, // Added ownerId to the map
    };
  }

  factory Property.fromMap(Map<String, dynamic> map) {
    return Property(
      propertyType: map['propertyType'] != null ? map['propertyType'] as String : null,
      propertyId: map['propertyId'] != null ? map['propertyId'] as String : null,
      projectType: map['projectType'] != null ? map['projectType'] as String : null,
      description: map['description'] != null ? map['description'] as String : null,
      city: map['city'] != null ? map['city'] as String : null,
      projectTitle: map['projectTitle'] != null ? map['projectTitle'] as String : null,
      areaType: map['areaType'] != null ? map['areaType'] as String : null,
      areaSize: map['areaSize'] != null ? map['areaSize'] as String : null,
      price: map['price'] != null ? map['price'] as int : null,
      location: map['location'] != null ? map['location'] as String : null,
      images: map['images'] != null ? List<String>.from(map['images']) : null,
      ownerId: map['ownerId'] != null ? map['ownerId'] as String : null, // Added ownerId
    );
  }

  factory Property.fromSnapshot(DocumentSnapshot snapshot) {
    final data = snapshot.data() as Map<String, dynamic>;
    return Property(
      propertyType: data['propertyType'] != null ? data['propertyType'] as String : null,
      propertyId: data['propertyId'] != null ? data['propertyId'] as String : null,
      projectType: data['projectType'] != null ? data['projectType'] as String : null,
      description: data['description'] != null ? data['description'] as String : null,
      city: data['city'] != null ? data['city'] as String : null,
      projectTitle: data['projectTitle'] != null ? data['projectTitle'] as String : null,
      areaType: data['areaType'] != null ? data['areaType'] as String : null,
      areaSize: data['areaSize'] != null ? data['areaSize'] as String : null,
      price: data['price'] != null ? data['price'] as int : null,
      location: data['location'] != null ? data['location'] as String : null,
      images: data['images'] != null ? List<String>.from(data['images']) : null,
      ownerId: data['ownerId'] != null ? data['ownerId'] as String : null, // Added ownerId
    );
  }

  String toJson() => json.encode(toMap());

  factory Property.fromJson(String source) =>
      Property.fromMap(json.decode(source) as Map<String, dynamic>);
}
