import 'package:flutter/widgets.dart';

/// File Uploader Style
class TBIBUploaderStyle {
  /// File Uploader Style
  const TBIBUploaderStyle({
    this.labelText,
    this.labelStyle,
    this.selectFile,
    this.fileUploaderIcon,
    this.fileDownloadIcon,
    this.noteStyle,
    this.hideBorder = false,
    this.padding,
  });

  /// Label Text
  final String? labelText;

  /// Label Style
  final TextStyle? labelStyle;

  /// Text display if file is selected
  final Text? selectFile;

  /// File Uploader Icon
  final Icon? fileUploaderIcon;

  /// File Downloader Icon
  final Icon? fileDownloadIcon;

  /// add style to note
  final TextStyle? noteStyle;

  /// hide border of text field
  final bool hideBorder;

  /// [padding] is a EdgeInsetsGeometry to add padding to the widget.
  final EdgeInsets? padding;
}
