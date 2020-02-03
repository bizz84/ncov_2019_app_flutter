import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:ncov_2019_app_flutter/app/api/api.dart';

/// Network service layer. Calls API methods and parses responses.
class APIService {
  APIService(this.api);
  final API api;

  Future<String> getToken() async {
    final response = await http.post(
      api.token().toString(),
      headers: {'Authorization': 'Basic ${api.apiKey}'},
    );
    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      print('$data');
      final accessToken = data['access_token'];
      if (accessToken != null) {
        return accessToken;
      }
      // else expired?
    }
    // TODO: Proper error handling
    throw response.statusCode;
  }

  // TODO: Stats and other endpoints
  Future<int> getCases({@required String token}) async {
    final response = await http.get(
      api.cases().toString(),
      headers: {'Authorization': 'Bearer $token'},
    );
    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body);
      print('$data');
      if (data.isNotEmpty) {
        final Map<String, dynamic> items = data[0];
        final int cases = items['cases'];
        if (cases != null) {
          return cases;
        }
      }
    }
    if (response.statusCode == 401) {
      print('401 Unauthorized');
    }
    // TODO: Proper error handling
    throw response.statusCode;
  }
}
