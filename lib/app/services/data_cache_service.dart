import 'package:flutter/foundation.dart';
import 'package:ncov_2019_app_flutter/app/services/api.dart';
import 'package:ncov_2019_app_flutter/app/repositories/endpoints_data.dart';
import 'package:ncov_2019_app_flutter/app/services/endpoint_data.dart';
import 'package:shared_preferences/shared_preferences.dart';

class DataCacheService {
  DataCacheService({@required this.sharedPreferences});
  final SharedPreferences sharedPreferences;

  static String endpointValueKey(Endpoint endpoint) => '$endpoint/value';
  static String endpointDateKey(Endpoint endpoint) => '$endpoint/date';

  EndpointsData getData() {
    Map<Endpoint, EndpointData> values = {};
    Endpoint.values.forEach((endpoint) {
      final value = sharedPreferences.getInt(endpointValueKey(endpoint));
      final dateString = sharedPreferences.getString(endpointDateKey(endpoint));
      if (value != null && dateString != null) {
        final date = DateTime.tryParse(dateString);
        values[endpoint] = EndpointData(value: value, date: date);
      }
    });
    return EndpointsData(values: values);
  }

  Future<void> setData(EndpointsData data) async {
    data.values.forEach((endpoint, data) async {
      await sharedPreferences.setInt(endpointValueKey(endpoint), data.value);
      await sharedPreferences.setString(
        endpointDateKey(endpoint),
        data.date.toIso8601String(),
      );
    });
  }
}
