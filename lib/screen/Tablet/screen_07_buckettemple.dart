import 'package:fleetdemo/utility/my_style.dart';
import 'package:flutter/material.dart';

class ScreenBucketTablet extends StatefulWidget {
  const ScreenBucketTablet({Key? key}) : super(key: key);

  @override
  _ScreenBucketTabletState createState() => _ScreenBucketTabletState();
}

class _ScreenBucketTabletState extends State<ScreenBucketTablet> {
  @override
  Widget build(BuildContext context) {
    return Center(child: Mystyle().textCustom("วัดถัง",50.0,Colors.black));
  }
}
