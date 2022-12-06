import 'dart:convert';
import 'package:cloud_firestore/cloud_firestore.dart';

class UserDAO {
  String? id;
  String? fullName = '';
  String? email = '';
  String? phone = '';
  String? image = '';
  DateTime? lastSignIn;
  UserDAO(
      {this.id,
      this.fullName,
      this.email,
      this.phone,
      this.image,
      this.lastSignIn});

  factory UserDAO.fromJson(Map<String, dynamic> mapUser) {
    return UserDAO(
        id: mapUser['id'],
        fullName: mapUser['fullName'],
        email: mapUser['email'],
        phone: mapUser['phone'],
        image: mapUser['image']);
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'fullName': fullName,
        'email': email,
        'phone': phone,
        'image': image,
      };
  String aJson() => json.encode(toJson());

  factory UserDAO.fromFirestore(
    DocumentSnapshot<Map<String, dynamic>> snapshot,
    SnapshotOptions? options,
  ) {
    final data = snapshot.data();
    return UserDAO(
      id: data?['id'],
      fullName: data?['fullName'],
      email: data?['email'],
      phone: data?['phone'],
      image: data?['image'],
      lastSignIn: data?['lastSignIn'].toDate(),
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      if (id != null) "id": id,
      if (fullName != null) "fullName": fullName,
      if (email != null) "email": email,
      if (phone != null) "phone": phone,
      if (image != null) "image": image,
      if (lastSignIn != null) "lastSignIn": lastSignIn,
    };
  }
  // }
}
