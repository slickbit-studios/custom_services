import 'package:url_launcher/url_launcher.dart' as launcher;

import '../services/crash_report/logger.dart';

class UrlLauncher {
  static Future<void> launch(String url) async {
    try {
      await launcher.launchUrl(Uri.parse(url));
      Logger.info(module: UrlLauncher, message: 'URL $url launched');
    } catch (err) {
      Logger.error(
        module: UrlLauncher,
        message: 'Unable to launch url $url, error: $err',
      );
    }
  }
}
