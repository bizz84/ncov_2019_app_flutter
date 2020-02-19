import 'package:flutter/foundation.dart';
import 'package:ncov_2019_app_flutter/app/api/api.dart';
import 'package:ncov_2019_app_flutter/app/repositories/data.dart';
import 'package:shared_preferences/shared_preferences.dart';

class DataCacheService {
  DataCacheService({@required this.sharedPreferences});
  final SharedPreferences sharedPreferences;

  static const String lastUpdatedKey = 'lastUpdated';

  Data getData() {
    Map<Endpoint, int> values = {};
    Endpoint.values.forEach((endpoint) {
      values[endpoint] = sharedPreferences.getInt(endpoint.toString());
    });
    final microsecondsSinceEpoch = sharedPreferences.getInt(lastUpdatedKey);
    final lastUpdated = microsecondsSinceEpoch != null
        ? DateTime.fromMicrosecondsSinceEpoch(microsecondsSinceEpoch)
        : null;
    if (values.isNotEmpty && lastUpdated != null) {
      return Data(values: values, updateTime: lastUpdated);
    }
    return null;
  }

  Future<void> setData(Data data) async {
    data.values.forEach((endpoint, value) async {
      await sharedPreferences.setInt(endpoint.toString(), value);
    });
    await sharedPreferences.setInt(
        lastUpdatedKey, data.updateTime.microsecondsSinceEpoch);
  }
}
