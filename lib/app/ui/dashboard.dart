import 'package:flutter/material.dart';
import 'package:ncov_2019_app_flutter/app/api/api.dart';
import 'package:ncov_2019_app_flutter/app/api/api_repository.dart';
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
  final _refreshIndicatorKey = GlobalKey<RefreshIndicatorState>();

  Data _data;
  DateTime _lastUpdated;
  bool _refreshInProgress = false;

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
      setState(() => _refreshInProgress = true);
      final apiRepository = Provider.of<APIRepository>(context, listen: false);
      final data = await apiRepository.getAllEndpointsData();
      setState(() {
        _data = data;
        _lastUpdated = DateTime.now();
      });
    } on SocketException catch (_) {
      PlatformAlertDialog(
        title: 'Connection Error',
        content: 'Could not retrieve data. Please try again later.',
        defaultActionText: 'OK',
      ).show(context);
    } catch (_) {
      PlatformAlertDialog(
        title: 'Unknown Error',
        content: 'Please try again later.',
        defaultActionText: 'OK',
      ).show(context);
    } finally {
      setState(() => _refreshInProgress = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final formatter = LastUpdatedDateFormatter(
        lastUpdated: _lastUpdated, refreshInProgress: _refreshInProgress);
    return Scaffold(
      appBar: AppBar(
        title: Text('nCoV 2019 Tracker'),
      ),
      body: RefreshIndicator(
        key: _refreshIndicatorKey,
        onRefresh: _refresh,
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
