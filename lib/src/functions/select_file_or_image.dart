import 'package:flutter/material.dart';
import 'package:tbib_file_uploader/tbib_file_uploader.dart';

/// function to select file or image
Future<void> selectFileOrImage({
  required BuildContext context,
  required void Function({String? name, String? path}) selectedFile,
  required bool selectFile,
  required bool selectImageCamera,
  required bool selectImageGallery,
  int? maxFileSize,
  String? changeFileNameTo,
  List<FileExtensions>? allowedExtensions,
  int? imageQuality,
  FileType? fileType,
}) async {
  await showModalBottomSheet<String>(
    context: context,
    builder: (context) {
      return SelectFile(
        imageQuality: imageQuality,
        maxFileSize: maxFileSize,
        changeFileNameTo: changeFileNameTo,
        selectImageCamera: selectImageCamera,
        selectImageGallery: selectImageGallery,
        selectFile: selectFile,
        allowedExtensions:
            allowedExtensions?.map((e) => '.${e.name.toLowerCase()}').toList(),
        fileType: fileType,
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
