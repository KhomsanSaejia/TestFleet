import 'package:fleetdemo/utility/my_style.dart';
import 'package:flutter/material.dart';

class ScreenTakeDownTablet extends StatefulWidget {
  const ScreenTakeDownTablet({Key? key}) : super(key: key);

  @override
  _ScreenTakeDownTabletState createState() => _ScreenTakeDownTabletState();
}

class _ScreenTakeDownTabletState extends State<ScreenTakeDownTablet> {
  @override
  Widget build(BuildContext context) {
    return Center(child: Mystyle().textCustom("ลงรับ",50.0,Colors.black));
  }
}
