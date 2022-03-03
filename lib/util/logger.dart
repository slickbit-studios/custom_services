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

  void error({Type? module, String? message, StackTrace? stack}) {
    _log(severity: "error", module: module, message: message);
    if (!kIsWeb && kReleaseMode && checkReportsAccepted()) {
      FirebaseCrashlytics.instance.recordError(message, stack);
    }
  }

  void warning({Type? module, String? message}) {
    _log(severity: "warn", module: module, message: message);
  }

  void info({Type? module, String? message}) {
    _log(severity: "info", module: module, message: message);
  }

  void _log({String? severity, Type? module, String? message}) async {
    Map<String, String?> object = {
      "severity": severity,
      "module": '$module',
      "message": message
    };

    JsonEncoder encoder = JsonEncoder.withIndent(' ');
    String pretty = encoder.convert(object);

    if (kDebugMode) {
      log(pretty);
    } else if (!kIsWeb && checkReportsAccepted()) {
      String? uid = await retrieveUserId?.call();
      if (uid != null) {
        FirebaseCrashlytics.instance.setUserIdentifier(uid);
      }

      FirebaseCrashlytics.instance.log(pretty);
    }
  }
}

class LoggerException {
  @override
  String toString() {
    return 'Logger has no instance because it has not been initialised';
  }
}
