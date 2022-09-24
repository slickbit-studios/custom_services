import 'package:http/http.dart' as http;

class RestException implements Exception {
  static const int RESPONSE_CODE_NOT_FOUND = 404;
  static const int RESPONSE_CODE_TIMEOUT = 407;
  static const int RESPONSE_CODE_UNDEFINED = 0;

  String text;
  final http.Response? _response;
  final bool _timeout;
  RestException(this.text, {http.Response? response, bool timeout = false})
      : assert(response != null || timeout, ''),
        _response = response,
        _timeout = timeout;

  int get statusCode =>
      _response?.statusCode ??
      (_timeout ? RESPONSE_CODE_TIMEOUT : RESPONSE_CODE_UNDEFINED);

  @override
  String toString() {
    String string = 'RestException: $text';
    if (_response != null) {
      string += ', response: {headers: ${_response?.headers},'
          ' body: ${_response?.body}}';
    }
    return string;
  }
}
