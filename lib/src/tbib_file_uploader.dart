// ignore_for_file: inference_failure_on_function_return_type

import 'dart:developer';
import 'dart:io';
import 'dart:math' as math;

import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:tbib_file_uploader/src/service/format_bytes.dart';

/// File Uploader Init
class TBIBFileUploader {
  static bool _uploadStarted = false;
  static final num _convertBytesToMB = math.pow(10, 6);

  /// File Uploader Init
  Future<void> init() async {
    await AwesomeNotifications().requestPermissionToSendNotifications();

    await AwesomeNotifications().initialize(
      null,
      [
        NotificationChannel(
          icon: 'resource://drawable/ic_stat_upload',
          channelKey: 'upload_channel',
          importance: NotificationImportance.Max,
          ledOffMs: 100,
          ledOnMs: 500,
          locked: true,
          channelName: 'Upload notifications',
          channelDescription: 'Upload channel for download progress',
          defaultColor: Colors.black,
          ledColor: Colors.white,
          channelShowBadge: false,
        ),
        NotificationChannel(
          icon: 'resource://drawable/ic_stat_file_upload_done',
          importance: NotificationImportance.Max,
          channelKey: 'upload_completed_channel',
          channelName: 'Upload completed notifications',
          channelDescription: 'Notification channel for download completed',
          defaultColor: Colors.black,
          ledColor: Colors.white,
          channelShowBadge: false,
        ),
      ],
    );
  }

  /// upload file and receive response
  Future<Map<String, dynamic>> startUploadFileWithResponse({
    /// your dio
    required Dio dio,

    /// method api
    required String method,

    /// your path api
    required String pathApi,

    /// any data will send with file
    required FormData yourData,
    bool showNotification = true,
    Duration refreshNotificationProgress = const Duration(seconds: 1),
    bool showDownloadSpeed = true,
    bool showNotificationWithoutProgress = false,
    bool receiveBytesAsMB = false,
    Function({required int countDownloaded, required int totalSize})?
        onSendProgress,
  }) async {
    if (_uploadStarted) {
      log('Download already started');

      return {};
    }
    final data = yourData;

    var showNewNotification = true;
    final startTime = DateTime.now();
    var notificationDisplayDate = DateTime.now();
    var endTime = DateTime.now().add(refreshNotificationProgress);

    final result = await dio.fetch<Map<String, dynamic>>(
      _setStreamType<Map<String, dynamic>>(
        Options(
          method: method,
          // headers: headers,
          // extra: extra,
          contentType: 'multipart/form-data',
        ).compose(
          dio.options,
          pathApi,
          data: data,
          onSendProgress: (count, total) {
            if (showNewNotification) {
              showNewNotification = false;

              _onSendProgress(
                count,
                total,
                startTime: startTime,
                refreshNotificationProgress: refreshNotificationProgress,
                showNotification: showDownloadSpeed,
                showDownloadSpeed: showDownloadSpeed,
                receiveBytesAsMB: receiveBytesAsMB,
                showNotificationWithoutProgress:
                    showNotificationWithoutProgress,
                onSendProgress: onSendProgress,
              );
            } else {
              notificationDisplayDate = DateTime.now();
              if (notificationDisplayDate.millisecondsSinceEpoch >
                  endTime.millisecondsSinceEpoch) {
                //   await AwesomeNotifications().dismiss(1);
                showNewNotification = true;
                notificationDisplayDate = endTime;
                endTime = DateTime.now().add(refreshNotificationProgress);
              }
            }
          },
        ),
      ),
    );
    _uploadStarted = false;
    if (showNotification) {
      await AwesomeNotifications().createNotification(
        content: NotificationContent(
          id: 1,
          channelKey: 'upload_completed_channel',
          title: 'Upload completed',
          body: 'Uploaded Successfully',
          wakeUpScreen: true,
          locked: true,
        ),
      );
    }
    return result.data!;
  }

  /// upload file  only
  Future<void> startUploadFile({
    /// your dio
    required Dio dio,

    /// method api
    required String method,

    /// your path api
    required String pathApi,

    /// any data will send with file
    required FormData yourData,
    bool showNotification = true,
    Duration refreshNotificationProgress = const Duration(seconds: 1),
    bool showDownloadSpeed = true,
    bool showNotificationWithoutProgress = false,
    bool receiveBytesAsMB = false,
    Function({required int countDownloaded, required int totalSize})?
        onSendProgress,
  }) async {
    if (_uploadStarted) {
      log('Download already started');

      return;
    }
    final data = yourData;

    var showNewNotification = true;
    final startTime = DateTime.now();
    var notificationDisplayDate = DateTime.now();
    var endTime = DateTime.now().add(refreshNotificationProgress);

    await dio.fetch<void>(
      _setStreamType<void>(
        Options(
          method: method,
          // headers: headers,
          // extra: extra,
          contentType: 'multipart/form-data',
        ).compose(
          dio.options,
          pathApi,
          data: data,
          onSendProgress: (count, total) {
            if (showNewNotification) {
              showNewNotification = false;

              _onSendProgress(
                count,
                total,
                startTime: startTime,
                refreshNotificationProgress: refreshNotificationProgress,
                showNotification: showDownloadSpeed,
                showDownloadSpeed: showDownloadSpeed,
                receiveBytesAsMB: receiveBytesAsMB,
                showNotificationWithoutProgress:
                    showNotificationWithoutProgress,
                onSendProgress: onSendProgress,
              );
            } else {
              notificationDisplayDate = DateTime.now();
              if (notificationDisplayDate.millisecondsSinceEpoch >
                  endTime.millisecondsSinceEpoch) {
                //   await AwesomeNotifications().dismiss(1);
                showNewNotification = true;
                notificationDisplayDate = endTime;
                endTime = DateTime.now().add(refreshNotificationProgress);
              }
            }
          },
        ),
      ),
    );
    if (showNotification) {
      await AwesomeNotifications().createNotification(
        content: NotificationContent(
          id: 1,
          channelKey: 'upload_completed_channel',
          title: 'Upload completed',
          body: 'Uploaded Successfully',
          wakeUpScreen: true,
          locked: true,
        ),
      );
    }
    _uploadStarted = false;
  }

  Future<void> _onSendProgress(
    int countDownloaded,
    int total, {
    required bool showDownloadSpeed,
    required bool showNotificationWithoutProgress,
    required bool receiveBytesAsMB,
    required bool showNotification,
    required Duration refreshNotificationProgress,
    required DateTime startTime,
    required Function({required int countDownloaded, required int totalSize})?
        onSendProgress,
  }) async {
    if (Platform.isIOS && showNotification) {
      await AwesomeNotifications().createNotification(
        content: NotificationContent(
          id: 1,
          channelKey: 'upload_channel',
          title: 'Start uploading',
          body: '',
          wakeUpScreen: true,
          locked: true,
        ),
      );
    }

    if (showNotificationWithoutProgress || Platform.isIOS) {
      if (receiveBytesAsMB) {
        return onSendProgress?.call(
          countDownloaded: (countDownloaded / _convertBytesToMB).floor(),
          totalSize: (total / _convertBytesToMB).floor(),
        );
      }
      return onSendProgress?.call(
        countDownloaded: countDownloaded,
        totalSize: total,
      );
    }
    if (!showNotification) {
      if (receiveBytesAsMB) {
        return onSendProgress?.call(
          countDownloaded: (countDownloaded / _convertBytesToMB).floor(),
          totalSize: (total / _convertBytesToMB).floor(),
        );
      }
      return onSendProgress?.call(
        countDownloaded: countDownloaded,
        totalSize: total,
      );
    } else {
      await _showProgressNotification(
        // receiveBytesAsFileSizeUnit,
        showDownloadSpeed,
        total,
        countDownloaded,
        // fileName,
        startTime,
      );
      if (receiveBytesAsMB) {
        return onSendProgress?.call(
          countDownloaded: (countDownloaded / _convertBytesToMB).floor(),
          totalSize: (total / _convertBytesToMB).floor(),
        );
      }
      return onSendProgress?.call(
        countDownloaded: countDownloaded,
        totalSize: total,
      );
    }
  }

  Future<void> _showProgressNotification(
    // bool receiveBytesAsFileSizeUnit,
    bool showDownloadSpeed,
    int totalBytes,
    int receivedBytes,
    // String fileName,
    DateTime startTime,
  ) async {
    final num progress =
        math.min((receivedBytes / totalBytes * 100).round(), 100);
    final num totalMB = formatBytes(totalBytes, 2).size;
    final num receivedMB = formatBytes(receivedBytes, 2).size;
    // String receiveUnit = formatBytes(receivedBytes, 2).unit;
    final totalUnit = formatBytes(totalBytes, 2).unit;

    var speedMbps = 0.0;
    if (showDownloadSpeed) {
      final duration = DateTime.now().difference(startTime);
      final seconds = duration.inMilliseconds / 1000;
      speedMbps = receivedMB / seconds * 8;
    }
    // dev.log(
    //     'after noti receivedBytes: $receivedBytes, totalBytes: $totalBytes progress: $progress');
    await AwesomeNotifications().createNotification(
      content: NotificationContent(
        id: 1,
        channelKey: 'upload_channel',
        title: 'Uploading',
        body:
            'Uploading  ${totalBytes >= 0 ? '(${receivedMB.toStringAsFixed(2)} / ${totalMB.toStringAsFixed(2)})' : '${receivedMB.toStringAsFixed(2)} / nil'} $totalUnit ${speedMbps == 0 ? "" : 'speed ${(speedMbps / 8).toStringAsFixed(2)} MB/s'} ',
        notificationLayout: NotificationLayout.ProgressBar,
        wakeUpScreen: true,
        locked: true,
        progress: progress.toInt(),
      ),
    );
  }
}

RequestOptions _setStreamType<T>(RequestOptions requestOptions) {
  if (T != dynamic &&
      !(requestOptions.responseType == ResponseType.bytes ||
          requestOptions.responseType == ResponseType.stream)) {
    if (T == String) {
      requestOptions.responseType = ResponseType.plain;
    } else {
      requestOptions.responseType = ResponseType.json;
    }
  }
  return requestOptions;
}
