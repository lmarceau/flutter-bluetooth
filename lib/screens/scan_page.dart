import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:flutter_blue/flutter_blue.dart';

import '../model/bluetooth.dart';
import '../screens/device_page.dart';
import '../widgets/carousel.dart';

class ScanPage extends StatelessWidget {
  ScanPage({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ScopedModelDescendant<Bluetooth>(
      builder: (context, child, model) {
        return new Scaffold(
          appBar: new AppBar(
            title: Text("HxFlutter"),
          ),
          body: new Stack(
            children: <Widget>[
              (model.isScanning) ? _buildProgressBarTile() : new Container(),
              _buildBackgroundWidget(context, model),
            ],
          ),
        );
      },
    );
  }

  Widget _buildProgressBarTile() {
    return new LinearProgressIndicator();
  }

  Widget _buildBackgroundWidget(BuildContext context, Bluetooth model) {
    var items = model.scanResults.values.toList();
    if (items.isNotEmpty && !model.isScanning) {
      return Stack(
        children: <Widget>[
          _buildScanAgainButton(model),
          Carousel(onTap: () => onTap(context),),
        ],
      );
    } else if (model.isScanning) {
      return _buildScanningBackground();
    } else {
      startBluetooth(model);
      return _buildWaitingScanningBackground(model);
    }
  }

  Widget _buildScanAgainButton(Bluetooth model) {
    if (!model.isScanning) {
      return Container(
          padding: const EdgeInsets.all(15.0),
          alignment: Alignment.bottomRight,
          child: new FloatingActionButton(
            child: new Icon(Icons.search),
            onPressed: model.startScan,
          )
      );
    } else {
      return Container();
    }
  }

  Widget _buildScanningBackground() {
    return SizedBox.expand(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            new Image.asset("assets/images/bluetooth_scanning.png", height: 250),
            SizedBox(height: 20),
            new Text("Scanning...", style: TextStyle(fontSize: 13.0,fontWeight: FontWeight.bold)),
          ],
        )
    );
  }

  Widget _buildWaitingScanningBackground(Bluetooth model) {
    return SizedBox.expand(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          _buildScanButton(model),
          SizedBox(height: 20),
          new Text("Press the bouton to scan", style: TextStyle(fontSize: 13.0,fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }

  Widget _buildScanButton(Bluetooth model) {
    return Container(
      child: Ink.image(
        image: AssetImage("assets/images/bluetooth_icon.png"),
        fit: BoxFit.fill,
        child: InkWell( onTap: model.startScan,),
        height: 250,
        width: 250,
      ),
    );
  }

  void startBluetooth(Bluetooth model) {
    if (!model.isConnected && model.state != BluetoothState.on) {
      model.init();
    }
  }

  void onTap(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => DevicePage()),
    );
  }
}