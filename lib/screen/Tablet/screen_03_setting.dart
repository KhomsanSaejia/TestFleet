import 'package:fleetdemo/utility/my_style.dart';
import 'package:flutter/material.dart';

class ScreenSettingTablet extends StatefulWidget {
  const ScreenSettingTablet({Key? key}) : super(key: key);

  @override
  _ScreenSettingTabletState createState() => _ScreenSettingTabletState();
}

class _ScreenSettingTabletState extends State<ScreenSettingTablet> {
  @override
  Widget build(BuildContext context) {
    return Center(child: Mystyle().textCustom("ตั้งค่า", 50.0, Colors.black));
  }
}
