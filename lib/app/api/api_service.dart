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
    print(
        'Request ${api.token()} failed\nResponse: ${response.statusCode} ${response.reasonPhrase}');

    throw response;
  }

  Future<int> getData(
      {@required String token, @required Endpoint endpoint}) async {
    switch (endpoint) {
      case Endpoint.cases:
        return await getCases(token: token);
      case Endpoint.casesSuspected:
        return await getCasesSuspected(token: token);
      case Endpoint.casesConfirmed:
        return await getCasesConfirmed(token: token);
      case Endpoint.deaths:
        return await getDeaths(token: token);
      case Endpoint.recovered:
        return await getRecovered(token: token);
    }
    return null;
  }

  Future<int> getCases({@required String token}) async => await getValue(
        uri: api.cases(),
        token: token,
        responseJsonKey: 'cases',
      );

  Future<int> getCasesSuspected({@required String token}) async =>
      await getValue(
        uri: api.casesSuspected(),
        token: token,
        responseJsonKey: 'data',
      );

  Future<int> getCasesConfirmed({@required String token}) async =>
      await getValue(
        uri: api.casesConfirmed(),
        token: token,
        responseJsonKey: 'data',
      );

  Future<int> getDeaths({@required String token}) async => await getValue(
        uri: api.deaths(),
        token: token,
        responseJsonKey: 'data',
      );

  Future<int> getRecovered({@required String token}) async => await getValue(
        uri: api.recovered(),
        token: token,
        responseJsonKey: 'data',
      );

  Future<int> getValue(
      {@required Uri uri,
      @required String token,
      @required String responseJsonKey}) async {
    final response = await http.get(
      uri.toString(),
      headers: {'Authorization': 'Bearer $token'},
    );
    if (response.statusCode == 200) {
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
}
