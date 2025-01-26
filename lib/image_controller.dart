import 'dart:typed_data';
import 'package:flutter/material.dart';

class ImageController extends ChangeNotifier {
  final List<Uint8List> _selectedImages = [];

  List<Uint8List> get selectedImages => _selectedImages;

  void addImage(Uint8List image) {
    _selectedImages.add(image);
    notifyListeners();
  }

  void removeImage(Uint8List image) {
    _selectedImages.remove(image);
    notifyListeners();
  }

  void clearImages() {
    _selectedImages.clear();
    notifyListeners();
  }

}