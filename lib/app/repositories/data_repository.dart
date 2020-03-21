import 'package:flutter/foundation.dart';
import 'package:ncov_2019_app_flutter/app/services/api.dart';
import 'package:ncov_2019_app_flutter/app/services/api_service.dart';
import 'package:http/http.dart';
import 'package:ncov_2019_app_flutter/app/repositories/endpoints_data.dart';
import 'package:ncov_2019_app_flutter/app/services/data_cache_service.dart';
import 'dart:io';

import 'package:ncov_2019_app_flutter/app/services/endpoint_data.dart';

class DataRepository {
  DataRepository({@required this.apiService, @required this.dataCacheService});
  final APIService apiService;
  final DataCacheService dataCacheService;

  String _accessToken;

  Future<T> _getDataRefreshingToken<T>({Future<T> Function() onGetData}) async {
    try {
      if (_accessToken == null) {
        _accessToken = await apiService.getAccessToken();
      }
      return await onGetData();
    } on SocketException catch (_) {
      rethrow;
    } on Response catch (response) {
      // if unauthorized, get token again
      if (response.statusCode == 401) {
        _accessToken = await apiService.getAccessToken();
        return await onGetData();
      }
      rethrow;
    }
  }

  /// Get data for a single endpoint
  Future<EndpointData> getEndpointData(Endpoint endpoint) async =>
      await _getDataRefreshingToken<EndpointData>(
        onGetData: () => apiService.getEndpointData(
            accessToken: _accessToken, endpoint: endpoint),
      );

  /// Get data for all endpoints
  Future<EndpointsData> getAllEndpointsData() async {
    final data = await _getDataRefreshingToken<EndpointsData>(
      onGetData: () => _getAllEndpointsData(),
    );
    // save to cache
    await dataCacheService.setData(data);
    return data;
  }

  EndpointsData getAllEndpointsCachedData() => dataCacheService.getData();

  Future<EndpointsData> _getAllEndpointsData() async {
    final results = await Future.wait([
      apiService.getEndpointData(
          accessToken: _accessToken, endpoint: Endpoint.cases),
      apiService.getEndpointData(
          accessToken: _accessToken, endpoint: Endpoint.casesSuspected),
      apiService.getEndpointData(
          accessToken: _accessToken, endpoint: Endpoint.casesConfirmed),
      apiService.getEndpointData(
          accessToken: _accessToken, endpoint: Endpoint.deaths),
      apiService.getEndpointData(
          accessToken: _accessToken, endpoint: Endpoint.recovered),
    ]);
    return EndpointsData(
      values: {
        Endpoint.cases: results[0],
        Endpoint.casesSuspected: results[1],
        Endpoint.casesConfirmed: results[2],
        Endpoint.deaths: results[3],
        Endpoint.recovered: results[4],
      },
    );
  }
}
