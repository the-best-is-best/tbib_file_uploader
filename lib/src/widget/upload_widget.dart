import 'dart:async';
import 'dart:convert';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:tbib_file_uploader/gen/fonts/tbib_icons.dart';
import 'package:tbib_file_uploader/tbib_file_uploader.dart';

/// A [FormField] that contains a [FileUploader].
class TBIBUploaderFormField extends FormField<Map<String, dynamic>?> {
  /// Creates a [TBIBUploaderFormField] that contains a [FileUploader].
  TBIBUploaderFormField({
    required this.state,
    super.key,
    // super.onSaved,
    super.validator,
    super.initialValue,
    // super.autovalidateMode = AutovalidateMode.disabled,
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
    this.showFileName = false,
    this.imageQuality,
    this.selectImageOnly = false,
    this.children = const [],
    this.hide = false,
  }) : super(
          builder: (FormFieldState<Map<String, dynamic>?> formState) {
            state(state: formState);
            var textEditingController = TextEditingController();
            final data = <String, dynamic>{
              'path': null,
              'name': null,
              'error': null,
              'isHide': hide
            };
            WidgetsBinding.instance.addPostFrameCallback((_) {
              if (_isFirst) {
                _hideWidthWidget = hide;
                _hideFromFunction = hide;
                final renderBox =
                    _widgetKey.currentContext?.findRenderObject() as RenderBox;
                _heightWidget = renderBox.size.height;
                _widthWidget = renderBox.size.width;
                _isFirst = false;

                formState.didChange(data);
              } else {}
            });
            // log('form state ${formState.value}');
            if (formState.value != null && formState.value!['isHide'] == true) {
            } else {
              _tbibUplaoderFocusNode.addListener(() {
                if (_tbibUplaoderFocusNode.hasFocus) {
                  FocusManager.instance.primaryFocus?.unfocus();
                }
              });

              if (formState.hasError) {
                data['error'] = formState.errorText;
              }
              // else {
              //   // log('message ${state.value}');
              //   log('form value is ${formState.value}');
              //   if (formState.value != null) {
              //     if (formState.value is Map) {
              //       data = formState.value;
              //     }
              //   }
              // }
              log('path ${data['path'] != null ? showFileName && changeFileNameTo != null ? (data['path'] as String).split('/').last : 'File Selected' : ''}');
              textEditingController = TextEditingController(
                text: data['path'] != null
                    ? showFileName && changeFileNameTo != null
                        ? (data['path'] as String).split('/').last
                        : 'File Selected'
                    : '',
              );
            }
            log('error ${data['error']}');

            return AnimatedOpacity(
              key: _widgetKey,
              opacity: (hide && _isFirst)
                  ? 0
                  : _hideFromFunction
                      ? 0
                      : 1,
              duration: const Duration(milliseconds: 300),
              child: NotificationListener(
                onNotification: (SizeChangedLayoutNotification notification) {
                  return true;
                },
                child: SizeChangedLayoutNotifier(
                  child: Builder(
                    builder: (context) {
                      log('hideWidthWidget $_hideWidthWidget - widgetErrors $widgetErrors');
                      return AnimatedContainer(
                        key: _animatedContainerKey,
                        duration: const Duration(milliseconds: 300),
                        height: _isFirst
                            ? null
                            : (hide && _isFirst)
                                ? 0
                                : _hideFromFunction
                                    ? 0
                                    : _heightWidget +
                                        (30 * widgetErrors) +
                                        (data['error'] != null ? 30 : 0),
                        width: _isFirst
                            ? null
                            : (hide && _isFirst)
                                ? 0
                                : _hideWidthWidget && _hideFromFunction
                                    ? 0
                                    : _widthWidget,
                        child: Padding(
                          padding: style?.padding ??
                              const EdgeInsets.all(10) +
                                  const EdgeInsets.only(top: 20),
                          child: Builder(
                            builder: (context) {
                              return Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  TextFormField(
                                    focusNode: _tbibUplaoderFocusNode,
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
                                      errorText: (data['error']
                                              .toString()
                                              .contains('null')
                                          ? null
                                          : data['error'].toString()),
                                      labelText:
                                          style?.labelText ?? 'Select File',
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
                                                formState,
                                                selectedFile,
                                                changeFileNameTo,
                                                allowedExtensions,
                                                imageQuality,
                                                selectImageOnly,
                                              );
                                            },
                                          ),
                                          if (canDownloadFile) ...{
                                            IconButton(
                                              icon: style?.fileDownloadIcon ??
                                                  Icon(
                                                    TbibIcons.fileDownload,
                                                    size: 20,
                                                    color:
                                                        downloadFileOnPressed !=
                                                                null
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
                                  Column(
                                    children: children.asMap().entries.map((e) {
                                      return Padding(
                                        padding: const EdgeInsets.symmetric(
                                          vertical: 20,
                                        ),
                                        child: (e.value is TextFormField)
                                            ? Builder(
                                                builder: (context) {
                                                  final isValid =
                                                      (e.value as TextFormField)
                                                              .validator
                                                              ?.call(
                                                                (e.value
                                                                        as TextFormField)
                                                                    .controller!
                                                                    .text,
                                                              ) ==
                                                          null;
                                                  log('is children valid $isValid');
                                                  if (!isValid) {
                                                    if (widgetErrors <
                                                        children.length) {
                                                      widgetErrors += 1;
                                                      WidgetsBinding.instance
                                                          .addPostFrameCallback(
                                                              (timeStamp) {
                                                        formState.didChange(
                                                          formState.value,
                                                        );
                                                      });
                                                    }
                                                  } else {
                                                    if (widgetErrors > 0) {
                                                      widgetErrors -= 1;
                                                      WidgetsBinding.instance
                                                          .addPostFrameCallback(
                                                              (timeStamp) {
                                                        formState.didChange(
                                                          formState.value,
                                                        );
                                                      });
                                                    }
                                                  }
                                                  return e.value
                                                      as TextFormField;
                                                },
                                              )
                                            : e.value,
                                      );
                                    }).toList(),
                                  )
                                ],
                              );
                            },
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ),
            );
          },
        );
  static bool _isFirst = true;
  static final _tbibUplaoderFocusNode = FocusNode();
  static final _widgetKey = GlobalKey();
  static final _animatedContainerKey = GlobalKey();
  static int widgetErrors = 0;

  static late double _heightWidget;
  static late double _widthWidget;
  static bool _hideWidthWidget = false;

  static Future<void> _selectFileOrImage(
    BuildContext context,
    int? maxFileSize,
    FormFieldState<Map<String, dynamic>?> state,
    void Function({String? name, String? path})? selectedFile,
    String? changeFileNameTo,
    List<String>? allowedExtensions,
    int? imageQuality,
    bool selectImageOnly,
  ) async {
    await showModalBottomSheet<String>(
      context: context,
      builder: (context) {
        return SelectFile(
          selectImageOnly: selectImageOnly,
          imageQuality: imageQuality,
          maxFileSize: maxFileSize,
          changeFileNameTo: changeFileNameTo,
          allowedExtensions: allowedExtensions,
          selectFileOrImage: ({path, name, error}) {
            // log('path $path name $name error $error');
            if (path != null || error != null) {
              state.didChange(
                json.decode(
                  {'path': path, 'name': name, 'error': error}.toString(),
                ) as Map<String, dynamic>,
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

  static bool _hideFromFunction = false;

  /// [hideOrShowWidget] is a function to hide or show widget by button.
  static Future<void> hideOrShowWidget(
    FormFieldState<Map<String, dynamic>?> state,
  ) async {
    if (!_hideFromFunction) {
      _hideFromFunction = !_hideFromFunction;
      state.didChange({'isHide': true});
      await Future.delayed(const Duration(milliseconds: 500), () {
        _hideWidthWidget = _hideFromFunction;
        state.didChange({'isHide': true});
      });
    } else {
      _hideWidthWidget = !_hideWidthWidget;
      state.didChange({'isHide': false});

      await Future.delayed(const Duration(milliseconds: 500), () {
        _hideFromFunction = _hideWidthWidget;
        state.didChange({'isHide': false});
      });
    }
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

  /// [showFileName] is a bool to show file name work
  /// if you change file name from [changeFileNameTo].
  final bool showFileName;

  /// [imageQuality] is a number between 0 and 100.
  final int? imageQuality;

  /// [selectImageOnly] is a bool to select image only.
  final bool selectImageOnly;

  /// [children] is a list of widgets to display.
  final List<Widget> children;

  /// [hide] is a bool to hide the widget work in init.
  final bool hide;

  final void Function({required FormFieldState<Map<String, dynamic>?> state})
      state;
}
