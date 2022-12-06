import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class LoginFormProvider extends ChangeNotifier {
  GlobalKey<FormState> formkey = GlobalKey<FormState>();

  String email = '';
  String password = '';
  bool _isloading = false;
  late User user;

  bool get isLoading => _isloading;
  set isLoading(bool value) {
    _isloading = value;
    notifyListeners();
  }

  bool isValidForm() {
    return formkey.currentState?.validate() ?? false;
  }
}
