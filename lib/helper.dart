import 'dart:io';
import 'dart:typed_data';

Future<Uint8List> convertImagePathToBytes(String imagePath) async {
  final File imageFile = File(imagePath);
  return await imageFile.readAsBytes();
}