import 'dart:io';
import 'dart:typed_data';

import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:flutter/services.dart' show rootBundle;

Future<Uint8List?> getImage(ImageSource source) async {
  final file = await ImagePicker().pickImage(source: source);
  if (file == null) {
    return null;
  }
  return file.readAsBytes();
}

Future<Uint8List> getImageFileFromAssets(String path) async {
  final byteData = await rootBundle.load('assets/$path');

  final file = File('${(await getTemporaryDirectory()).path}/$path');
  await file.writeAsBytes(byteData.buffer
      .asUint8List(byteData.offsetInBytes, byteData.lengthInBytes));

  return file.readAsBytes();
}
