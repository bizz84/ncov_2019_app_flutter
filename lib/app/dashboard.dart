import 'package:flutter/material.dart';
import 'package:ncov_2019_app_flutter/app/api/api.dart';
import 'package:ncov_2019_app_flutter/app/api/api_repository.dart';
import 'package:provider/provider.dart';

class Dashboard extends StatefulWidget {
  @override
  _DashboardState createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  @override
  void initState() {
    super.initState();
  }

  static Map<Endpoint, String> _titles = {
    Endpoint.cases: 'Cases',
    Endpoint.casesSuspected: 'Cases suspected',
    Endpoint.casesConfirmed: 'Cases confirmed',
    Endpoint.deaths: 'Deaths',
    Endpoint.recovered: 'Recovered',
  };

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('nCoV 2019 Tracker'),
      ),
      body: Column(
        children: [
          for (var endpoint in Endpoint.values)
            APIResultCard(
              title: _titles[endpoint],
              endpoint: endpoint,
            ),
        ],
      ),
    );
  }
}

class APIResultCard extends StatefulWidget {
  const APIResultCard({Key key, this.title, this.endpoint}) : super(key: key);
  final String title;
  final Endpoint endpoint;

  @override
  _APIResultCardState createState() => _APIResultCardState();
}

class _APIResultCardState extends State<APIResultCard> {
  int value;

  @override
  void initState() {
    super.initState();
    updateData();
  }

  Future<void> updateData() async {
    try {
      final apiRepository = Provider.of<APIRepository>(context, listen: false);
      final data = await apiRepository.getData(widget.endpoint);
      setState(() => value = data);
    } catch (e) {
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Card(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            children: <Widget>[
              Text(widget.title, style: Theme.of(context).textTheme.headline),
              Expanded(child: Container()),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: <Widget>[
                  Text(
                    value != null ? value.toString() : '',
                    style: Theme.of(context).textTheme.display1,
                  ),
                  RaisedButton(
                    child: Text('Refresh'),
                    onPressed: updateData,
                  )
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
