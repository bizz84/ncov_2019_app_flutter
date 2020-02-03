import 'package:flutter/material.dart';
import 'package:ncov_2019_app_flutter/app/api/api_repository.dart';
import 'package:ncov_2019_app_flutter/app/api/api_service.dart';
import 'package:provider/provider.dart';

class Dashboard extends StatefulWidget {
  @override
  _DashboardState createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  @override
  void initState() {
    super.initState();
    getToken();
  }

  Future<void> getToken() async {
    try {
      final apiRepository = Provider.of<APIRepository>(context, listen: false);
      final cases = await apiRepository.cases();
      print('cases: $cases');
    } catch (e) {
      print(e.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Center(
        child: RaisedButton(
          child: Text('Get Token'),
          onPressed: () => getToken(),
        ),
      ),
    );
  }
}
