import 'package:flutter/widgets.dart';

/// File Uploader Style
class TBIBUploaderStyle {
  /// File Uploader Style
  const TBIBUploaderStyle({
    this.labelText,
    this.labelStyle,
    this.selectFile,
    this.fileUploaderIcon,
  });

  /// Label Text
  final String? labelText;

  /// Label Style
  final TextStyle? labelStyle;

  /// Text display if file is selected
  final Text? selectFile;

  /// File Uploader Icon
  final Icon? fileUploaderIcon;
}
