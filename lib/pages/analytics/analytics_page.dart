import 'package:flutter/material.dart';
import 'package:flutter_amplify_demo/services/analytics_service.dart';

class AnalyticsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: ElevatedButton(
        child: Text('Record Event'),
        onPressed: () => _recordEvent(context),
      ),
    );
  }

  _recordEvent(BuildContext context) async {
    await AnalyticsService.recordEvent(
      title: 'Button Pressed',
    );
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text('Successfully sent event'),
    ));
  }
}
