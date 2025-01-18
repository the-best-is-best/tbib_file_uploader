import 'package:flutter/material.dart';

/// File Uploader Style
class TBIBUploaderStyle {
  /// Label Text
  final String? labelText;

  /// Label Style
  final TextStyle? labelStyle;

  /// hint text for text field
  final String? hintText;

  /// Text display if file is selected
  final String? selectFile;

  /// Text Style for selected file
  final TextStyle selectFileStyle;

  /// File Uploader Icon
  final Icon? fileUploaderIcon;

  /// File Downloader Icon
  final Icon? fileDownloadIcon;

  final Color iconColor;

  /// add style to note
  final TextStyle? noteStyle;

  /// [showDefaultNote] is a boolean to show default note.
  // final bool showDefaultNote;

  /// hide border of text field
  final bool hideBorder;

  /// [padding] is a EdgeInsetsGeometry to add padding to the widget.
  final EdgeInsets? padding;

  final bool selectMultiImage;

  /// File Uploader Style
  const TBIBUploaderStyle({
    this.labelText,
    this.labelStyle,
    this.hintText,
    this.selectFile = "Select File",
    this.selectFileStyle = const TextStyle(color: Colors.black),
    this.iconColor = Colors.black,
    this.fileUploaderIcon,
    this.fileDownloadIcon,
    this.noteStyle,
    this.hideBorder = false,
    this.padding,
    this.selectMultiImage = false,
    // this.showDefaultNote = true,
  });
}
