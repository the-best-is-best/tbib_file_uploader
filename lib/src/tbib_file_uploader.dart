import 'dart:convert';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:tbib_file_uploader/gen/fonts/TBIBIcons.dart';
import 'package:tbib_file_uploader/tbib_file_uploader.dart';

/// A [FormField] that contains a [FileUploader].
class TBIBFormField extends FormField<String?> {
  /// Creates a [TBIBFormField] that contains a [FileUploader].
  TBIBFormField({
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
    //this.supportNull = true,
    // this.setErrorText,
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
              // if (setErrorText != null) {
              //   data['error'] = setErrorText;
              // }

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
                  children: [
                    TextFormField(
                      controller: textEditingController,
                      keyboardType: TextInputType.none,
                      decoration: InputDecoration(
                        errorText: (data['error'].toString().contains('null')
                            ? null
                            : data['error'].toString()),
                        labelText: style?.labelText ?? 'Select File',
                        labelStyle: style?.labelStyle ??
                            const TextStyle(
                              color: Colors.black,
                              fontSize: 16,
                            ),
                        suffixIcon: IconButton(
                          icon: style?.fileUploaderIcon ??
                              const Icon(TBIBIcons.fileUpload),
                          onPressed: () async {
                            await showModalBottomSheet<String>(
                              context: context,
                              builder: (context) {
                                return SelectFile(
                                  maxFileSize: maxFileSize,
                                  selectFileOrImage: ({path, name, error}) {
                                    // log('path $path name $name error $error');
                                    if (path != null || error != null) {
                                      state.didChange(
                                        json.encode({
                                          'path': path,
                                          'name': name,
                                          'error': error
                                        }),
                                      );
                                    } else {
                                      state.didChange(null);
                                    }
                                    selectedFile?.call(
                                      path: path,
                                      name: name,
                                    );
                                  },
                                );
                              },
                            );
                          },
                        ),
                      ),
                    ),
                  ],
                );
              },
            );
          },
        );

  /// File Uploader Style
  final TBIBUploaderStyle? style;

  /// Select File data
  final void Function({String? path, String? name})? selectedFile;

  /// Change file name after selected
  final String? changeFileNameTo;

  /// [maxFileSize] by MB.
  final int? maxFileSize;

  /// add your error text
  //final String? setErrorText;

  //final bool supportNull;
}
