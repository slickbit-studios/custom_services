import 'package:custom_services/services/rest/rest_config.dart';
import 'package:custom_services/services/rest/rest_handler.dart';
import 'package:http/http.dart';

class RestProxy {
  final RestHandler _handler;
  final RestConfig _config;

  RestProxy(this._config) : _handler = RestHandler(_config.url);

  Future<Response> get({
    String extension = '/',
    Map<String, String>? queryParameters,
  }) async {
    return await _handler.get(
      extension: extension,
      headers: await _config.headers,
      queryParameters: queryParameters,
      timeout: _config.restTimeout,
    );
  }

  Future<Response> post({
    String extension = '/',
    Map<String, String>? queryParameters,
    Object body = const {},
  }) async {
    return await _handler.post(
      extension: extension,
      headers: await _config.headers,
      queryParameters: queryParameters,
      body: body,
      timeout: _config.restTimeout,
    );
  }

  Future<Response> patch({
    String extension = '/',
    Map<String, String>? queryParameters,
    Object body = const {},
  }) async {
    return await _handler.patch(
      extension: extension,
      headers: await _config.headers,
      queryParameters: queryParameters,
      body: body,
      timeout: _config.restTimeout,
    );
  }

  Future<Response> put({
    String extension = '/',
    Map<String, String>? queryParameters,
    Object body = const {},
  }) async {
    return await _handler.put(
      extension: extension,
      headers: await _config.headers,
      queryParameters: queryParameters,
      body: body,
      timeout: _config.restTimeout,
    );
  }

  Future<Response> delete({
    String extension = '/',
    Map<String, String>? queryParameters,
    Object body = const {},
  }) async {
    return await _handler.delete(
      extension: extension,
      headers: await _config.headers,
      queryParameters: queryParameters,
      body: body,
      timeout: _config.restTimeout,
    );
  }
}
