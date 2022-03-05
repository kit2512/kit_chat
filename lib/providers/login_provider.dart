import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:kit_chat/resources/resources.dart';

class LoginProvider extends ChangeNotifier {
  bool _isLoading = false;
  bool get isLoading => _isLoading;

  String _email = "";
  String _password = "";
  Uint8List? file;

  void setLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }

  void setEmail(String newEmail) {
    _email = newEmail;
  }

  void setPassword(String newPassword) {
    _password = newPassword;
  }

  void clearInfo() {
    setEmail("");
    setEmail("");
    setLoading(false);
  }

  Future<void> login() async {
    try {
      setLoading(true);
      await AuthMethods()
          .signInWithEmailAndPassword(email: _email, password: _password);
      clearInfo();
      setLoading(false);
    } on Exception catch (_) {
      setLoading(false);
      rethrow;
    }
  }
}
