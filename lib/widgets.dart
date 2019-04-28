import 'package:flutter/material.dart';
import 'package:flutter_blue/flutter_blue.dart';

class Carousel extends StatelessWidget {
  const Carousel({Key key, this.scanResults, this.onTap}) : super(key: key);

  final List<ScanResult> scanResults;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    if (scanResults.isNotEmpty) {
      return Scaffold(
          body: _buildCarousel(context, scanResults)
      );
    } else {
      return Text("Scan for devices");
    }
  }

  Widget _buildCarousel(BuildContext context, List<ScanResult> scanResults) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        Spacer(),
        _buildCarouselTitle(context, scanResults),
        Spacer(),
        SizedBox(
          height: 400.0,
          child: PageView.builder(
            // TODO: store this controller in a State to save the carousel scroll position
            controller: PageController(viewportFraction: 0.8),
            itemBuilder: (BuildContext context, int itemIndex) {
              if (itemIndex < scanResults.length) {
                return _buildCarouselItem(
                    context, scanResults.elementAt(itemIndex), itemIndex);
              } else {
                return Text("");
              }
            },
          ),
        ),
        Spacer(flex: 5),
      ],
    );
  }

  Widget _buildCarouselTitle(BuildContext context, List<ScanResult> scanResults) {
    var title = scanResults.length == 1 ? "Hexoskin device" : "Hexoskin devices";
    return Text(title, style: TextStyle(fontSize: 20.0,fontWeight: FontWeight.bold));
  }

  Widget _buildCarouselItem(BuildContext context, ScanResult result, int itemIndex) {
    return Padding(
        padding: EdgeInsets.symmetric(horizontal: 4.0),
        child: Stack(
          alignment: Alignment.topCenter,
          children: <Widget>[
            Container(
              decoration: BoxDecoration(
                color: Colors.grey,
                borderRadius: BorderRadius.all(Radius.circular(4.0)),
              ),
            ),
            Column(
              children: <Widget>[
                _buildTitle(context, result.device.name),
                new Image.asset("assets/hx_device.png"),
              ],
            )
          ],
        )
    );
  }

  Widget _buildTitle(BuildContext context, String deviceName) {
    return Column(
      children: <Widget>[
        Padding(
          padding: EdgeInsets.all(12.0),
          child: Text(deviceName, style: TextStyle(fontSize: 20.0,fontWeight: FontWeight.bold),),
        )
      ],
    );
  }
}