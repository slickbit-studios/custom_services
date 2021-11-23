import 'dart:developer';

import 'package:services/util/logger.dart';
import 'package:url_launcher/url_launcher.dart';

launchUrl(String url) async {
  try {
    Logger logger = Logger.instance;

    try {
      await launch(url);
      logger.info(module: "URL Launcher", message: "URL $url launched");
    } catch (err) {
      logger.error(
          module: "URL Launcher",
          message: "Unable to launch url $url, error: $err");
    }
  } catch (error) {
    log('Error launching url: $error');
  }
}
