// ignore_for_file: inference_failure_on_function_return_type

import 'dart:developer';
import 'dart:io';
import 'dart:math' as math;

import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:tbib_file_uploader/src/service/format_bytes.dart';

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

/// File Uploader Init
class TBIBFileUploader {
  static bool _uploadStarted = false;
  static final num _convertBytesToMB = math.pow(10, 6);

  /// File Uploader Init
  Future<void> init() async {
    var permission = await Permission.notification.isGranted;
    if (!permission) {
      await Permission.notification.request();
    }
    permission = await Permission.notification.isGranted;
    if (permission) {
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
    Duration refreshNotificationProgress = const Duration(milliseconds: 100),
    bool showDownloadSpeed = true,
    bool showNotificationWithoutProgress = false,
    bool receiveBytesAsMB = false,
    Function({required int countDownloaded, required int totalSize})?
        onSendProgress,
  }) async {
    if (_uploadStarted) {
      log('Upload already started');

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

  /// upload file and receive response
  Future<Response<Map<String, dynamic>>?> startUploadFileWithResponse({
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
      log('Upload already started');

      return null;
    }
    final data = yourData;

    var showNewNotification = true;
    final startTime = DateTime.now();
    var endTime = DateTime.now().add(refreshNotificationProgress);
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
    try {
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
              if (showNotification) {
                final now = DateTime.now();
                if (showNewNotification || now.isAfter(endTime)) {
                  showNewNotification = false;

                  if (Platform.isAndroid) {
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
                    // iOS-specific updates
                    endTime = now.add(refreshNotificationProgress);
                    showNewNotification = true;
                  }
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
      return result;
    } catch (e) {
      _uploadStarted = false;
      return null;
    }
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
    bool showDownloadSpeed,
    int totalBytes,
    int receivedBytes,
    DateTime startTime,
  ) async {
    // Calculate progress
    final progress =
        totalBytes > 0 ? math.min(receivedBytes / totalBytes * 100, 100) : 0;

    // Format bytes into human-readable units
    final totalData = formatBytes(totalBytes, 2);
    final receivedData = formatBytes(receivedBytes, 2);
    final totalMB = totalData.size;
    final receivedMB = receivedData.size;

    // Calculate download speed
    var speedMBps = 0.0;
    if (showDownloadSpeed) {
      final duration = DateTime.now().difference(startTime);
      final seconds =
          duration.inMilliseconds > 0 ? duration.inMilliseconds / 1000 : 1;
      speedMBps = receivedBytes / seconds / (1024 * 1024); // Speed in MB/s
    }

    // Send notification
    await AwesomeNotifications().createNotification(
      content: NotificationContent(
        id: 1,
        channelKey: 'upload_channel',
        title: 'Uploading',
        body:
            'Uploading (${receivedMB.toStringAsFixed(2)} / ${totalMB.toStringAsFixed(2)} MB)'
            '${speedMBps > 0 ? 'Speed: ${speedMBps.toStringAsFixed(2)} MB/s' : ''}',
        notificationLayout: NotificationLayout.ProgressBar,
        wakeUpScreen: true,
        locked: true,
        progress: progress.clamp(0, 100).toDouble(),
      ),
    );
  }
}
