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
  API({@required this.apiKey});
  final String apiKey;
  static final String baseUrl = "apigw.nubentos.com";
  static final String baseAPIPath = "t/nubentos.com/ncovapi/1.0.0";
  static final int port = 443;

  factory API.production() {
    return API(apiKey: APIKeys.ncovProductionKey);
  }
  factory API.sandbox() {
    return API(apiKey: APIKeys.ncovSandboxKey);
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
