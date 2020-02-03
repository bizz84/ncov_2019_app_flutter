import 'package:flutter/foundation.dart';
import 'package:ncov_2019_app_flutter/app/api/api_service.dart';

class APIRepository {
  APIRepository(this.apiService);
  final APIService apiService;

  String _token;

  Future<int> cases() async {
    if (_token == null) {
      _token = await apiService.getToken();
    }
    try {
      return await apiService.getCases(token: _token);
    } catch (e) {
      // if unauthorized, get token again
      _token = await apiService.getToken();
      return await apiService.getCases(token: _token);
    }
  }
}
