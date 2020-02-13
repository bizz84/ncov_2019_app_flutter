import 'package:flutter/material.dart';
import 'package:ncov_2019_app_flutter/app/api/api.dart';

class EndpointCardData {
  EndpointCardData(this.title, this.assetName);
  final String title;
  final String assetName;
}

class EndpointCard extends StatelessWidget {
  const EndpointCard({Key key, this.endpoint, this.value}) : super(key: key);
  final Endpoint endpoint;
  final int value;

  static Map<Endpoint, EndpointCardData> _cardsData = {
    Endpoint.cases: EndpointCardData('Cases', 'assets/count.png'),
    Endpoint.casesSuspected:
        EndpointCardData('Suspected cases', 'assets/suspect.png'),
    Endpoint.casesConfirmed:
        EndpointCardData('Confirmed cases', 'assets/fever.png'),
    Endpoint.deaths: EndpointCardData('Deaths', 'assets/death.png'),
    Endpoint.recovered: EndpointCardData('Recovered', 'assets/medicine.png'),
  };

  @override
  Widget build(BuildContext context) {
    final cardData = _cardsData[endpoint];
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
