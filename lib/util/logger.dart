import 'dart:convert';
import 'dart:developer';

import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/foundation.dart';

class Logger {
  static Logger? _instance;

  bool Function() checkReportsAccepted;
  Future<String?> Function()? retrieveUserId;

  static Logger get instance {
    if (_instance == null) {
      throw LoggerException();
    } else {
      return _instance!;
    }
  }

  static initialize({
    required bool Function() checkReportsAccepted,
    Future<String?> Function()? retrieveUserId,
  }) {
    _instance = Logger._(
      checkReportsAccepted: checkReportsAccepted,
      retrieveUserId: retrieveUserId,
    );
  }

  Logger._({required this.checkReportsAccepted, this.retrieveUserId});

  void error({String? module, String? message, StackTrace? stack}) {
    _log(severity: "error", module: module, message: message);
    if (!kIsWeb && kReleaseMode && checkReportsAccepted()) {
      FirebaseCrashlytics.instance.recordError(message, stack);
    }
  }

  void warning({String? module, String? message}) {
    _log(severity: "warn", module: module, message: message);
  }

  void info({String? module, String? message}) {
    _log(severity: "info", module: module, message: message);
  }

  void _log({String? severity, String? module, String? message}) async {
    Map<String, String?> object = {
      "severity": severity,
      "module": module,
      "message": message
    };

    if (kDebugMode) {
      log(jsonEncode(object));
    } else if (!kIsWeb && checkReportsAccepted()) {
      String? uid = await retrieveUserId?.call();
      if (uid != null) {
        FirebaseCrashlytics.instance.setUserIdentifier(uid);
      }

      FirebaseCrashlytics.instance.log(jsonEncode(object));
    }
  }
}

class LoggerException {
  @override
  String toString() {
    return 'Logger has no instance because it has not been initialised';
  }
}
