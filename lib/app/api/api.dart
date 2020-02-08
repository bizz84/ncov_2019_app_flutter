import 'package:flutter/foundation.dart';
import 'package:ncov_2019_app_flutter/app/api/api_keys.dart';

enum Endpoint {
  cases,
  casesSuspected,
  casesConfirmed,
  deaths,
  recovered,
}

/// Uri builder class for the nCoV 2019 API
class API {
  API({
    @required this.baseUrl,
    @required this.baseAPIPath,
    @required this.port,
    @required this.apiKey,
  });
  final String baseUrl;
  final String baseAPIPath;
  final int port;
  final String apiKey;

  factory API.production() {
    return API(
      baseUrl: "apigw.nubentos.com",
      baseAPIPath: "t/nubentos.com/ncovapi/1.0.0",
      port: 443,
      apiKey: APIKeys.ncovAuthorizationKey,
    );
  }

  Uri tokenUri() => Uri(
        scheme: "https",
        host: baseUrl,
        port: port,
        path: 'token',
        queryParameters: {"grant_type": "client_credentials"},
      );

  Uri endpointUri(Endpoint endpoint) => Uri(
        scheme: "https",
        host: baseUrl,
        port: port,
        path: '$baseAPIPath/${_paths[endpoint]}',
      );

  static Map<Endpoint, String> _paths = {
    Endpoint.cases: 'cases',
    Endpoint.casesSuspected: 'cases/suspected',
    Endpoint.casesConfirmed: 'cases/confirmed',
    Endpoint.deaths: 'deaths',
    Endpoint.recovered: 'recovered',
  };
}
