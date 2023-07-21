import 'package:flutter_test/flutter_test.dart';
import 'package:tbib_uploader/tbib_uploader.dart';
import 'package:tbib_uploader/tbib_uploader_platform_interface.dart';
import 'package:tbib_uploader/tbib_uploader_method_channel.dart';
import 'package:plugin_platform_interface/plugin_platform_interface.dart';

class MockTbibUploaderPlatform
    with MockPlatformInterfaceMixin
    implements TbibUploaderPlatform {

  @override
  Future<String?> getPlatformVersion() => Future.value('42');
}

void main() {
  final TbibUploaderPlatform initialPlatform = TbibUploaderPlatform.instance;

  test('$MethodChannelTbibUploader is the default instance', () {
    expect(initialPlatform, isInstanceOf<MethodChannelTbibUploader>());
  });

  test('getPlatformVersion', () async {
    TbibUploader tbibUploaderPlugin = TbibUploader();
    MockTbibUploaderPlatform fakePlatform = MockTbibUploaderPlatform();
    TbibUploaderPlatform.instance = fakePlatform;

    expect(await tbibUploaderPlugin.getPlatformVersion(), '42');
  });
}
