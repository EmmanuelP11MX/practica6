import 'dart:convert';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:practica6/models/github_login_response.dart';
import 'package:practica6/models/user.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:http/http.dart' as http;

import '../models/github_login_request.dart';

class AuthServices extends ChangeNotifier {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  User? user;
  String provider = '';

  Future<bool> createUserWithEmailAndPassword(
      {required String email, required String password}) async {
    try {
      final UserCredential userCredential = await _auth
          .createUserWithEmailAndPassword(email: email, password: password);
      User auxUser = userCredential.user!;
      auxUser.sendEmailVerification();
      return true;
    } catch (e) {
      return false;
    }
  }

  Future<UserDAO> signInWithEmailAndPassword(
      {required String email, required String password}) async {
    UserDAO userDAO;
    try {
      final UserCredential userCredential = await _auth
          .signInWithEmailAndPassword(email: email, password: password);
      user = userCredential.user;
      provider = 'emailandpassword';
      userDAO = await userExists();
      notifyListeners();
    } catch (e) {
      createUser();
      userDAO = await userExists();
    }
    return userDAO;
  }

  void createUser() {
    DocumentReference documentReference =
        _firestore.collection('users').doc(user!.uid);
    documentReference.set({
      'id': user!.uid,
      'email': user!.email,
      'fullName': user!.displayName ?? "No name",
      'image': user!.photoURL ??
          "https://cdn-icons-png.flaticon.com/512/147/147144.png",
      'phone': "",
      'lastSignIn': DateTime.now(),
    }, SetOptions(merge: true));
  }

  Future<UserDAO> userExists() async {
    final documentReference = _firestore.collection('users');
    final ref = await documentReference
        .where("id", isEqualTo: user!.uid)
        .withConverter(
            fromFirestore: UserDAO.fromFirestore,
            toFirestore: (UserDAO user, _) => user.toFirestore());
    final docSnamp = await ref.get();
    final userDAO = docSnamp.docs.first.data();
    return userDAO;
  }

  Future<UserDAO?> signInWithGoogle() async {
    UserDAO userDAO;
    final GoogleSignIn googleSignIn = GoogleSignIn();
    final GoogleSignInAccount? googleSignInAccount =
        await googleSignIn.signIn();

    if (googleSignInAccount != null) {
      final GoogleSignInAuthentication googleSignInAuthentication =
          await googleSignInAccount.authentication;

      final AuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleSignInAuthentication.accessToken,
        idToken: googleSignInAuthentication.idToken,
      );
      try {
        final UserCredential userCredential =
            await _auth.signInWithCredential(credential);
        user = userCredential.user;
        provider = 'google';
        userDAO = await userExists();

        notifyListeners();
      } catch (e) {
        createUser();
        userDAO = await userExists();
      }
      return userDAO;
    }
    return null;
  }

  Future signInWithFacebook() async {
    // Trigger the sign-in flow
    UserDAO userDAO;

    final LoginResult loginResult = await FacebookAuth.instance.login();

    // Create a credential from the access token
    final OAuthCredential facebookAuthCredential =
        FacebookAuthProvider.credential(loginResult.accessToken!.token);
    try {
      final UserCredential userCredential =
          await _auth.signInWithCredential(facebookAuthCredential);
      user = userCredential.user;
      provider = 'facebook';
      userDAO = await userExists();

      notifyListeners();
    } catch (e) {
      createUser();
      userDAO = await userExists();
    }
    return userDAO;
  }

  // Future signInWithGithub(String code) async {
  //   final response = await http.post(
  //     Uri.parse('https://github.com/login/oauth/access_token'),
  //     headers: {
  //       "Content-Type": "application/json",
  //       "Accept": "application/json"
  //     },
  //     body: jsonEncode(GitHubLoginRequest(
  //       clientId: SecretKey.GITHUB_CLIENT_ID,
  //       clientSecret: SecretKey.GITHUB_CLIENT_SECRET,
  //       code: code,
  //     )),
  //   );
  //   GitHubLoginResponse loginResponse =
  //       GitHubLoginResponse.fromJson(json.decode(response.body));
  //   final AuthCredential credential =
  //       GithubAuthProvider.credential(loginResponse.accessToken);
  //   user = (await _auth.signInWithCredential(credential)).user;
  // }

  Future<void> signOut() async {
    await _auth.signOut();
    switch (provider) {
      case 'google':
        await GoogleSignIn().signOut();
        break;
      case 'facebook':
        await FacebookAuth.instance.logOut();
        break;
      case 'github':
        _auth.signOut();
        break;
    }
  }
}
