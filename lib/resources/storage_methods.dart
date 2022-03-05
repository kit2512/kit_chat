import 'dart:typed_data';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';

class StorageMethods {
  final FirebaseStorage _storage = FirebaseStorage.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future<String> uploadImage(
      Uint8List file, String childName, bool isPhotoMessage) async {
    try {
      Reference ref =
          _storage.ref().child(childName).child(_auth.currentUser!.uid);
      UploadTask uploadImageTask = ref.putData(file);
      final snapshot = await uploadImageTask;
      return snapshot.ref.getDownloadURL();
    } on FirebaseException catch (_) {
      rethrow;
    }
  }
}
