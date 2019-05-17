import 'dart:async';

import 'package:flutter_blue/flutter_blue.dart';
import 'package:scoped_model/scoped_model.dart';

import '../util/constants.dart';

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

  /// Device metrics
  int heartRate;
  int respirationRate;
  int stepCount;
  double activity;
  int cadence;
  int battery;

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
        .scan(timeout: const Duration(seconds: 5),)
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
    print('Connecting device ' + d.name);
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
          _setNotifications();
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

  _setNotifications() {
    _setNotification(_getCharacteristic(heartRateMeasurementUUID));
    _setNotification(_getCharacteristic(batteryMeasurementUUID));
    _setNotification(_getCharacteristic(respirationRateMeasurementUUID));
    _setNotification(_getCharacteristic(accelerometerMeasurementUUID));
  }

  _getCharacteristic(String charUUID) {
    BluetoothCharacteristic characteristic;
    for (BluetoothService s in services) {
      for (BluetoothCharacteristic c in s.characteristics) {
        if (c.uuid.toString() == charUUID) {
          characteristic = c;
        }
      }
    }
    return characteristic;
  }

  _setNotification(BluetoothCharacteristic characteristic) async {
    if (characteristic != null) {
      await device.setNotifyValue(characteristic, true);
      // ignore: cancel_subscriptions
      final sub = device.onValueChanged(characteristic).listen((d) {
        _onValuesChanged(characteristic);
        notifyListeners();
      });
      // Add to map
      valueChangedSubscriptions[characteristic.uuid] = sub;
      notifyListeners();
    }
  }

  _onValuesChanged(BluetoothCharacteristic characteristic) {
    List<int> data = characteristic.value;
    String uuid = characteristic.uuid.toString();
    print('onValuesChanged ' + characteristic.value.toString() + " " + uuid);

    if (uuid == heartRateMeasurementUUID) {
      heartRate = data[1];
    } else if (uuid == respirationRateMeasurementUUID) {
      respirationRate = data[1];

    } else if (uuid == accelerometerMeasurementUUID) {
      int flag = data[0];
      int dataIndex = 1;

      bool isStepCountPresent = (flag & 0x01) != 0;
      bool isActivityPresent = (flag & 0x02) != 0;
      bool isCadencePresent = (flag & 0x04) != 0;
      if (isStepCountPresent) {
        stepCount = data[dataIndex];
        dataIndex = dataIndex + 2;
      }

      if (isActivityPresent) {
        activity = data[dataIndex]/256;
        dataIndex = dataIndex + 2;
      }

      if (isCadencePresent) {
        cadence = data[dataIndex];
      }

    } else if (uuid == batteryMeasurementUUID) {
      battery = data[0];
    }
  }
}