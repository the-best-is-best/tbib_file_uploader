import 'package:flutter/material.dart';
import 'package:tbib_file_uploader/gen/fonts/tbib_icons.dart';
import 'package:tbib_file_uploader/tbib_file_uploader.dart';

Future<void> _selectFileOrImage(
  BuildContext context,
  int? maxFileSize,
  FormFieldState<Map<String, dynamic>?> state,
  void Function({List<String?>? name, List<String?>? path})? selectedFile,
  String? changeFileNameTo,
  List<String>? allowedExtensions,
  int? imageQuality,
  bool selectFile,
  bool selectImageGallery,
  bool selectImageCamera,
  FileType? fileType,
  bool selectMultiImageBool,
) async {
  if (selectMultiImageBool) {
    await selectMultiImage(
      context: context,
      selectedFiles: ({name, path}) {
        if (name != null && path != null) {
          state.didChange({
            'path': path,
            'name': name,
            'error': null,
            'isHide': false,
            'showError': true,
          });
          selectedFile?.call(name: name, path: path);
        } else {
          // Handle cancel by clearing the fields
          state.didChange({
            'path': null,
            'name': null,
            'error': null,
            'isHide': false,
            'showError': false,
          });
          selectedFile?.call(name: null, path: null);
        }
      },
    );
    return;
  }
  final selected = await showModalBottomSheet<String?>(
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
          if (path != null && name != null) {
            state.didChange({
              'path': path,
              'name': name,
              'error': error,
              'isHide': false,
              'showError': true,
            });
            selectedFile?.call(name: [name], path: [path]);
          } else {
            // Handle cancel by clearing the fields
            state.didChange({
              'path': null,
              'name': null,
              'error': null,
              'isHide': false,
              'showError': false,
            });
            selectedFile?.call(name: null, path: null);
          }
        },
      );
    },
  );
}

/// A [FormField] that contains a [FileUploader].
class TBIBUploaderFormField extends FormField<Map<String, dynamic>?> {
  /// Select File data
  final void Function({List<String?>? path, List<String?>? name})? selectedFile;

  /// [downloadFileOnPressed] if [canDownloadFile] is true, you can download f
  /// ile after upload.
  final void Function()? downloadFileOnPressed;

  /// [allowedExtensions] if use select from storage will display only this extensions.
  final List<FileExtensions>? allowedExtensions;

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

  /// Creates a [TBIBUploaderFormField] that contains a [FileUploader].
  TBIBUploaderFormField({
    required this.selectedFile,
    this.changeFileNameTo,
    this.maxFileSize,
    this.downloadFileOnPressed,
    this.allowedExtensions,
    this.imageQuality,
    this.fileType,
    this.displayNote,
    this.style,
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
            final textEditingController = TextEditingController();
            var data = <String, dynamic>{
              'path': null,
              'name': null,
              'error': null,
              'showError': false,
            };
            data = formState.value ?? data;

            if (formState.hasError) {
              data['error'] = data['error'] ?? formState.errorText;
              data['showError'] = true;
              textEditingController.text = '';
            } else {
              if (!formState.hasError &&
                  formState.value != null &&
                  formState.value!['showError'] == true) {
                textEditingController.text = data['path'] == null
                    ? style?.labelText ?? 'Please Select File'
                    : style?.selectMultiImage == true
                        ? '${style?.selectFile ?? 'File Selected'} (${(data['path'] as List<String>).length})'
                        : changeFileNameTo != null && showFileName
                            ? (data['path'] as List<String>)[0].split('/').last
                            : style?.selectFile ?? 'File Selected';
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
                        style: style?.selectFileStyle ??
                            const TextStyle(color: Colors.black),
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
                          labelText: style?.labelText,
                          hintText: style?.hintText ?? 'Select File',
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
                                    Icon(
                                      TbibIcons.fileUpload,
                                      size: 20,
                                      color: style?.iconColor ?? Colors.black,
                                    ),
                                onPressed: () async {
                                  await _selectFileOrImage(
                                    context,
                                    maxFileSize,
                                    formState,
                                    selectedFile,
                                    changeFileNameTo,
                                    allowedExtensions
                                        ?.map((e) => e.name)
                                        .toList(),
                                    imageQuality,
                                    selectFile,
                                    selectImageGallery,
                                    selectImageCamera,
                                    fileType,
                                    style?.selectMultiImage ?? false,
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
                                            ? style?.iconColor ?? Colors.black
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
}
