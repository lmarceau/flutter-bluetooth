import 'dart:async';

import 'package:flutter_blue/flutter_blue.dart';
import 'package:scoped_model/scoped_model.dart';

class Bluetooth extends Model {

  static final Bluetooth _singleton = new Bluetooth._internal();

  factory Bluetooth() {
    return _singleton;
  }

  Bluetooth._internal();

  FlutterBlue _flutterBlue = FlutterBlue.instance;

  /// Scanning
  StreamSubscription _scanSubscription;
  Map<DeviceIdentifier, ScanResult> scanResults = new Map();
  bool isScanning = false;

  /// State
  StreamSubscription _stateSubscription;
  BluetoothState state = BluetoothState.unknown;

  /// Device
  BluetoothDevice device;
  bool get isConnected => (device != null);
  StreamSubscription deviceConnection;
  StreamSubscription deviceStateSubscription;
  List<BluetoothService> services = new List();
  Map<Guid, StreamSubscription> valueChangedSubscriptions = {};
  BluetoothDeviceState deviceState = BluetoothDeviceState.disconnected;

  void init() {
    // Immediately get the state of FlutterBlue
    _flutterBlue.state.then((s) {
      state = s;
      print('State init: $state');
      notifyListeners();
    });
    // Subscribe to state changes
    _stateSubscription = _flutterBlue.onStateChanged().listen((s) {
      state = s;
      print('State updated: $state');
      notifyListeners();
    });
  }

  void dispose() {
    _stateSubscription?.cancel();
    _stateSubscription = null;
    _scanSubscription?.cancel();
    _scanSubscription = null;
    deviceConnection?.cancel();
    deviceConnection = null;
  }

  void startScan() {
    scanResults = new Map();
    _scanSubscription = _flutterBlue
        .scan(
      timeout: const Duration(seconds: 5),
    )
        .listen((scanResult) {
      if(scanResult.advertisementData.localName.startsWith('HX-')) {
        scanResults[scanResult.device.id] = scanResult;
        notifyListeners();
      }
    }, onDone: stopScan);

    isScanning = true;
    notifyListeners();
  }

  void stopScan() {
    _scanSubscription?.cancel();
    _scanSubscription = null;
    isScanning = false;
    notifyListeners() ;
  }

  connect(BluetoothDevice d) async {
    device = d;
    print('Connect device');
    // Connect to device
    deviceConnection = _flutterBlue
        .connect(device, timeout: const Duration(seconds: 4))
        .listen(
      null,
      onDone: disconnect,
    );

    // Update the connection state immediately
    device.state.then((s) {
        deviceState = s;
        notifyListeners();
    });

    // Subscribe to connection changes
    deviceStateSubscription = device.onStateChanged().listen((s) {
      deviceState = s;
      notifyListeners();
      if (s == BluetoothDeviceState.connected) {
        device.discoverServices().then((s) {
          services = s;
          notifyListeners();
        });
      }
    });
  }

  disconnect() {
    // Remove all value changed listeners
    valueChangedSubscriptions.forEach((uuid, sub) => sub.cancel());
    valueChangedSubscriptions.clear();
    deviceStateSubscription?.cancel();
    deviceStateSubscription = null;
    deviceConnection?.cancel();
    deviceConnection = null;
    device = null;
    notifyListeners();
  }

  _readCharacteristic(BluetoothCharacteristic c) async {
    await device.readCharacteristic(c);
    notifyListeners();
  }

  _writeCharacteristic(BluetoothCharacteristic c) async {
    await device.writeCharacteristic(c, [0x12, 0x34],
        type: CharacteristicWriteType.withResponse);
    notifyListeners();
  }

  _readDescriptor(BluetoothDescriptor d) async {
    await device.readDescriptor(d);
    notifyListeners();
  }

  _writeDescriptor(BluetoothDescriptor d) async {
    await device.writeDescriptor(d, [0x12, 0x34]);
    notifyListeners();
  }

  _setNotification(BluetoothCharacteristic c) async {
    if (c.isNotifying) {
      await device.setNotifyValue(c, false);
      // Cancel subscription
      valueChangedSubscriptions[c.uuid]?.cancel();
      valueChangedSubscriptions.remove(c.uuid);
    } else {
      await device.setNotifyValue(c, true);
      // ignore: cancel_subscriptions
      final sub = device.onValueChanged(c).listen((d) {
        print('onValueChanged $d');
        notifyListeners();
      });
      // Add to map
      valueChangedSubscriptions[c.uuid] = sub;
    }
    notifyListeners();
  }

  _refreshDeviceState(BluetoothDevice d) async {
    var state = await d.state;
    deviceState = state;
    print('State refreshed: $deviceState');
    notifyListeners();
  }

}