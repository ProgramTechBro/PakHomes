import 'dart:convert';
import 'package:cloud_firestore/cloud_firestore.dart';

class UserModel {
  final String? fullName;
  final String? username;
  final String? email;
  final String? address;
  final String? contact;
  final String? imageUrl;

  UserModel({
    this.fullName,
    this.username,
    this.email,
    this.address,
    this.contact,
    this.imageUrl,
  });

  Map<String, dynamic> toMap() {
    return {
      'fullName': fullName,
      'username': username,
      'email': email,
      'address': address,
      'contact': contact,
      'imageUrl': imageUrl,
    };
  }

  factory UserModel.fromMap(Map<String, dynamic> map) {
    return UserModel(
      fullName: map['fullName'] as String?,
      username: map['username'] as String?,
      email: map['email'] as String?,
      address: map['address'] as String?,
      contact: map['contact'] as String?,
      imageUrl: map['imageUrl'] as String?,
    );
  }

  factory UserModel.fromSnapshot(DocumentSnapshot snapshot) {
    final data = snapshot.data() as Map<String, dynamic>?;

    if (data == null) {
      return UserModel(); // Return empty model if data is null
    }

    return UserModel(
      fullName: data['fullName'] as String?,
      username: data['username'] as String?,
      email: data['email'] as String?,
      address: data['address'] as String?,
      contact: data['contact'] as String?,
      imageUrl: data['imageUrl'] as String?,
    );
  }

  String toJson() => json.encode(toMap());

  factory UserModel.fromJson(String source) =>
      UserModel.fromMap(json.decode(source) as Map<String, dynamic>);

  UserModel copyWith({
    String? fullName,
    String? username,
    String? email,
    String? address,
    String? contact,
    String? imageUrl,
  }) {
    return UserModel(
      fullName: fullName ?? this.fullName,
      username: username ?? this.username,
      email: email ?? this.email,
      address: address ?? this.address,
      contact: contact ?? this.contact,
      imageUrl: imageUrl ?? this.imageUrl,
    );
  }
}
