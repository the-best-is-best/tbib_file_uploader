// select_file.dart

import 'dart:io';

import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:tbib_file_uploader/src/permission_hander.dart';
import 'package:tbib_file_uploader/tbib_file_uploader.dart';

/// A [Select File] that contains a [FileUploader].
class SelectFile extends StatefulWidget {
  /// [selectFileOrImage] is a function that returns a [FileUploader].
  final void Function({
    required String? path,
    required String? name,
    required String? error,
  }) selectFileOrImage;

  /// [maxFileSize] by MB.
  final int? maxFileSize;

  /// change file name
  final String? changeFileNameTo;

  /// [imageQuality] is a number between 0 and 100.
  final int? imageQuality;

  /// [selectImageCamera] is a bool to select image from camera.
  final bool selectImageCamera;

  /// [selectImageGallery] is a bool to select image from gallery.
  final bool selectImageGallery;

  /// [selectFile] is a bool to select file.
  final bool selectFile;

  /// [allowedExtensions] is a list of allowed extensions.
  final List<String>? allowedExtensions;

  /// [fileType] is a FileType.
  final FileType? fileType;

  const SelectFile({
    required this.selectFileOrImage,
    required this.maxFileSize,
    required this.changeFileNameTo,
    required this.allowedExtensions,
    required this.imageQuality,
    required this.selectImageCamera,
    required this.selectImageGallery,
    required this.selectFile,
    required this.fileType,
    super.key,
  });

  @override
  State<SelectFile> createState() => _SelectFileState();
}

class _SelectFileState extends State<SelectFile> {
  bool isImage = true;
  bool isFiles = true;

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Padding(
      padding: const EdgeInsets.all(8),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if ((!Platform.isIOS && widget.selectFile) ||
              (Platform.isIOS && isFiles))
            TextButton.icon(
              style: TextButton.styleFrom(
                minimumSize: Size(size.width, 30),
              ),
              label: const Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  'Storage',
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.black,
                  ),
                ),
              ),
              onPressed: () async {
                Navigator.pop(context);
                try {
                  final file = await selectFileAsync(
                    maxSize: widget.maxFileSize,
                    changeFileNameTo: widget.changeFileNameTo,
                    allowedExtensions: widget.allowedExtensions,
                    fileType: widget.fileType,
                  );
                  return widget.selectFileOrImage(
                    path: file.path,
                    name: file.name,
                    error: file.error,
                  );
                } catch (e) {
                  if (!e.toString().contains("Null check")) {
                    if (Platform.isAndroid &&
                        await checkPermission(PermissionType.storage) ==
                            false) {
                      openAppSettings();
                    }
                    throw Exception(e);
                  }
                }
              },
              icon: const Icon(Icons.sd_storage),
            ),
          if (widget.selectImageGallery && isImage) ...{
            const SizedBox(height: 10),
            TextButton.icon(
              style: TextButton.styleFrom(
                minimumSize: Size(size.width, 30),
              ),
              label: const Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  'Gallery',
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.black,
                  ),
                ),
              ),
              onPressed: () async {
                try {
                  final image = await selectImageGalleryAsync(
                    maxSize: widget.maxFileSize,
                    changeFileNameTo: widget.changeFileNameTo,
                    imageQuality: widget.imageQuality,
                  );
                  return widget.selectFileOrImage(
                    path: image.path,
                    name: image.name,
                    error: image.error,
                  );
                } catch (e) {
                  if (!e.toString().contains("Null check")) {
                    if (Platform.isAndroid &&
                        await checkPermission(PermissionType.storage) ==
                            false) {
                      openAppSettings();
                    }
                    if (Platform.isIOS &&
                        await checkPermission(PermissionType.photos)) {
                      openAppSettings();
                    } else {
                      throw Exception(e);
                    }
                  }
                }
              },
              icon: const Icon(Icons.image),
            ),
          },
          if (widget.selectImageCamera && isImage) ...{
            const SizedBox(height: 10),
            TextButton.icon(
              style: TextButton.styleFrom(
                minimumSize: Size(size.width, 30),
              ),
              label: const Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  'Camera',
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.black,
                  ),
                ),
              ),
              onPressed: () async {
                try {
                  final image = await selectImageCameraAsync(
                    maxSize: widget.maxFileSize,
                    changeFileNameTo: widget.changeFileNameTo,
                    imageQuality: widget.imageQuality,
                  );
                  return widget.selectFileOrImage(
                    path: image.path,
                    name: image.name,
                    error: image.error,
                  );
                } catch (e) {
                  if (!e.toString().contains("Null check")) {
                    if (await checkPermission(PermissionType.camera)) {
                      throw Exception(e);
                    } else {
                      openAppSettings();
                    }
                  }
                }
              },
              icon: const Icon(Icons.camera_enhance),
            ),
          },
          const SizedBox(height: 30),
        ],
      ),
    );
  }

  @override
  void initState() {
    isImage = widget.allowedExtensions?.any(
          (element) =>
              element.toUpperCase().contains('JPG') ||
              element.toUpperCase().contains('JPEG') ||
              element.toUpperCase().contains('GIF') ||
              element.toUpperCase().contains('SVG') ||
              element.toUpperCase().contains('BMP'),
        ) ??
        true;
    isFiles = widget.allowedExtensions?.any(
          (element) =>
              !element.toUpperCase().contains('JPG') &&
              !element.toUpperCase().contains('JPEG') &&
              !element.toUpperCase().contains('GIF') &&
              !element.toUpperCase().contains('SVG') &&
              !element.toUpperCase().contains('BMP'),
        ) ??
        false;
    super.initState();
  }
}
