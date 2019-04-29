import 'package:flutter/material.dart';

import 'util/theme.dart';
import 'scan_page.dart';

void main() => runApp(HxFlutter());

class HxFlutter extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'HxFlutter',
      theme: ThemeData(
          primarySwatch: HxColors.hxBlue
      ),
      home: ScanPage(title: 'HxFlutter'),
    );
  }
}
