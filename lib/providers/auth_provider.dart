import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:kit_chat/resources/firestore_methods.dart';
import 'package:kit_chat/models/models.dart' as app_models;

enum AuthState {
  authenticated,
  unauthenticated,
}

enum ActionType {
  add,
  remove,
}

class AuthProvider extends ChangeNotifier {
  app_models.User? _user;
  app_models.User? get user => _user;

  AuthState _state = AuthState.unauthenticated;
  AuthState get state => _state;

  AuthProvider() {
    log("current user: ${FirebaseAuth.instance.currentUser}");
    if (FirebaseAuth.instance.currentUser != null) {
      _state = AuthState.authenticated;
      notifyListeners();
    }
    FirebaseAuth.instance.authStateChanges().listen((firebaseUser) async {
      if (firebaseUser == null) {
        log("unauthenticated", name: "AuthProvider");
        _state = AuthState.unauthenticated;
        _user = null;
        notifyListeners();
      } else {
        log("authenticated - UID: ${firebaseUser.uid}", name: "AuthProvider");
        _state = AuthState.authenticated;
        _user = (await FirestoreMethods().getUserDetails(firebaseUser.uid));
        FirebaseFirestore.instance
            .collection("users")
            .doc(FirebaseAuth.instance.currentUser!.uid)
            .snapshots()
            .listen((snapshot) {
          if (snapshot.data() != null) {
            _user = app_models.User.fromSnapshot(snapshot.data()!);
            notifyListeners();
          }
        });
        notifyListeners();
      }
    });
  }
}
