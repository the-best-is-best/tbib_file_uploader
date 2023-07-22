import 'package:flutter/material.dart';
import 'package:tbib_file_uploader/src/functions/select_file.dart';
import 'package:tbib_file_uploader/src/functions/select_image_camera.dart';

/// A [Select File] that contains a [FileUploader].
class SelectFile extends StatefulWidget {
  /// Creates a [TBIBFormField] that contains a [FileUploader].

  const SelectFile({
    required this.selectFileOrImage,
    super.key,
    this.maxFileSize,
    this.changeFileNameTo,
    this.allowedExtensions,
  });

  /// [selectFileOrImage] is a function that returns a [FileUploader].
  final void Function({
    required String? path,
    required String? name,
    required String? error,
  }) selectFileOrImage;

  /// [maxFileSize] by MB.
  final int? maxFileSize;
  final String? changeFileNameTo;
  final List<String>? allowedExtensions;

  @override
  State<SelectFile> createState() => _SelectFileState();
}

class _SelectFileState extends State<SelectFile> {
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
                  final file = await selectFileAsync(
                      maxSize: widget.maxFileSize,
                      changeFileNameTo: widget.changeFileNameTo,
                      allowedExtensions: widget.allowedExtensions);
                  return widget.selectFileOrImage(
                    path: file.path,
                    name: file.name,
                    error: file.error,
                  );
                },
                icon: const Icon(Icons.sd_storage),
              ),
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

                  final image = await selectImageGalleryAsync(
                    maxSize: widget.maxFileSize,
                    changeFileNameTo: widget.changeFileNameTo,
                  );
                  return widget.selectFileOrImage(
                    path: image.path,
                    name: image.name,
                    error: image.error,
                  );
                },
                icon: const Icon(Icons.image),
              ),
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

                  final image = await selectImageCameraAsync(
                      maxSize: widget.maxFileSize,
                      changeFileNameTo: widget.changeFileNameTo);
                  return widget.selectFileOrImage(
                    path: image.path,
                    name: image.name,
                    error: image.error,
                  );
                },
                icon: const Icon(Icons.camera_enhance),
              ),
              const SizedBox(height: 30),
            ],
          ),
        );
      },
    );
  }
}
