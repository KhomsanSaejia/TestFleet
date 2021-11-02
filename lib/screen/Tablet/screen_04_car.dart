import 'package:fleetdemo/utility/my_style.dart';
import 'package:flutter/material.dart';

class ScreenCarTablet extends StatefulWidget {
  const ScreenCarTablet({ Key? key }) : super(key: key);

  @override
  _ScreenCarTabletState createState() => _ScreenCarTabletState();
}

class _ScreenCarTabletState extends State<ScreenCarTablet> {
  @override
  Widget build(BuildContext context) {
    return Center(child: Mystyle().textCustom("รถ",50.0,Colors.black));
  }
}