import 'package:flutter/foundation.dart';
import 'package:ncov_2019_app_flutter/app/api/api_keys.dart';

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

  Uri token() => _buildUri(
        path: "token",
        queryParameters: {
          "grant_type": "client_credentials",
        },
      );

  Uri cases() => _buildUri(
        path: 't/nubentos.com/ncovapi/1.0.0/cases',
      );

  Uri casesSuspected() => _buildUri(
        path: 't/nubentos.com/ncovapi/1.0.0/cases/suspected',
      );

  Uri casesConfirmed() => _buildUri(
        path: 't/nubentos.com/ncovapi/1.0.0/cases/confirmed',
      );

  Uri deaths() => _buildUri(
        path: 't/nubentos.com/ncovapi/1.0.0/deaths',
      );

  Uri recovered() => _buildUri(
        path: 't/nubentos.com/ncovapi/1.0.0/recovered',
      );

  Uri _buildUri({
    String path,
    Map<String, dynamic> queryParameters,
  }) {
    return Uri(
      scheme: "https",
      host: baseUrl,
      port: port,
      path: path,
      queryParameters: queryParameters,
    );
  }
}
