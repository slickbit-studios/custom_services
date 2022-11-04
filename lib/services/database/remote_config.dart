import 'package:firebase_remote_config/firebase_remote_config.dart';

class RemoteConfig {
  static RemoteConfig? _instance;

  final FirebaseRemoteConfig _config;

  RemoteConfig._(this._config);

  static Future<void> initialize({Map<String, dynamic>? defaults}) async {
    var config = FirebaseRemoteConfig.instance;

    await config.setConfigSettings(
      RemoteConfigSettings(
        fetchTimeout: const Duration(seconds: 10),
        minimumFetchInterval: const Duration(hours: 1),
      ),
    );

    if (defaults != null) {
      await config.setDefaults(defaults);
    }

    await config.fetchAndActivate();

    _instance = RemoteConfig._(config);
  }

  static RemoteConfig get instance {
    if (_instance == null) {
      throw 'RemoteConfig needs to be initialized before accessing an instance';
    }

    return _instance!;
  }

  int getInt(String key) => _config.getInt(key);

  String getString(String key) => _config.getString(key);

  bool getBool(String key) => _config.getBool(key);
}
