import 'package:flutter/material.dart';
import 'package:ncov_2019_app_flutter/app/api/api.dart';
import 'package:ncov_2019_app_flutter/app/api/api_repository.dart';
import 'package:provider/provider.dart';

class Dashboard extends StatefulWidget {
  @override
  _DashboardState createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  final _refreshIndicatorKey = GlobalKey<RefreshIndicatorState>();

  Data _data;

  static Map<Endpoint, String> _titles = {
    Endpoint.cases: 'Cases',
    Endpoint.casesSuspected: 'Suspected cases',
    Endpoint.casesConfirmed: 'Confirmed cases',
    Endpoint.deaths: 'Deaths',
    Endpoint.recovered: 'Recovered',
  };

  @override
  void initState() {
    super.initState();
    _updateData();
  }

  Future<void> _refresh() async {
    _refreshIndicatorKey.currentState.show();
    await _updateData();
  }

  Future<void> _updateData() async {
    try {
      final apiRepository = Provider.of<APIRepository>(context, listen: false);
      final data = await apiRepository.getAllEndpointsData();
      setState(() => _data = data);
    } catch (e) {
      // TODO: Show alert
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('nCoV 2019 Tracker'),
      ),
      body: RefreshIndicator(
        key: _refreshIndicatorKey,
        onRefresh: _refresh,
        child: ListView(
          children: [
            for (var endpoint in Endpoint.values)
              APIResultCard(
                title: _titles[endpoint],
                value: _data != null ? _data.values[endpoint] : null,
              ),
          ],
        ),
      ),
    );
  }
}

class APIResultCard extends StatelessWidget {
  const APIResultCard({Key key, this.title, this.value}) : super(key: key);
  final String title;
  final int value;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
      child: Card(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            children: <Widget>[
              Text(title, style: Theme.of(context).textTheme.headline),
              Expanded(child: Container()),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: <Widget>[
                  Text(
                    value != null ? value.toString() : '',
                    style: Theme.of(context).textTheme.display1,
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
