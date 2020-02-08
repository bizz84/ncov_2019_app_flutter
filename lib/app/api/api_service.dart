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
      api.tokenUri().toString(),
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
    print(
        'Request ${api.tokenUri()} failed\nResponse: ${response.statusCode} ${response.reasonPhrase}');

    throw response;
  }

  Future<int> getEndpointData({
    @required String token,
    @required Endpoint endpoint,
  }) async {
    final uri = api.endpointUri(endpoint);
    final response = await http.get(
      uri.toString(),
      headers: {'Authorization': 'Bearer $token'},
    );
    if (response.statusCode == 200) {
      final responseJsonKey = _responseJsonKeys[endpoint];
      final List<dynamic> data = json.decode(response.body);
      print('$data');
      if (data.isNotEmpty) {
        final Map<String, dynamic> items = data[0];
        final int result = items[responseJsonKey];
        if (result != null) {
          return result;
        }
      }
    }
    print(
        'Request $uri failed\nResponse: ${response.statusCode} ${response.reasonPhrase}');
    throw response;
  }

  static Map<Endpoint, String> _responseJsonKeys = {
    Endpoint.cases: 'cases',
    Endpoint.casesSuspected: 'data',
    Endpoint.casesConfirmed: 'data',
    Endpoint.deaths: 'data',
    Endpoint.recovered: 'data',
  };
}
