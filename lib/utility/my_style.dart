// ignore_for_file: sized_box_for_whitespace

import 'package:flutter/material.dart';

class Mystyle {
  Container showLogoTablet() {
    return Container(
      width: 500.0,
      child: Image.asset('images/LOGO-INA-small.png'),
    );
  }

  Container showLogoMobile() {
    return Container(
      width: 300.0,
      child: Image.asset('images/LOGO-INA-small.png'),
    );
  }

  Container showLogoWeb() {
    return Container(
      width: 700.0,
      child: Image.asset('images/LOGO-INA-small.png'),
    );
  }

  Text textHeader(String data) {
    return Text(
      data,
      style: const TextStyle(
          fontFamily: "Sarabun", fontSize: 20, fontWeight: FontWeight.bold),
    );
  }

  Widget textCustom(String _data, double _size, Color _color) {
    return Text(
      _data,
      style: TextStyle(
          fontFamily: "Sarabun",
          fontSize: _size,
          fontWeight: FontWeight.bold,
          color: _color),
    );
  }

  Widget showprogress() {
    return const Center(
      child: CircularProgressIndicator(),
    );
  }

  Widget mySizeBox(double _width, double _hight) {
    return SizedBox(
      height: _hight,
      width: _width,
    );
  }

  myBoxDecoration() {
    return BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10.0),
        boxShadow: const [
          BoxShadow(
              color: Color.fromRGBO(143, 148, 251, .2),
              blurRadius: 20.0,
              offset: Offset(0, 10))
        ]);
  }

  myTextFieldStyle() {
    return const TextStyle(
        fontFamily: "Sarabun", fontSize: 20, fontWeight: FontWeight.bold);
  }

  Mystyle();
}
