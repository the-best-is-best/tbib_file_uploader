import 'dart:io';

import 'package:image_picker/image_picker.dart';

/// select image from camera
/// [maxSize] is in MB
Future<({String? path, String? name, String? error})> selectImageCameraAsync({
  int? maxSize,
}) async {
  final picker = ImagePicker();
  final image = await picker.pickImage(source: ImageSource.camera);
  if (image == null) return (path: null, name: null, error: null);
  if (maxSize != null) {
    final imageBytes = await image.readAsBytes();

    if (imageBytes.lengthInBytes > maxSize * 1000000) {
      return (path: null, name: null, error: 'Image size is too large');
    }
  }

  return (path: image.path, name: image.name, error: null);
}

/// select image from gallery
/// [maxSize] is in MB
Future<({String? path, String? name, String? error})> selectImageGalleryAsync({
  int? maxSize,
}) async {
  final picker = ImagePicker();
  final image = await picker.pickImage(
    source: ImageSource.gallery,
  );
  if (image == null) return (path: null, name: null, error: null);

  if (maxSize != null) {
    final imageBytes = await image.readAsBytes();
    if (imageBytes.lengthInBytes > maxSize * 1000000) {
      return (path: null, name: null, error: 'Image size is too large');
    }
  }

  final newFile = XFile(File(image.path).path);
  return (path: newFile.path, name: newFile.name, error: null);
}
