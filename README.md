WIP (Work in progress)

# Flutter Bluetooth

A basic Flutter project to try the flutter_blue plugin. [Flutter](http://www.flutter.io) is a new 
mobile SDK to help developers build modern apps for iOS and Android.

## Prerequisites

* Flutter 1.2.2
* FlutterBlue plugin 0.5.0

## Getting started

This project was made to use the public BLE services of [Hexoskin](https://www.hexoskin.com/) devices. The 
Hexoskin BLE follows the [GATT](https://www.bluetooth.com/specifications/gatt/generic-attributes-overview/) protocol with battery, heart rate, respiration and accelerometer 
services.

## Architecture

Scoped_model package was used to manage the bluetooth state. 

## Acknowledgment

This project is initially based on the flutter_blue example from [pauldemarco](https://github.com/pauldemarco/flutter_blue/tree/master/example).

You can also find Hexoskin iOS and Android public example projects on [BitBucket](https://bitbucket.org/carre/hexoskin-smart-demo/src/master/).
