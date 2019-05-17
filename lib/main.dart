import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';

import 'model/bluetooth.dart';
import 'screens/scan_page.dart';
import 'util/theme.dart';

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