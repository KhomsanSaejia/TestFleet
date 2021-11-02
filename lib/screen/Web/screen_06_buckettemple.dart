import 'package:fleetdemo/utility/my_style.dart';
import 'package:flutter/material.dart';

class ScreenBucketWeb extends StatefulWidget {
  const ScreenBucketWeb({Key? key}) : super(key: key);

  @override
  _ScreenBucketWebState createState() => _ScreenBucketWebState();
}

class _ScreenBucketWebState extends State<ScreenBucketWeb> {
  @override
  Widget build(BuildContext context) {
    return Center(child: Mystyle().textCustom("วัดถัง",50.0,Colors.black));
  }
}
