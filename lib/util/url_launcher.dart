import 'package:url_launcher/url_launcher.dart';

import '../services/crash_report/logger.dart';

class UrlLauncher {
  static Future<void> launch(String url) async {
    try {
      await launchUrl(Uri.parse(url));
      ServiceLogger.instance
          .info(module: UrlLauncher, message: 'URL $url launched');
    } catch (err) {
      ServiceLogger.instance.error(
        module: UrlLauncher,
        message: 'Unable to launch url $url, error: $err',
      );
    }
  }
}
