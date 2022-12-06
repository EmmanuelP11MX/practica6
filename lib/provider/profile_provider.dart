import 'package:practica6/models/user.dart';
import 'package:flutter/material.dart';

class ProfileProvider extends ChangeNotifier {
  GlobalKey<FormState> formkey = GlobalKey<FormState>();

  UserDAO userDAO = UserDAO(
    fullName: '',
    email: '',
    phone: '',
    image: '',
  );

  bool isfullUser = false;

  bool _isloading = false;
  bool get isLoading => _isloading;
  set isLoading(bool value) {
    _isloading = value;
    notifyListeners();
  }

  selectImage(String image) {
    userDAO.image = image;
    notifyListeners();
  }

  bool isValidForm() {
    return formkey.currentState?.validate() ?? false;
  }
}
