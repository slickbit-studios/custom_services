import 'dart:convert';
import 'dart:developer';
import 'dart:math' as math;

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
    Map<String, String?> object = {"severity": severity, "message": message};

    if (stack != null) {
      object["stack"] = stack.toString();
    }

    JsonEncoder formatter = JsonEncoder.withIndent(' ');

    if (kDebugMode) {
      String pretty = formatter.convert(object);

      if (kIsWeb) {
        // web truncates messages, so split message
        while (pretty.isNotEmpty) {
          String part = pretty.substring(0, math.min(pretty.length, 80));
          log(part, name: '${module ?? ''}');

          pretty = pretty.substring(part.length);
        }
      } else {
        log(formatter.convert(object), name: '${module ?? ''}');
      }
    } else if (!kIsWeb && checkReportsAccepted()) {
      String? uid = await retrieveUserId?.call();

      if (uid != null) {
        FirebaseCrashlytics.instance.setUserIdentifier(uid);
      }

      if (module != null) {
        object["module"] = module.toString();
      }

      FirebaseCrashlytics.instance.log(formatter.convert(object));
    }
  }
}

class LoggerException {
  @override
  String toString() {
    return 'Logger has no instance because it has not been initialised';
  }
}
