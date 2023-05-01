abstract class RestConfig {
  RestConfig();

  // individual getters
  String get url;

  // getters with default value
  Duration get restTimeout => const Duration(seconds: 5);

  Future<Map<String, String>> get headers;
}
