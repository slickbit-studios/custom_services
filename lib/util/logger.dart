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

  void error({Type? module, required String message, StackTrace? stack}) {
    _log(severity: "error", module: module, message: message, stack: stack);
    if (!kIsWeb && kReleaseMode && checkReportsAccepted()) {
      FirebaseCrashlytics.instance.recordError(message, stack);
    }
  }

  void warning({Type? module, required String message}) {
    _log(severity: "warn", module: module, message: message);
  }

  void info({Type? module, required String message}) {
    _log(severity: "info", module: module, message: message);
  }

  void _log({
    required String severity,
    Type? module,
    required String message,
    StackTrace? stack,
  }) async {
    Map<String, String?> object = {
      "severity": severity,
      "module": '$module',
      "message": message,
    };

    object["severity"] = severity;

    if (module != null) {
      object["module"] = module.toString();
    }

    object["message"] = message;

    if (stack != null) {
      object["stack"] = stack.toString();
    }

    String pretty = JsonEncoder.withIndent(' ').convert(object);

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
