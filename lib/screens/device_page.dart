import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:flutter_blue/flutter_blue.dart';

import '../model/bluetooth.dart';

class DevicePage extends StatelessWidget {
  DevicePage({Key key}) : super(key: key);

  _buildDeviceStateTile(BuildContext context, Bluetooth model) {
    return new ListTile(
        leading: (model.deviceState == BluetoothDeviceState.connected)
            ? const Icon(Icons.bluetooth_connected)
            : const Icon(Icons.bluetooth_disabled),
        title: new Text('Device is ${model.deviceState.toString().split('.')[1]}'),
        subtitle: new Text('${model.device.name}'),
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

  @override
  Widget build(BuildContext context) {
    return ScopedModelDescendant<Bluetooth>(
      builder: (context, child, model) {
        return new Scaffold(
          appBar: new AppBar(
            title: Text(model.device.name),
            actions: _buildActionButtons(model),
          ),
          body: new Stack(
            children: <Widget>[
              _buildDeviceStateTile(context, model),
            ]
          )
        );
      }
    );
  }
}