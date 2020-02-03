import 'package:ncov_2019_app_flutter/app/api/api.dart';
import 'package:ncov_2019_app_flutter/app/api/api_service.dart';

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
}
