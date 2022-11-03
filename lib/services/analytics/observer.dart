import 'package:firebase_analytics/firebase_analytics.dart';

class AppObserver extends FirebaseAnalyticsObserver {
  AppObserver() : super(analytics: FirebaseAnalytics.instance);
}
