import 'package:flutter/foundation.dart';
import 'package:ncov_2019_app_flutter/app/services/api.dart';
import 'package:ncov_2019_app_flutter/app/services/api_service.dart';
import 'package:http/http.dart';
import 'package:ncov_2019_app_flutter/app/repositories/data.dart';
import 'package:ncov_2019_app_flutter/app/services/data_cache_service.dart';
import 'dart:io';

class DataRepository {
  DataRepository({@required this.apiService, @required this.dataCacheService});
  final APIService apiService;
  final DataCacheService dataCacheService;

  String _token;

  Future<T> getDataRefreshingToken<T>({Future<T> Function() onGetData}) async {
    try {
      if (_token == null) {
        _token = await apiService.getAccessToken();
      }
      return await onGetData();
    } on SocketException catch (_) {
      rethrow;
    } on Response catch (response) {
      // if unauthorized, get token again
      if (response.statusCode == 401) {
        _token = await apiService.getAccessToken();
        return await onGetData();
      }
      rethrow;
    }
  }

  /// Get data for a single endpoint
  Future<int> getEndpointData(Endpoint endpoint) async =>
      await getDataRefreshingToken<int>(
        onGetData: () =>
            apiService.getEndpointData(token: _token, endpoint: endpoint),
      );

  /// Get data for all endpoints
  Future<Data> getAllEndpointsData() async {
    final data = await getDataRefreshingToken<Data>(
      onGetData: () => _getAllData(),
    );
    // save to cache
    await dataCacheService.setData(data);
    return data;
  }

  Data getAllEndpointsCachedData() => dataCacheService.getData();

  Future<Data> _getAllData() async {
    final results = await Future.wait([
      apiService.getEndpointData(token: _token, endpoint: Endpoint.cases),
      apiService.getEndpointData(
          token: _token, endpoint: Endpoint.casesSuspected),
      apiService.getEndpointData(
          token: _token, endpoint: Endpoint.casesConfirmed),
      apiService.getEndpointData(token: _token, endpoint: Endpoint.deaths),
      apiService.getEndpointData(token: _token, endpoint: Endpoint.recovered),
    ]);
    return Data(
      values: {
        Endpoint.cases: results[0],
        Endpoint.casesSuspected: results[1],
        Endpoint.casesConfirmed: results[2],
        Endpoint.deaths: results[3],
        Endpoint.recovered: results[4],
      },
      updateTime: DateTime.now(),
    );
  }
}
