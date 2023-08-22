import 'dart:developer';
import 'dart:io';

import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:tbib_file_uploader/src/functions/select_file.dart';
import 'package:tbib_file_uploader/src/functions/select_image_camera.dart';
import 'package:tbib_file_uploader/tbib_file_uploader.dart';

/// A [Select File] that contains a [FileUploader].
class SelectFile extends StatefulWidget {
  /// Creates a [TBIBFormField] that contains a [FileUploader].

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

  // /// [selectImageOnly] is a bool to select image only.
  // final bool selectImageOnly;
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

  @override
  State<SelectFile> createState() => _SelectFileState();
}

class _SelectFileState extends State<SelectFile> {
  bool isImage = true;
  bool isFiles = true;
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
    log('is file $isFiles');
    log(widget.allowedExtensions?.first ?? '');
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Builder(
      builder: (context) {
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
                  // style: TextButton.styleFrom(
                  //   iconColor: Colors.
                  // ),
                  onPressed: () async {
                    Navigator.pop(context);
                    if (Platform.isAndroid) {
                      final deviceInfo = await DeviceInfoPlugin().androidInfo;
                      if (deviceInfo.version.sdkInt < 30) {
                        bool checkPermission;
                        if (await Permission.storage.isDenied) {
                          await Permission.storage.request();
                        }
                        checkPermission = await Permission.storage.isGranted;
                        if (!checkPermission) {
                          var status = await Permission.storage.isGranted;
                          if (!status) {
                            status =
                                await Permission.storage.request().isGranted;
                          }
                          if (!status) {
                            // show snakebar error permission
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                backgroundColor: Colors.red,
                                behavior: SnackBarBehavior.floating,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                content: const Text(
                                  'Permission denied to access storage',
                                ),
                              ),
                            );

                            Future.delayed(
                              const Duration(seconds: 2),
                              openAppSettings,
                            );

                            return;
                          }
                        }
                      }
                    }
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
                    Navigator.pop(context);
                    if (Platform.isAndroid) {
                      final deviceInfo = await DeviceInfoPlugin().androidInfo;
                      if (deviceInfo.version.sdkInt >= 30) {
                        bool checkPermission;
                        if (await Permission.photos.isDenied) {
                          await Permission.photos.request();
                        }
                        checkPermission = await Permission.photos.isGranted;
                        if (!checkPermission) {
                          var status = await Permission.photos.isGranted;
                          if (!status) {
                            status =
                                await Permission.photos.request().isGranted;
                          }
                          if (!status) {
                            // show snakebar error permission
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                backgroundColor: Colors.red,
                                behavior: SnackBarBehavior.floating,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                content: const Text(
                                  'Permission denied to access photos',
                                ),
                              ),
                            );

                            Future.delayed(
                              const Duration(seconds: 2),
                              openAppSettings,
                            );

                            return;
                          }
                        }
                      } else {
                        bool checkPermission;
                        if (await Permission.photos.isDenied) {
                          await Permission.photos.request();
                        }
                        checkPermission = await Permission.storage.isGranted;
                        if (!checkPermission) {
                          var status = await Permission.storage.isGranted;
                          if (!status) {
                            status =
                                await Permission.storage.request().isGranted;
                          }
                          if (!status) {
                            // show snakebar error permission
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                backgroundColor: Colors.red,
                                behavior: SnackBarBehavior.floating,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                content: const Text(
                                  'Permission denied to access photos',
                                ),
                              ),
                            );

                            Future.delayed(
                              const Duration(seconds: 2),
                              openAppSettings,
                            );

                            return;
                          }
                        }
                      }
                    } else {
                      var status = await Permission.photos.isGranted;
                      if (!status) {
                        status = await Permission.photos.request().isGranted;
                      }
                      if (!status) {
                        // show snakebar error permission
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            backgroundColor: Colors.red,
                            behavior: SnackBarBehavior.floating,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                            content:
                                const Text('Permission denied to access photo'),
                          ),
                        );

                        Future.delayed(
                          const Duration(seconds: 2),
                          openAppSettings,
                        );

                        return;
                      }
                    }

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
                    Navigator.pop(context);
                    var status = await Permission.camera.isGranted;
                    if (!status) {
                      status = await Permission.camera.request().isGranted;
                    }
                    if (!status) {
                      // show snakebar error permission
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          backgroundColor: Colors.red,
                          behavior: SnackBarBehavior.floating,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          content:
                              const Text('Permission denied to access camera'),
                        ),
                      );

                      Future.delayed(
                        const Duration(seconds: 2),
                        openAppSettings,
                      );

                      return;
                    }

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
                  },
                  icon: const Icon(Icons.camera_enhance),
                ),
              },
              const SizedBox(height: 30),
            ],
          ),
        );
      },
    );
  }
}
