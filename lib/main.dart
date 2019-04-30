import 'package:flutter/material.dart';
import 'package:flutter_bluetooth/bluetooth.dart';
import 'package:scoped_model/scoped_model.dart';

import 'util/theme.dart';
import 'screens/scan_page.dart';

void main() => runApp(HxFlutter());

class HxFlutter extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ScopedModel<Bluetooth>(
      model: Bluetooth(),
      child: MaterialApp(
        title: 'HxFlutter',
        theme: ThemeData(
            primarySwatch: HxColors.hxBlue
        ),
        home: ScanPage(),
      ),
    );
  }
}