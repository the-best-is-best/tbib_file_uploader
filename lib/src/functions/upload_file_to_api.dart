import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

/// upload file
class UploadFile {
  /// upload file and  return response
  Future<Map<String, dynamic>> startUploadFileWithResponse({
    /// your dio
    required Dio dio,

    /// method api
    required String method,

    /// your path api
    required String pathApi,

    /// any data will send with file
    required FormData yourData,
  }) async {
    final data = yourData;

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
          onSendProgress: (count, total) => debugPrint(
            'onSendProgress: $count, total: $total',
          ),
        ),
      ),
    );
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
  }) async {
    final data = yourData;

    final result = await dio.fetch<void>(
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
          onSendProgress: (count, total) => debugPrint(
            'onSendProgress: $count, total: $total',
          ),
        ),
      ),
    );
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
}
