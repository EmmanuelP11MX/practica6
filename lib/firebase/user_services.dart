import 'dart:convert';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:practica6/models/user.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class UserServices extends ChangeNotifier {
  final String _baseUrl = 'parctica-auth-default-rtdb.firebaseio.com';
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  GlobalKey<FormState> formkey = GlobalKey<FormState>();

  bool isloading = true;
  UserDAO userDAO = UserDAO(
    fullName: '',
    email: '',
    phone: '',
    image: '',
  );

  loadUser(UserDAO user) async {
    userDAO = user;
    notifyListeners();
  }

  updateUser() {
    DocumentReference documentReference =
        _firestore.collection('users').doc(userDAO.id);
    documentReference.set({
      'fullName': userDAO.fullName ?? "No name",
      'image': userDAO.image ??
          "https://cdn-icons-png.flaticon.com/512/147/147144.png",
      'phone': userDAO.phone ?? "No phone",
      'lastSignIn': DateTime.now(),
    }, SetOptions(merge: true));
    notifyListeners();
  }

  bool isfullUser = false;

  bool _isloading = false;

  bool get isLoading => _isloading;
  set isLoading(bool value) {
    _isloading = value;
    notifyListeners();
  }

  selectImage(File image) async {
    final url = Uri.parse(
        'https://api.cloudinary.com/v1_1/dtzfgcni1/image/upload?upload_preset=q7iqmy8b');
    final imageUploadRequest = http.MultipartRequest('POST', url);

    final file = await http.MultipartFile.fromPath('file', image.path);

    imageUploadRequest.files.add(file);

    final streamResponse = await imageUploadRequest.send();
    final resp = await http.Response.fromStream(streamResponse);
    if (resp.statusCode != 200 && resp.statusCode != 201) {
      print('algo salio mal');
      print(resp.body);
      return null;
    }
    userDAO.image = json.decode(resp.body)['secure_url'];
    notifyListeners();
  }

  bool isValidForm() {
    return formkey.currentState?.validate() ?? false;
  }
}
