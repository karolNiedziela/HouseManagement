import 'package:firebase_auth/firebase_auth.dart';
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
    } on FirebaseAuthException catch (e) {
      String errorMessage = '';
      if (e.code == 'user-not-found') {
        errorMessage = 'Niepoprawne dane.';
      } else if (e.code == 'wrong-password') {
        errorMessage = 'Niepoprawne dane.';
      }

      return errorMessage;
    }
  }

  Future registerWithEmailAndPassword(String email, String password,
      String confirmPassword, String firstName, String secondName) async {
    if (password != confirmPassword) {
      return 'Hasła różnią się.';
    }

    try {
      UserCredential userCredential = await _auth
          .createUserWithEmailAndPassword(email: email, password: password);
      User user = userCredential.user!;
      FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;
      AppUser appUser = AppUser(
          uid: user.uid,
          email: user.email,
          firstName: firstName,
          secondName: secondName);

      await firebaseFirestore
          .collection("users")
          .doc(user.uid)
          .set(appUser.toMap());
    } on FirebaseAuthException catch (e) {
      String errorMessage = '';
      switch (e.code) {
        case "email-already-in-use":
          errorMessage = "Adres email jest zajęty.";
          break;
        default:
          errorMessage = "Error occured.";
      }

      return errorMessage;
    }
  }

  Future signOut() async {
    try {
      return await _auth.signOut();
    } catch (e) {
      return null;
    }
  }
}
