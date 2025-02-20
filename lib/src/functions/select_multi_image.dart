import 'dart:io';

import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';

/// To Select Multi Image From Gallery
Future<void> selectMultiImage({
  required BuildContext context,
  required void Function({List<String>? name, List<String>? path})
      selectedFiles,
  // required bool selectFile,
  // required bool selectImageCamera,
  // required bool selectImageGallery,
  // int? maxFileSize,
  // String? changeFileNameTo,
  // List<FileExtensions>? allowedExtensions,
  int? imageQuality,
  // FileType? fileType,
}) async {
  if (Platform.isAndroid) {
    final deviceInfo = await DeviceInfoPlugin().androidInfo;
    if (deviceInfo.version.sdkInt > 30) {
      bool checkPermission;
      if (await Permission.photos.isDenied) {
        await Permission.photos.request();
      }
      checkPermission = await Permission.photos.isGranted;
      if (!checkPermission) {
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
    // else {
    //   bool checkPermission;
    //   if (await Permission.storage.isDenied) {
    //     await Permission.storage.request();
    //   }
    //   checkPermission = await Permission.storage.isGranted;
    //   if (!checkPermission) {
    //     var status = await Permission.storage.isGranted;
    //     if (!status) {
    //       status = await Permission.storage.request().isGranted;
    //     }
    //     if (!status) {
    //       // show snakebar error permission
    //       ScaffoldMessenger.of(context).showSnackBar(
    //         SnackBar(
    //           backgroundColor: Colors.red,
    //           behavior: SnackBarBehavior.floating,
    //           shape: RoundedRectangleBorder(
    //             borderRadius: BorderRadius.circular(10),
    //           ),
    //           content: const Text(
    //             'Permission denied to access photos',
    //           ),
    //         ),
    //       );

    //       Future.delayed(
    //         const Duration(seconds: 2),
    //         openAppSettings,
    //       );

    //       return;
    //     }
    //   }
    // }
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
          content: const Text('Permission denied to access photo'),
        ),
      );

      Future.delayed(
        const Duration(seconds: 2),
        openAppSettings,
      );

      return;
    }
  }

  final picker = ImagePicker();
  final images = await picker.pickMultiImage(
    imageQuality: imageQuality,
  );
  if (images.isEmpty) return selectedFiles(path: null, name: null);
  final paths = images.map((e) => e.path).toList();
  final names = images.map((e) => e.name).toList();
  selectedFiles(path: paths, name: names);
}
