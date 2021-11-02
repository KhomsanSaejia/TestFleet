import 'package:fleetdemo/utility/my_style.dart';
import 'package:flutter/material.dart';

class ScreenReportTablet extends StatefulWidget {
  const ScreenReportTablet({Key? key}) : super(key: key);

  @override
  _ScreenReportTabletState createState() => _ScreenReportTabletState();
}

class _ScreenReportTabletState extends State<ScreenReportTablet> {
  @override
  Widget build(BuildContext context) {
    return Center(child: Mystyle().textCustom("รายงาน",50.0,Colors.black));
  }
}
