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
      // TODO: show scan for hexoskin devices image and text
      return Text("");
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
          height: 450.0,
          child: PageView.builder(
            controller: PageController(viewportFraction: 0.85),
            itemBuilder: (BuildContext context, int itemIndex) {
                return _buildCarouselItem(context, scanResults.elementAt(itemIndex), itemIndex);
            },
            itemCount: scanResults.length,
          ),
        ),
        Spacer(flex: 5),
      ],
    );
  }

  Widget _buildCarouselTitle(BuildContext context, List<ScanResult> scanResults) {
    var title = scanResults.length == 1 ? "Found Hexoskin device" : "Found Hexoskin devices";
    return Text(title, style: TextStyle(fontSize: 20.0,fontWeight: FontWeight.bold));
  }

  Widget _buildCarouselItem(BuildContext context, ScanResult result, int itemIndex) {
    return Stack(
      alignment: Alignment.topCenter,
      children: <Widget>[
        _buildButtonBoxOutside(result),
        _buildButtonBoxInside(),
        Column(
          children: <Widget>[
            Spacer(flex: 4),
            new Image.asset("assets/images/hx_device.png", height: 300),
            Spacer(),
            _buildButtonBoxTitle(result.device.name),
            Spacer(flex: 2),
          ],
        ),
        InkWell(
          onTap: () {
              onTap();
              print("Carousel was tapped with device: " + result.device.name);
            },
        ),
      ],
    );
  }

  Widget _buildButtonBoxOutside(ScanResult result) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 10.0),
      padding: const EdgeInsets.all(15.0),
      decoration: BoxDecoration(
        color: Colors.white10,
        borderRadius: BorderRadius.circular(10.0),
        shape: BoxShape.rectangle,
        border: new Border.all(
            color: Colors.grey,
            width: 1.0,
            style: BorderStyle.solid
        ),
      ),
    );
  }

  Widget _buildButtonBoxInside() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 15.0),
      padding: const EdgeInsets.all(15.0),
      decoration: BoxDecoration(
        color: Colors.white10,
        borderRadius: BorderRadius.circular(10.0),
        shape: BoxShape.rectangle,
        boxShadow: <BoxShadow>[
          new BoxShadow(
            color: Colors.black.withOpacity(0.2),
            blurRadius: 5.0,
          ),
        ],
      ),
    );
  }

  Widget _buildButtonBoxTitle(String deviceName) {
    return Column(
      children: <Widget>[
        Padding(
          padding: EdgeInsets.all(12.0),
          child: Text(
            deviceName,
            style: TextStyle(
                fontSize: 20.0,
                fontWeight: FontWeight.bold,
                color: Colors.black),
          ),
        )
      ],
    );
  }
}