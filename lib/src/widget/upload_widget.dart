import 'dart:convert';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:tbib_file_uploader/gen/fonts/tbib_icons.dart';
import 'package:tbib_file_uploader/tbib_file_uploader.dart';

/// A [FormField] that contains a [FileUploader].
class TBIBUploaderFormField extends FormField<String?> {
  /// Creates a [TBIBUploaderFormField] that contains a [FileUploader].
  TBIBUploaderFormField({
    super.key,
    // super.onSaved,
    super.validator,
    super.initialValue,
    //  super.autovalidateMode = AutovalidateMode.disabled,
    super.enabled = true,
    super.restorationId,
    this.style,
    this.selectedFile,
    this.changeFileNameTo,
    this.maxFileSize,
    this.canDownloadFile = false,
    this.downloadFileOnPressed,
    this.displayNote,
    this.allowedExtensions,
  }) : super(
          builder: (FormFieldState<String?> state) {
            var data = <dynamic, dynamic>{
              'path': null,
              'name': null,
              'error': null,
            };
            if (state.hasError) {
              data['error'] = state.errorText;
            } else {
              log('message ${state.value}');

              if (state.value != null) {
                data = json.decode(state.value!) as Map<dynamic, dynamic>;
              }
            }
            final textEditingController = TextEditingController(
              text: data['path'] != null ? 'File Selected' : '',
            );
            return Builder(
              builder: (context) {
                FocusScope.of(context).unfocus();
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    TextFormField(
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
                        errorText: (data['error'].toString().contains('null')
                            ? null
                            : data['error'].toString()),
                        labelText: style?.labelText ?? 'Select File',
                        hintText: 'Select FileS',
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
                                    state,
                                    selectedFile,
                                    changeFileNameTo,
                                    allowedExtensions);
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
                    if (displayNote != null) ...{
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20),
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
            );
          },
        );

  static Future<void> _selectFileOrImage(
    BuildContext context,
    int? maxFileSize,
    FormFieldState<String?> state,
    void Function({String? name, String? path})? selectedFile,
    String? changeFileNameTo,
    List<String>? allowedExtensions,
  ) async {
    await showModalBottomSheet<String>(
      context: context,
      builder: (context) {
        return SelectFile(
          maxFileSize: maxFileSize,
          changeFileNameTo: changeFileNameTo,
          allowedExtensions: allowedExtensions,
          selectFileOrImage: ({path, name, error}) {
            // log('path $path name $name error $error');
            if (path != null || error != null) {
              state.didChange(
                json.encode({'path': path, 'name': name, 'error': error}),
              );
            } else {
              state.didChange(null);
            }
            selectedFile?.call(name: name, path: path);
          },
        );
      },
    );
  }

  /// File Uploader Style
  final TBIBUploaderStyle? style;

  /// Select File data
  final void Function({String? path, String? name})? selectedFile;

  /// [changeFileNameTo] Change file name after selected
  final String? changeFileNameTo;

  /// [maxFileSize] by MB.
  final int? maxFileSize;

  /// [canDownloadFile] if true, you can download file after upload.
  final bool canDownloadFile;

  /// [downloadFileOnPressed] if [canDownloadFile] is true, you can download f
  /// ile after upload.
  final void Function()? downloadFileOnPressed;

  /// [displayNote] to display note.
  final String? displayNote;

  /// [allowedExtensions] if use select from storage will display only this extensions.
  final List<String>? allowedExtensions;

  // /// [selectDate] if true you need use [selectedDate].
  // final bool selectDate;

  // /// [selectedDate] if true you need use [selectedDate].
  // final bool selectTime;

  // /// [selectedDate] to select date and time for file.
  // final void Function(DateTime? date)? selectedDate;
}
