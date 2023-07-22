// import 'package:flutter_test/flutter_test.dart';
// import 'package:tbib_file_uploader/tbib_file_uploader.dart';
// import 'package:tbib_file_uploader/tbib_file_uploader_platform_interface.dart';
// import 'package:tbib_file_uploader/tbib_file_uploader_method_channel.dart';
// import 'package:plugin_platform_interface/plugin_platform_interface.dart';

// class MockTbibFileUploaderPlatform
//     with MockPlatformInterfaceMixin
//     implements TbibFileUploaderPlatform {

//   @override
//   Future<String?> getPlatformVersion() => Future.value('42');
// }

// void main() {
//   final TbibFileUploaderPlatform initialPlatform = TbibFileUploaderPlatform.instance;

//   test('$MethodChannelTbibFileUploader is the default instance', () {
//     expect(initialPlatform, isInstanceOf<MethodChannelTbibFileUploader>());
//   });

//   test('getPlatformVersion', () async {
//     TbibFileUploader tbibFileUploaderPlugin = TbibFileUploader();
//     MockTbibFileUploaderPlatform fakePlatform = MockTbibFileUploaderPlatform();
//     TbibFileUploaderPlatform.instance = fakePlatform;

//     expect(await tbibFileUploaderPlugin.getPlatformVersion(), '42');
//   });
// }
