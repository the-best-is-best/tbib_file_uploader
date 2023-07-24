import 'dart:io';

import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart' as xpath;

/// select image from camera
/// [maxSize] is in MB
Future<({String? path, String? name, String? error})> selectImageCameraAsync({
  required String? changeFileNameTo,
  required int? imageQuality,
  int? maxSize,
}) async {
  final picker = ImagePicker();
  var image = await picker.pickImage(
    source: ImageSource.camera,
    imageQuality: imageQuality,
  );
  if (image == null) return (path: null, name: null, error: null);
  if (maxSize != null) {
    final imageBytes = await image.readAsBytes();

    if (imageBytes.lengthInBytes > maxSize * 1000000) {
      return (path: null, name: null, error: 'Image size is too large');
    }
  }

  if (changeFileNameTo != null) {
    final fileName = image.name;
    final fileExtension = fileName.split('.').last;
    final dir = xpath.dirname(image.path);

    final newFileName = '$changeFileNameTo.$fileExtension';
    image = XFile(xpath.join(dir, newFileName));

    return (path: image.path, name: newFileName, error: null);
  }

  return (path: image.path, name: image.name, error: null);
}

/// select image from gallery
/// [maxSize] is in MB
Future<({String? path, String? name, String? error})> selectImageGalleryAsync({
  required String? changeFileNameTo,
  required int? imageQuality,
  int? maxSize,
}) async {
  final picker = ImagePicker();
  var image = await picker.pickImage(
    source: ImageSource.gallery,
    imageQuality: imageQuality,
  );
  if (image == null) return (path: null, name: null, error: null);

  if (maxSize != null) {
    final imageBytes = await image.readAsBytes();
    if (imageBytes.lengthInBytes > maxSize * 1000000) {
      return (path: null, name: null, error: 'Image size is too large');
    }
  }

  if (changeFileNameTo != null) {
    final fileName = image.name;
    final fileExtension = fileName.split('.').last;
    final newFileName = '$changeFileNameTo.$fileExtension';
    final dir = xpath.dirname(image.path);

    image = XFile(xpath.join(dir, newFileName));

    return (path: image.path, name: newFileName, error: null);
  }

  final newFile = XFile(File(image.path).path);
  return (path: newFile.path, name: newFile.name, error: null);
}
