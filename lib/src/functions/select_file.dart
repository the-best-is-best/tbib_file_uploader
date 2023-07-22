import 'package:file_picker/file_picker.dart';

/// select file from  file picker
/// [maxSize] is in MB
Future<({String? path, String? name, String? error})> selectFileAsync(
    {int? maxSize,
    List<String>? allowedExtensions,
    String? changeFileNameTo}) async {
  final file = await FilePicker.platform.pickFiles(
    type: allowedExtensions == null ? FileType.any : FileType.custom,
    allowedExtensions: allowedExtensions,
  );
  if (file?.files == null) {
    return (path: null, name: null, error: null);
  }
  if (file?.files != null && maxSize != null) {
    final fileBytes = file?.files[0].size;
    if (fileBytes != null && fileBytes > maxSize * 1000000) {
      return (path: null, name: null, error: 'File size is too large');
    }
  }
  if (changeFileNameTo != null) {
    final fileName = file?.files.first.name;
    final fileExtension = fileName?.split('.').last;
    final newFileName = '$changeFileNameTo.$fileExtension';
    return (path: file?.files.first.path, name: newFileName, error: null);
  }
  return (
    path: file?.files.first.path,
    name: file?.files.first.name,
    error: null
  );
}
