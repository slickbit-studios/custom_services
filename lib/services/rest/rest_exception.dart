import 'package:http/http.dart' as http;

class RestException implements Exception {
  static const int RESPONSE_CODE_NOT_FOUND = 404;

  String text;
  http.Response? response;
  RestException(this.text, {this.response});

  @override
  String toString() {
    return 'RestException: $response';
  }
}
