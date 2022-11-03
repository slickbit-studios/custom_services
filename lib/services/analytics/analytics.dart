import 'package:firebase_analytics/firebase_analytics.dart';

class Analytics {
  Analytics._();

  static void enableCollection(bool enabled) =>
      FirebaseAnalytics.instance.setAnalyticsCollectionEnabled(enabled);
}
