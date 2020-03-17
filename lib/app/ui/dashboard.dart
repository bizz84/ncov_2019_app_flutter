import 'package:flutter/material.dart';
import 'package:ncov_2019_app_flutter/app/services/api.dart';
import 'package:ncov_2019_app_flutter/app/repositories/data.dart';
import 'package:ncov_2019_app_flutter/app/repositories/data_repository.dart';
import 'package:ncov_2019_app_flutter/app/ui/endpoint_card.dart';
import 'package:ncov_2019_app_flutter/app/ui/last_updated_status_label.dart';
import 'package:ncov_2019_app_flutter/app/ui/platform_alert_dialog.dart';
import 'package:provider/provider.dart';
import 'dart:io';

class Dashboard extends StatefulWidget {
  @override
  _DashboardState createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  Data _data;
  bool _refreshInProgress = false;

  @override
  void initState() {
    super.initState();
    final dataRepository = Provider.of<DataRepository>(context, listen: false);
    _data = dataRepository.getAllEndpointsCachedData();
    _updateData(showAlertOnError: false);
  }

  Future<void> _updateData({bool showAlertOnError = true}) async {
    try {
      setState(() => _refreshInProgress = true);
      final dataRepository =
          Provider.of<DataRepository>(context, listen: false);
      final data = await dataRepository.getAllEndpointsData();
      setState(() => _data = data);
    } on SocketException catch (_) {
      if (showAlertOnError) {
        PlatformAlertDialog(
          title: 'Connection Error',
          content: 'Could not retrieve data. Please try again later.',
          defaultActionText: 'OK',
        ).show(context);
      }
    } catch (_) {
      if (showAlertOnError) {
        PlatformAlertDialog(
          title: 'Unknown Error',
          content: 'Please try again later.',
          defaultActionText: 'OK',
        ).show(context);
      }
    } finally {
      setState(() => _refreshInProgress = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final formatter = LastUpdatedDateFormatter(
        lastUpdated: _data?.updateTime, refreshInProgress: _refreshInProgress);
    return Scaffold(
      appBar: AppBar(
        title: Text('Coronavirus Tracker'),
      ),
      body: RefreshIndicator(
        onRefresh: _updateData,
        child: ListView(
          children: [
            LastUpdatedStatusLabel(
                labelText: formatter.lastUpdatedStatusText()),
            for (var endpoint in Endpoint.values)
              EndpointCard(
                endpoint: endpoint,
                value: _data != null ? _data.values[endpoint] : null,
              ),
          ],
        ),
      ),
    );
  }
}
