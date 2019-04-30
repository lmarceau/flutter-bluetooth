import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';

import '../bluetooth.dart';

class DevicePage extends StatelessWidget {
  DevicePage({Key key}) : super(key: key);

//  _buildDeviceStateTile() {
//    return new ListTile(
//        leading: (deviceState == BluetoothDeviceState.connected)
//            ? const Icon(Icons.bluetooth_connected)
//            : const Icon(Icons.bluetooth_disabled),
//        title: new Text('Device is ${deviceState.toString().split('.')[1]}'),
//        subtitle: new Text('${device.name}'),
//        trailing: new IconButton(
//          icon: const Icon(Icons.refresh),
//          onPressed: () => _refreshDeviceState(device),
//          color: Theme.of(context).iconTheme.color.withOpacity(0.5),
//        ));
//  }

  @override
  Widget build(BuildContext context) {
    return ScopedModelDescendant<Bluetooth>(
      builder: (context, child, model) {
        return new Container();
      }
    );
  }
}