import 'dart:io';
import 'dart:typed_data';

import 'package:image_picker/image_picker.dart';

class ImagePickerUtil {
  final ImagePicker _picker = ImagePicker();

  // Получение изображения из галереи
  Future<Uint8List?> pickImageFromGallery() async {
    final XFile? pickedFile = await _picker.pickImage(
      source: ImageSource.gallery,
      imageQuality: 50, // Качество изображения (0-100)
    );

    if (pickedFile != null) {
      return pickedFile.readAsBytes(); // Use readAsBytes() instead of readAsBytesSync()
    } else {
      return null;
    }
  }

  // Получение изображения с камеры
  Future<Uint8List?> pickImageFromCamera() async {
    final XFile? pickedFile = await _picker.pickImage(
      source: ImageSource.camera,
      imageQuality: 50, // Качество изображения (0-100)
    );

    if (pickedFile != null) {
      return pickedFile.readAsBytes(); // Use readAsBytes() instead of readAsBytesSync()
    } else {
      return null;
    }
  }
}
