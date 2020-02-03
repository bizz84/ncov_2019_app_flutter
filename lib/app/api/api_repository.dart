import 'package:ncov_2019_app_flutter/app/api/api.dart';
import 'package:ncov_2019_app_flutter/app/api/api_service.dart';

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

  Future<int> getData(Endpoint endpoint) async {
    if (_token == null) {
      _token = await apiService.getToken();
    }
    try {
      return await apiService.getData(token: _token, endpoint: endpoint);
    } catch (e) {
      // if unauthorized, get token again
      _token = await apiService.getToken();
      return await apiService.getData(token: _token, endpoint: endpoint);
    }
  }

  Future<Data> getAllData() async {
    if (_token == null) {
      _token = await apiService.getToken();
    }
    try {
      return await _getAllData();
    } catch (e) {
      // if unauthorized, get token again
      _token = await apiService.getToken();
      return await _getAllData();
    }
  }

  Future<Data> _getAllData() async {
    final results = await Future.wait([
      apiService.getData(token: _token, endpoint: Endpoint.cases),
      apiService.getData(token: _token, endpoint: Endpoint.casesSuspected),
      apiService.getData(token: _token, endpoint: Endpoint.casesConfirmed),
      apiService.getData(token: _token, endpoint: Endpoint.deaths),
      apiService.getData(token: _token, endpoint: Endpoint.recovered),
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
