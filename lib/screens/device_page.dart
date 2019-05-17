import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:flutter_blue/flutter_blue.dart';

import '../model/bluetooth.dart';

class DevicePage extends StatelessWidget {
  DevicePage({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ScopedModelDescendant<Bluetooth>(
        builder: (context, child, model) {
          return new Scaffold(
              appBar: new AppBar(
                title: Text(model.device != null ? model.device.name : "Disconnected"),
                actions: _buildActionButtons(model),
              ),
              body: new Column(
                  children: <Widget>[
                    _buildDeviceStateTile(context, model),
                    _buildDeviceMetrics(context, model)
                  ]
              )
          );
        }
    );
  }

  _buildActionButtons(Bluetooth model) {
    if (model.isConnected) {
      return <Widget>[
        new IconButton(
          icon: const Icon(Icons.cancel),
          onPressed: () => model.disconnect(),
        )
      ];
    }
  }

  _buildDeviceStateTile(BuildContext context, Bluetooth model) {
    return new ListTile(
        leading: (model.deviceState == BluetoothDeviceState.connected)
            ? const Icon(Icons.bluetooth_connected)
            : const Icon(Icons.bluetooth_disabled),
        title: new Text('Device is ${model.deviceState.toString().split('.')[1]}'),
    );
  }

  _buildDeviceMetrics(BuildContext context, Bluetooth model) {
    Column column = new Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        _buildMetric("Battery", model.battery != null ? model.battery.toString() : null, "%", "battery"),
        _buildMetric("Heart rate", model.heartRate != null ? model.heartRate.toString() : null, "BPM", "heart_rate"),
        _buildMetric("Respiration rate", model.respirationRate != null ? model.respirationRate.toString() : null, "Resp/min", "breathing_rate"),
        _buildMetric("Step count", model.stepCount != null ? model.stepCount.toString() : null, null, "steps"),
        _buildMetric("Activity", model.activity != null ? model.activity.toString() : null, "G", "activity"),
        _buildMetric("Cadence", model.cadence != null ? model.cadence.toString() : null, "Steps/min", "cadence")
      ],
    );
    return column != null ? column : new Container();
  }

  _buildMetric(String name, String value, String unit, String image) {
    return new ListTile(
      leading: new Image.asset("assets/images/"+ image + ".png", height: 30),
      title: Text(name),
      subtitle: unit != null ? Text(unit) : new Text(""),
      trailing: value != null ? Text(value) : new Text(""),
    );
  }
}