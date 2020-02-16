import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class LastUpdatedDateFormatter {
  LastUpdatedDateFormatter(
      {@required this.lastUpdated, @required this.refreshInProgress});
  final DateTime lastUpdated;
  final bool refreshInProgress;

  DateFormat _dateFormatter() {
    final now = DateTime.now();
    return now.year == lastUpdated.year &&
            now.month == lastUpdated.month &&
            now.day == lastUpdated.day
        ? DateFormat.Hms()
        : DateFormat.yMd().add_Hms();
  }

  String lastUpdatedStatusText() {
    if (lastUpdated != null) {
      final formatter = _dateFormatter();
      final formatted = formatter.format(lastUpdated);
      return 'Last updated: $formatted';
    }
    if (refreshInProgress) {
      return 'Loading...';
    }
    return '';
  }
}

class LastUpdatedStatusLabel extends StatelessWidget {
  const LastUpdatedStatusLabel({Key key, this.labelText}) : super(key: key);
  final String labelText;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Text(
        labelText,
        textAlign: TextAlign.center,
      ),
    );
  }
}
