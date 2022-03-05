import 'dart:developer';
import 'dart:typed_data';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:kit_chat/resources/firestore_methods.dart';
import 'package:kit_chat/resources/storage_methods.dart';
import 'package:kit_chat/models/models.dart' as app_models;

class AuthMethods {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future<void> signUpWithEmailAndPassword({
    required String email,
    required String password,
    required String name,
    Uint8List? imageFile,
  }) async {
    if (name.isNotEmpty) {
      log("valid");
      try {
        await _auth.createUserWithEmailAndPassword(
          email: email,
          password: password,
        );
        final profileImageUrl = imageFile == null
            ? ""
            : await StorageMethods()
                .uploadImage(imageFile, "profileImages", false);
        log(profileImageUrl, name: "profileImageUrl");
        final newUser = app_models.User(
          profileImage: profileImageUrl,
          email: _auth.currentUser!.email!,
          conversations: [],
          uid: _auth.currentUser!.uid,
          name: name,
        );
        await FirestoreMethods().createNewUserData(newUser);
      } on FirebaseAuthException catch (e) {
        throw SignUpError(e.message ?? "An error occurred");
      } on FirebaseException {
        throw SignUpError("An error occurred");
      }
    } else {
      throw SignUpError("Name must not be empty");
    }
  }

  Future<void> signInWithEmailAndPassword({
    required String email,
    required String password,
  }) async {
    try {
      await _auth.signInWithEmailAndPassword(email: email, password: password);
    } on FirebaseAuthException catch (e) {
      throw LoginError(e.message ?? "An error occurred");
    }
  }

  Future<void> signOut() {
    return _auth.signOut();
  }
}

class LoginError implements Exception {
  final String message;

  LoginError(this.message);
}

class SignUpError implements Exception {
  final String message;

  SignUpError(this.message);
}
