import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:tbib_file_uploader/gen/fonts/tbib_icons.dart';
import 'package:tbib_file_uploader/tbib_file_uploader.dart';

/// A [FormField] that contains a [FileUploader].
class TBIBUploaderFormField extends FormField<Map<String, dynamic>?> {
  /// Creates a [TBIBUploaderFormField] that contains a [FileUploader].
  TBIBUploaderFormField({
    required this.style,
    required this.selectedFile,
    required this.changeFileNameTo,
    required this.maxFileSize,
    required this.downloadFileOnPressed,
    required this.displayNote,
    required this.allowedExtensions,
    required this.imageQuality,
    required this.fileType,
    this.canDownloadFile = false,
    this.showFileName = false,
    this.selectFile = true,
    this.selectImageCamera = true,
    this.selectImageGallery = true,
    super.key,
    // super.onSaved,
    super.validator,
    super.autovalidateMode = AutovalidateMode.onUserInteraction,
    super.enabled = true,
    super.restorationId,
  }) : super(
          builder: (FormFieldState<Map<String, dynamic>?> formState) {
            final tbibUplaoderFocusNode = FocusNode();
            tbibUplaoderFocusNode.addListener(() {
              if (tbibUplaoderFocusNode.hasFocus) {
                tbibUplaoderFocusNode.unfocus();
              }
            });
            var textEditingController = TextEditingController();
            var data = <String, dynamic>{
              'path': null,
              'name': null,
              'error': null,
              'showError': false
            };
            data = formState.value ?? data;
            log('error  ${data['error']}');
            if (formState.hasError) {
              data['error'] = data['error'] ?? formState.errorText;
              data['showError'] = true;
              textEditingController.text = '';
            } else {
              if (!formState.hasError &&
                  formState.value != null &&
                  formState.value!['showError'] == true) {
                textEditingController = TextEditingController(
                  text: data['path'] != null
                      ? showFileName && changeFileNameTo != null
                          ? (data['path'] as String).split('/').last
                          : 'File Selected'
                      : '',
                );
              }
            }
            return Padding(
              padding: style?.padding ?? const EdgeInsets.all(10),
              child: Builder(
                builder: (context) {
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      TextFormField(
                        focusNode: tbibUplaoderFocusNode,
                        controller: textEditingController,
                        keyboardType: TextInputType.none,
                        decoration: InputDecoration(
                          border: style == null
                              ? null
                              : style.hideBorder
                                  ? InputBorder.none
                                  : null,
                          enabledBorder: style == null
                              ? null
                              : style.hideBorder
                                  ? InputBorder.none
                                  : null,
                          focusedBorder: style == null
                              ? null
                              : style.hideBorder
                                  ? InputBorder.none
                                  : null,
                          disabledBorder: style == null
                              ? null
                              : style.hideBorder
                                  ? InputBorder.none
                                  : null,
                          focusedErrorBorder: style == null
                              ? null
                              : style.hideBorder
                                  ? InputBorder.none
                                  : null,
                          errorText: data['showError'] == false
                              ? null
                              : (data['error'].toString().contains('null')
                                  ? null
                                  : data['error'].toString()),
                          labelText: style?.labelText ?? 'Select File',
                          hintText: 'Select File',
                          labelStyle: style?.labelStyle ??
                              const TextStyle(
                                color: Colors.black,
                                fontSize: 16,
                              ),
                          suffixIcon: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              IconButton(
                                icon: style?.fileUploaderIcon ??
                                    const Icon(
                                      TbibIcons.fileUpload,
                                      size: 20,
                                      color: Colors.black,
                                    ),
                                onPressed: () async {
                                  await _selectFileOrImage(
                                    context,
                                    maxFileSize,
                                    formState,
                                    selectedFile,
                                    changeFileNameTo,
                                    allowedExtensions,
                                    imageQuality,
                                    selectFile,
                                    selectImageGallery,
                                    selectImageCamera,
                                    fileType,
                                  );
                                },
                              ),
                              if (canDownloadFile) ...{
                                IconButton(
                                  icon: style?.fileDownloadIcon ??
                                      Icon(
                                        TbibIcons.fileDownload,
                                        size: 20,
                                        color: downloadFileOnPressed != null
                                            ? Colors.black
                                            : null,
                                      ),
                                  onPressed: downloadFileOnPressed,
                                ),
                              },
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(height: 10),
                      if (displayNote == null) ...{
                        if (maxFileSize != null ||
                            allowedExtensions != null) ...{
                          Padding(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 20,
                            ),
                            child: Text(
                              """Note: ${maxFileSize != null ? 'File size should be less than $maxFileSize MB' : ''}${maxFileSize != null && allowedExtensions != null ? ' and' : ''} ${allowedExtensions == null || allowedExtensions.isEmpty ? '' : 'file type should be ${allowedExtensions.join(' , ')}'}""",
                              style: style?.noteStyle ??
                                  const TextStyle(
                                    color: Colors.black,
                                    fontSize: 12,
                                  ),
                            ),
                          ),
                        },
                      },
                      if (displayNote != null && displayNote.isNotEmpty) ...{
                        Padding(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 20,
                          ),
                          child: Text(
                            displayNote,
                            style: style?.noteStyle ??
                                const TextStyle(
                                  color: Colors.black,
                                  fontSize: 12,
                                ),
                          ),
                        ),
                      },
                    ],
                  );
                },
              ),
            );
          },
        );

  /// Select File data
  final void Function({String? path, String? name})? selectedFile;

  /// [downloadFileOnPressed] if [canDownloadFile] is true, you can download f
  /// ile after upload.
  final void Function()? downloadFileOnPressed;

  /// [allowedExtensions] if use select from storage will display only this extensions.
  final List<String>? allowedExtensions;

  /// [canDownloadFile] if true, you can download file after upload.
  final bool canDownloadFile;

  /// [changeFileNameTo] Change file name after selected
  final String? changeFileNameTo;

  /// [displayNote] to display note.
  final String? displayNote;

  /// [imageQuality] is a number between 0 and 100.
  final int? imageQuality;

  /// [maxFileSize] by MB.
  final int? maxFileSize;

  /// [showFileName] is a bool to show file name work
  /// if you change file name from [changeFileNameTo].
  final bool showFileName;

  /// File Uploader Style
  final TBIBUploaderStyle? style;

  /// [fileType] is a FileType to select file type.
  final FileType? fileType;

  /// [selectFile] is a bool to select file.
  final bool selectFile;

  /// [selectImageGallery] is a bool to select image from gallery.
  final bool selectImageGallery;

  /// [selectImageCamera] is a bool to select image from camera.
  final bool selectImageCamera;
}

Future<void> _selectFileOrImage(
  BuildContext context,
  int? maxFileSize,
  FormFieldState<Map<String, dynamic>?> state,
  void Function({String? name, String? path})? selectedFile,
  String? changeFileNameTo,
  List<String>? allowedExtensions,
  int? imageQuality,
  bool selectFile,
  bool selectImageGallery,
  bool selectImageCamera,
  FileType? fileType,
) async {
  await showModalBottomSheet<String>(
    context: context,
    builder: (context) {
      return SelectFile(
        selectFile: selectFile,
        selectImageGallery: selectImageGallery,
        selectImageCamera: selectImageCamera,
        imageQuality: imageQuality,
        maxFileSize: maxFileSize,
        changeFileNameTo: changeFileNameTo,
        allowedExtensions: allowedExtensions,
        fileType: fileType,
        selectFileOrImage: ({path, name, error}) {
          state.didChange({
            'path': path,
            'name': name,
            'error': error,
            'isHide': false,
            'showError': true
          });

          selectedFile?.call(name: name, path: path);
        },
      );
    },
  );
}
