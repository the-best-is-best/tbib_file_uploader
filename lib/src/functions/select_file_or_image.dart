import 'package:flutter/material.dart';
import 'package:tbib_file_uploader/tbib_file_uploader.dart';

/// function to select file or image
Future<void> selectFileOrImage({
  required BuildContext context,
  required void Function({String? name, String? path}) selectedFile,
  int? maxFileSize,
  String? changeFileNameTo,
  List<String>? allowedExtensions,
  int? imageQuality,
  bool selectImageOnly = false,
}) async {
  await showModalBottomSheet<String>(
    context: context,
    builder: (context) {
      return SelectFile(
        imageQuality: imageQuality,
        maxFileSize: maxFileSize,
        changeFileNameTo: changeFileNameTo,
        allowedExtensions: allowedExtensions,
        selectImageOnly: selectImageOnly,
        selectFileOrImage: ({path, name, error}) {
          if (path != null || error != null) {
            selectedFile(name: name, path: path);
          } else {
            selectedFile(name: null, path: null);
          }
        },
      );
    },
  );
}
