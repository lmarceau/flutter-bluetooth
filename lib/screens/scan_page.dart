import 'package:flutter/material.dart';
import 'package:flutter_blue/flutter_blue.dart';
import 'package:scoped_model/scoped_model.dart';

import '../bluetooth.dart';
import '../widgets/carousel.dart';

class ScanPage extends StatelessWidget {
  ScanPage({Key key}) : super(key: key);

  _buildScanningButton(Bluetooth bluetooth) {
    if (!bluetooth.isConnected && bluetooth.state != BluetoothState.on) {
      bluetooth.init();
    }

    if (bluetooth.isScanning) {
      return new FloatingActionButton(
        child: new Icon(Icons.stop),
        onPressed: bluetooth.stopScan,
        backgroundColor: Colors.red,
      );
    } else {
      return new FloatingActionButton(
          child: new Icon(Icons.search),
          onPressed: bluetooth.startScan);
    }
  }

  _buildActionButtons(Bluetooth bluetooth) {
    if (bluetooth.isConnected) {
      return <Widget>[
        new IconButton(
          icon: const Icon(Icons.cancel),
          onPressed: () => bluetooth.disconnect(),
        )
      ];
    }
  }

  _buildProgressBarTile() {
    return new LinearProgressIndicator();
  }

  @override
  Widget build(BuildContext context) {
    return ScopedModelDescendant<Bluetooth>(
      builder: (context, child, model) {
        return new Scaffold(
          appBar: new AppBar(
            title: Text("HxFlutter"),
            actions: _buildActionButtons(model),
          ),
          floatingActionButton: _buildScanningButton(model),
          body: new Stack(
            children: <Widget>[
              Carousel(),
              (model.isScanning) ? _buildProgressBarTile() : new Container(),
            ],
          ),
        );
      },
    );
  }
}