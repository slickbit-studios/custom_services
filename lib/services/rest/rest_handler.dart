import 'dart:async';
import 'dart:convert';

import 'package:http/http.dart' as http;

import 'rest_exception.dart';

const String CONTENT_TYPE_JSON = "application/json";

const Duration DEFAULT_TIMEOUT = Duration(seconds: 15);

class RestHandler {
  final String url;

  RestHandler(this.url);

  Future<http.Response> get({
    String extension = '/',
    Map<String, String>? headers,
    Duration timeout = DEFAULT_TIMEOUT,
  }) async {
    try {
      Uri uri = Uri.parse(url + extension);
      http.Response res =
          await http.get(uri, headers: headers).timeout(timeout);

      if (res.statusCode >= 400) {
        throw RestException(
          'Error performing GET ' + uri.toString(),
          response: res,
        );
      }

      return res;
    } on TimeoutException catch (_) {
      throw RestException('Request timed out');
    }
  }

  Future<http.Response> post({
    String extension = '/',
    Map<String, String>? headers,
    Object? body,
    Duration timeout = DEFAULT_TIMEOUT,
  }) async {
    try {
      Uri uri = Uri.parse(url + extension);

      http.Response res = await http
          .post(
            uri,
            headers: headers,
            body: jsonEncode(body),
          )
          .timeout(timeout);

      if (res.statusCode >= 400) {
        throw RestException(
          'Error performing POST ' + uri.toString(),
          response: res,
        );
      }

      return res;
    } on TimeoutException catch (_) {
      throw RestException('Request timed out');
    }
  }

  Future<http.Response> put({
    String extension = '/',
    Map<String, String>? headers,
    Duration timeout = DEFAULT_TIMEOUT,
    Object? body,
  }) async {
    try {
      Uri uri = Uri.parse(url + extension);

      http.Response res = await http
          .put(
            uri,
            headers: headers,
            body: jsonEncode(body),
          )
          .timeout(timeout);

      if (res.statusCode >= 400) {
        throw RestException(
          'Error performing PUT ' + uri.toString(),
          response: res,
        );
      }

      return res;
    } on TimeoutException catch (_) {
      throw RestException('Request timed out');
    }
  }

  Future<http.Response> delete({
    String extension = '/',
    Map<String, String>? headers,
    Duration timeout = DEFAULT_TIMEOUT,
    Object? body,
  }) async {
    try {
      Uri uri = Uri.parse(url + extension);

      http.Response res = await http
          .delete(
            uri,
            headers: headers,
            body: jsonEncode(body),
          )
          .timeout(timeout);

      if (res.statusCode >= 400) {
        throw RestException(
          'Error performing PUT ' + uri.toString(),
          response: res,
        );
      }

      return res;
    } on TimeoutException catch (_) {
      throw RestException('Request timed out');
    }
  }

  Future<http.Response> patch({
    String extension = '/',
    Map<String, String>? headers,
    Duration timeout = DEFAULT_TIMEOUT,
    Object? body,
  }) async {
    Uri uri = Uri.parse(url + extension);

    http.Response res = await http
        .patch(
          uri,
          headers: headers,
          body: jsonEncode(body),
        )
        .timeout(timeout);

    if (res.statusCode >= 400) {
      throw RestException(
        'Error performing PATCH ' + uri.toString(),
        response: res,
      );
    }

    return res;
  }
}
