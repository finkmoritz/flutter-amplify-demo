import 'package:amplify_analytics_pinpoint/amplify_analytics_pinpoint.dart';
import 'package:amplify_flutter/amplify.dart';

class AnalyticsService {
  static recordEvent({String title}) {
    var event = AnalyticsEvent(title);
    Amplify.Analytics.recordEvent(event: event);
  }
}
