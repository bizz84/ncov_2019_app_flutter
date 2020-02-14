import 'package:ncov_2019_app_flutter/app/api/api.dart';
import 'package:ncov_2019_app_flutter/app/api/api_service.dart';
import 'package:http/http.dart';
import 'dart:io';

class Data {
  Data({this.values});

  final Map<Endpoint, int> values;
  int get cases => values[Endpoint.cases];
  int get casesSuspected => values[Endpoint.casesSuspected];
  int get casesConfirmed => values[Endpoint.casesConfirmed];
  int get deaths => values[Endpoint.deaths];
  int get recovered => values[Endpoint.recovered];

  @override
  String toString() =>
      'cases: $cases, suspected: $casesSuspected, confirmed: $casesConfirmed, deaths: $deaths, recovered: $recovered';
}

class APIRepository {
  APIRepository(this.apiService);
  final APIService apiService;

  String _token;

  Future<T> getDataRefreshingToken<T>({Future<T> Function() onGetData}) async {
    if (_token == null) {
      _token = await apiService.getToken();
    }
    try {
      return await onGetData();
    } on SocketException catch (_) {
      rethrow;
    } on Response catch (response) {
      // if unauthorized, get token again
      if (response.statusCode == 401) {
        _token = await apiService.getToken();
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
  Future<Data> getAllEndpointsData() async =>
      await getDataRefreshingToken<Data>(
        onGetData: () => _getAllData(),
      );

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
    return Data(values: {
      Endpoint.cases: results[0],
      Endpoint.casesSuspected: results[1],
      Endpoint.casesConfirmed: results[2],
      Endpoint.deaths: results[3],
      Endpoint.recovered: results[4],
    });
  }
}
