import 'package:flutter/foundation.dart';
import 'package:ncov_2019_app_flutter/app/api/api_keys.dart';

enum Endpoint { cases, casesSuspected, casesConfirmed, deaths, recovered }

/// Uri builder class for the nCoV 2019 API
class API {
  API({@required this.baseUrl, @required this.port, @required this.apiKey});
  final String baseUrl;
  final int port;
  final String apiKey;

  factory API.production() {
    return API(
      apiKey: APIKeys.ncovAuthorizationKey,
      baseUrl: "apigw.nubentos.com",
      port: 443,
    );
  }

  static Map<Endpoint, String> _paths = {
    Endpoint.cases: 'cases',
    Endpoint.casesSuspected: 'cases/suspected',
    Endpoint.casesConfirmed: 'cases/confirmed',
    Endpoint.deaths: 'deaths',
    Endpoint.recovered: 'recovered',
  };

  Uri token() => Uri(
        scheme: "https",
        host: baseUrl,
        port: port,
        path: 'token',
        queryParameters: {"grant_type": "client_credentials"},
      );

  Uri cases() => _buildEndpointUri(Endpoint.cases);
  Uri casesSuspected() => _buildEndpointUri(Endpoint.casesSuspected);
  Uri casesConfirmed() => _buildEndpointUri(Endpoint.casesConfirmed);
  Uri deaths() => _buildEndpointUri(Endpoint.deaths);
  Uri recovered() => _buildEndpointUri(Endpoint.recovered);

  Uri _buildEndpointUri(Endpoint endpoint,
      {Map<String, dynamic> queryParameters}) {
    return Uri(
      scheme: "https",
      host: baseUrl,
      port: port,
      path: 't/nubentos.com/ncovapi/1.0.0/${_paths[endpoint]}',
      queryParameters: queryParameters,
    );
  }
}
