import 'dart:convert';
import 'dart:developer';
import 'dart:math' as math;

import 'package:custom_services/services/crash_report/exception.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/foundation.dart';

class Logger {
  static Logger? _instance;

  Future<String?> Function()? retrieveUserId;

  static Logger get _checkedInstance {
    if (_instance == null) {
      throw LoggerException();
    } else {
      return _instance!;
    }
  }

  static initialize({Future<String?> Function()? retrieveUserId}) {
    _instance = Logger._(retrieveUserId: retrieveUserId);
  }

  Logger._({this.retrieveUserId});

  static void error(
      {Type? module, required String message, StackTrace? stack}) {
    _checkedInstance._log(
        severity: "error", module: module, message: message, stack: stack);
    if (!kIsWeb && kReleaseMode && isSendEnabled) {
      FirebaseCrashlytics.instance.recordError(message, stack);
    }
  }

  static void warning({Type? module, required String message}) {
    _checkedInstance._log(severity: "warn", module: module, message: message);
  }

  static void info({Type? module, required String message}) {
    _checkedInstance._log(severity: "info", module: module, message: message);
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

    JsonEncoder formatter = const JsonEncoder.withIndent(' ');

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
    } else if (!kIsWeb && isSendEnabled) {
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

  static void recordError(Object error, StackTrace stack) {
    if (!kIsWeb && kReleaseMode && isSendEnabled) {
      FirebaseCrashlytics.instance.recordError(error, stack);
    } else {
      Logger.error(module: Logger, message: '$error', stack: stack);
    }
  }

  static FlutterExceptionHandler get recordFlutterError =>
      FirebaseCrashlytics.instance.recordFlutterError;

  static void enableSendReports(bool enabled) =>
      FirebaseCrashlytics.instance.setCrashlyticsCollectionEnabled(enabled);

  static bool get isSendEnabled =>
      FirebaseCrashlytics.instance.isCrashlyticsCollectionEnabled;
}
