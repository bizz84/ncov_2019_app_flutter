import 'package:flutter/material.dart';
import 'package:intl/date_symbol_data_local.dart';
//import 'package:intl/intl.dart';
import 'package:ncov_2019_app_flutter/app/api/api.dart';
import 'package:ncov_2019_app_flutter/app/api/api_repository.dart';
import 'package:ncov_2019_app_flutter/app/api/api_service.dart';
import 'package:ncov_2019_app_flutter/app/ui/dashboard.dart';
import 'package:provider/provider.dart';

Future<void> main() async {
  //Intl.defaultLocale = 'en_GB';
  await initializeDateFormatting();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Provider<APIRepository>(
      create: (_) => APIRepository(APIService(API.sandbox())),
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Flutter Demo',
        theme: ThemeData.dark().copyWith(
          scaffoldBackgroundColor: Color(0xFF101010),
          cardColor: Color(0xFF222222),
        ),
        home: Dashboard(),
      ),
    );
  }
}
