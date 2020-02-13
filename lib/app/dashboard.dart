import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:ncov_2019_app_flutter/app/api/api.dart';
import 'package:ncov_2019_app_flutter/app/api/api_repository.dart';
import 'package:provider/provider.dart';

class CardData {
  CardData(this.title, this.assetName);
  final String title;
  final String assetName;
}

class Dashboard extends StatefulWidget {
  @override
  _DashboardState createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  final _refreshIndicatorKey = GlobalKey<RefreshIndicatorState>();

  Data _data;
  DateTime _lastUpdated;

  static Map<Endpoint, CardData> _cardsData = {
    Endpoint.cases: CardData('Cases', 'assets/count.png'),
    Endpoint.casesSuspected: CardData('Suspected cases', 'assets/suspect.png'),
    Endpoint.casesConfirmed: CardData('Confirmed cases', 'assets/fever.png'),
    Endpoint.deaths: CardData('Deaths', 'assets/death.png'),
    Endpoint.recovered: CardData('Recovered', 'assets/medicine.png'),
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
      setState(() {
        _data = data;
        _lastUpdated = DateTime.now();
      });
    } catch (e) {
      // TODO: Show alert
      print(e);
    }
  }

  String _formatLastUpdated(DateTime date) {
    final formatter = DateFormat.jms();
    final formatted = formatter.format(date);
    return 'Last updated: $formatted';
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
            if (_lastUpdated != null)
              LastUpdatedLabel(labelText: _formatLastUpdated(_lastUpdated)),
            for (var endpoint in Endpoint.values)
              APIResultCard(
                cardData: _cardsData[endpoint],
                value: _data != null ? _data.values[endpoint] : null,
              ),
          ],
        ),
      ),
    );
  }
}

class LastUpdatedLabel extends StatelessWidget {
  const LastUpdatedLabel({Key key, this.labelText}) : super(key: key);
  final String labelText;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Text(
        labelText,
        textAlign: TextAlign.center,
      ),
    );
  }
}

class APIResultCard extends StatelessWidget {
  const APIResultCard({Key key, this.cardData, this.value}) : super(key: key);
  final CardData cardData;
  final int value;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
      child: Card(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(cardData.title, style: Theme.of(context).textTheme.headline),
              SizedBox(height: 4),
              SizedBox(
                height: 52,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Image.asset(cardData.assetName),
                    Text(
                      value != null ? value.toString() : '',
                      style: Theme.of(context).textTheme.display1,
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
