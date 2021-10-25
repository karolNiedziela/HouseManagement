import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:housemanagement/models/app_user.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  AppUser? _appUserFromFirebaseUser(User? user) {
    return user != null ? AppUser(uid: user.uid) : null;
  }

  String? get uid {
    return _auth.currentUser?.uid;
  }

  Stream<AppUser?> get appUser {
    return _auth
        .authStateChanges()
        .map((User? user) => _appUserFromFirebaseUser(user));
  }

  Future signIn(String email, String password) async {
    try {
      await _auth.signInWithEmailAndPassword(email: email, password: password);
    } catch (e) {
      Fluttertoast.showToast(msg: e.toString());
    }
  }

  Future registerWithEmailAndPassword(String email, String password,
      String firstName, String secondName) async {
    try {
      UserCredential userCredential = await _auth
          .createUserWithEmailAndPassword(email: email, password: password);
      User user = userCredential.user!;
      FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;
      AppUser appUser = new AppUser(
          uid: user.uid,
          email: user.email,
          firstName: firstName,
          secondName: secondName);

      await firebaseFirestore
          .collection("users")
          .doc(user.uid)
          .set(appUser.toMap());
      Fluttertoast.showToast(
        msg: "Account created successfully.",
        gravity: ToastGravity.TOP_RIGHT,
        timeInSecForIosWeb: 2,
        backgroundColor: Colors.indigo[200],
      );
    } on FirebaseAuthException catch (e) {
      String errorMessage = '';
      switch (e.code) {
        case "email-already-in-use":
          errorMessage = "Email is already taken.";
          break;
        case "error-weak-password":
          errorMessage =
              "The password is invalid it must 6 characters at least";
          break;
        default:
          errorMessage = "An undefined Error happened.";
      }

      Fluttertoast.showToast(msg: errorMessage);
    }
  }

  Future signOut() async {
    try {
      return await _auth.signOut();
    } catch (e) {
      print(e.toString());
      return null;
    }
  }
}
