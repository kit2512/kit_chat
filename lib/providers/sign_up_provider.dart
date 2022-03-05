import 'dart:developer';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:kit_chat/resources/resources.dart';

class SignUpProvider extends ChangeNotifier {
  String _email = "";
  String _password = "";
  String _name = "";
  Uint8List? _imageFile;
  Uint8List? get imageFile => _imageFile;

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  void setEmail(String newEmail) {
    _email = newEmail;
  }

  void setPassword(String newPassword) {
    _password = newPassword;
  }

  void setIsLoading(bool newIsLoading) {
    _isLoading = newIsLoading;
    notifyListeners();
  }

  void setName(String newName) {
    _name = newName;
  }

  void setFile(Uint8List? newFile) {
    _imageFile = newFile;
    notifyListeners();
  }

  Future<void> signUp() async {
    try {
      setIsLoading(true);
      await AuthMethods().signUpWithEmailAndPassword(
          email: _email,
          password: _password,
          name: _name,
          imageFile: imageFile);
      setIsLoading(false);
    } on SignUpError catch (e) {
      setIsLoading(false);
      rethrow;
    }
  }
}
