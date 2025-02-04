// ignore_for_file: public_member_api_docs, sort_constructors_first

import 'package:flutter/material.dart';
import 'package:tbib_file_uploader/src/widget/tbib_uploader_form_field.dart';
import 'package:tbib_file_uploader/tbib_file_uploader.dart';

class TBIBUploaderFile extends StatefulWidget {
  /// [validator] is a function that returns a [String] or null.
  final String? Function(Map<String, dynamic>?)? validator;

  /// [isHide] is a boolean to hide or show the widget.
  final bool isHide;

  /// [allowedExtensions] is a list of allowed file extensions.
  final List<FileExtensions>? allowedExtensions;

  /// [canDownloadFile] is a boolean to download file.
  final bool canDownloadFile;

  /// [showFileName] is a boolean to show file name.
  final bool showFileName;

  /// [changeFileNameTo] is a string to change file name.
  final String? changeFileNameTo;

  /// [displayNote] is a string to display note.
  final String? displayNote;

  /// [downloadFileOnPressed] is a function to download file.
  final void Function()? downloadFileOnPressed;

  /// [imageQuality] is a number between 0 and 100.
  final int? imageQuality;

  /// [maxFileSize] is a number by MB.
  final int? maxFileSize;

  /// [Select File] to select form storage.
  final bool selectFile;

  /// [Select Image Gallery] to select image from gallery.
  final bool selectImageGallery;

  /// [Select Image Camera] to select image from camera.
  final bool selectImageCamera;

  /// [selectMultiImage] to select multi image from gallery not support camera
  /// or files.
  final bool selectMultiImage;

  /// [selectedFile] is a function to select file.
  final void Function({List<String?>? name, List<String?>? path})? selectedFile;

  /// [children] is a list of widgets.
  final List<Widget>? children;

  /// [style] is a [TBIBUploaderStyle] to style the widget.
  final TBIBUploaderStyle? style;

  /// [autovalidateMode] is a [AutovalidateMode] to validate the widget.
  final AutovalidateMode autovalidateMode;

  /// [fileType] is a [FileType] to select file type.
  final FileType? fileType;

  /// [isSelectedFile]
  final bool isSelectedFile;

  const TBIBUploaderFile(
      {required this.selectedFile,
      super.key,
      this.validator,
      this.selectMultiImage = false,
      this.isHide = false,
      this.allowedExtensions,
      this.canDownloadFile = false,
      this.showFileName = false,
      this.changeFileNameTo,
      this.displayNote,
      this.downloadFileOnPressed,
      this.imageQuality,
      this.maxFileSize,
      this.selectFile = true,
      this.selectImageGallery = true,
      this.selectImageCamera = true,
      this.style,
      this.children,
      this.autovalidateMode = AutovalidateMode.onUserInteraction,
      this.fileType,
      this.isSelectedFile = false});

  @override
  State<TBIBUploaderFile> createState() => _UploaderFileState();
}

class _UploaderFileState extends State<TBIBUploaderFile> {
  // late final GlobalKey<FormFieldState<Map<String, dynamic>?>>? _formFieldKey =
  //     GlobalKey<FormFieldState<Map<String, dynamic>?>>();
  final _animatedContainerKey = GlobalKey();
  double height = 0;
  double width = 0;
  bool isFirst = true;

  // static bool _refresh = false;
  @override
  Widget build(BuildContext context) {
    return AnimatedOpacity(
      key: _animatedContainerKey,
      opacity: widget.isHide ? 0 : 1,
      duration: const Duration(milliseconds: 500),
      child: AnimatedCrossFade(
        crossFadeState: widget.isHide && isFirst
            ? CrossFadeState.showSecond
            : CrossFadeState.showFirst,
        duration: const Duration(milliseconds: 500),
        secondChild: const SizedBox.shrink(),
        firstChild: Column(
          children: [
            if (widget.isHide) ...{
              const SizedBox.shrink(),
            } else ...{
              TBIBUploaderFormField(
                //  key: _formFieldKey,
                isSelectedFile: widget.isSelectedFile,
                validator: widget.isHide ? null : widget.validator,
                allowedExtensions: widget.allowedExtensions,
                canDownloadFile:
                    widget.selectMultiImage ? false : widget.canDownloadFile,
                showFileName: widget.showFileName,
                changeFileNameTo: widget.changeFileNameTo,
                autovalidateMode: widget.autovalidateMode,
                displayNote:
                    widget.selectMultiImage ? null : widget.displayNote,
                downloadFileOnPressed: widget.selectMultiImage
                    ? null
                    : widget.downloadFileOnPressed,
                imageQuality: widget.imageQuality,
                maxFileSize: widget.maxFileSize,
                selectFile: widget.selectMultiImage ? false : widget.selectFile,
                fileType: widget.fileType,
                selectImageCamera:
                    widget.selectMultiImage ? false : widget.selectImageCamera,
                selectImageGallery:
                    widget.selectMultiImage ? true : widget.selectImageGallery,
                selectedFile: widget.selectedFile,
                style: widget.style,
              ),
              if (widget.children != null)
                ...widget.children!.map(
                  (e) => Padding(
                    padding: widget.style?.padding ?? const EdgeInsets.all(10),
                    child: e,
                  ),
                ),
            },
          ],
        ),
      ),
    );
  }

  @override
  void initState() {
    // hideWidth = widget.isHide;
    // super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (isFirst) {
        height = _animatedContainerKey.currentContext!.size!.height;
        width = _animatedContainerKey.currentContext!.size!.width;
        isFirst = false;
        setState(() {});
      }
    });

    super.initState();
  }
}
