// ignore_for_file: avoid_print

import 'package:fleetdemo/screen/Tablet/screen_02_home.dart';
import 'package:fleetdemo/utility/dialog.dart';
import 'package:fleetdemo/utility/my_style.dart';
import 'package:flutter/material.dart';

class ScreenLoginTablet extends StatefulWidget {
  const ScreenLoginTablet({Key? key}) : super(key: key);

  @override
  _ScreenLoginTabletState createState() => _ScreenLoginTabletState();
}

class _ScreenLoginTabletState extends State<ScreenLoginTablet> {
  String? username, password;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.grey.shade200,
        body: Center(
          child: SingleChildScrollView(
            child: Column(
              children: <Widget>[
                Mystyle().showLogoTablet(),
                Padding(
                  padding: const EdgeInsets.all(30.0),
                  child: Column(
                    children: <Widget>[
                      Container(
                        padding: const EdgeInsets.all(5),
                        decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(10),
                            boxShadow: const [
                              BoxShadow(
                                  color: Color.fromRGBO(143, 148, 251, .2),
                                  blurRadius: 20.0,
                                  offset: Offset(0, 10))
                            ]),
                        child: Column(
                          children: <Widget>[
                            Container(
                              width: 500,
                              padding: const EdgeInsets.all(8.0),
                              decoration: BoxDecoration(
                                  border: Border(
                                      bottom: BorderSide(
                                          color: Colors.grey.shade100))),
                              child: TextField(
                                onChanged: (value) => username = value.trim(),
                                decoration: InputDecoration(
                                    prefixIcon:
                                        const Icon(Icons.account_circle),
                                    border: InputBorder.none,
                                    hintText: "ชื่อผู้ใช้งาน",
                                    hintStyle:
                                        TextStyle(color: Colors.grey[400])),
                              ),
                            ),
                            Container(
                              width: 500,
                              padding: const EdgeInsets.all(8.0),
                              child: TextField(
                                obscureText: true,
                                onChanged: (value) => password = value.trim(),
                                decoration: InputDecoration(
                                    // suffixIcon:
                                    //     const Icon(Icons.remove_red_eye),
                                    prefixIcon: const Icon(Icons.lock),
                                    border: InputBorder.none,
                                    hintText: "รหัสผ่าน",
                                    hintStyle:
                                        TextStyle(color: Colors.grey[400])),
                              ),
                            )
                          ],
                        ),
                      ),
                      const SizedBox(
                        height: 30,
                      ),
                      InkWell(
                        onTap: () {
                          print("username = $username password = $password");
                          if (username == null ||
                              username!.isEmpty ||
                              password == null ||
                              password!.isEmpty) {
                            normalDialog(context, "กรุณากรอกข้อมูลให้ครบ");
                          } else {
                            if (username == "admin" && password == "1234") {
                              print("Admin user");
                              routetoservice(const ScreenHomeTablet());
                            } else {
                              print("Check server");
                            }
                          }
                        },
                        child: Container(
                          width: 500,
                          height: 50,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              gradient: const LinearGradient(colors: [
                                Color.fromRGBO(184, 188, 255, 1),
                                Color.fromRGBO(184, 188, 255, .6),
                              ])),
                          child: Center(
                              child:
                                  Mystyle().textHeader("เข้าสู่ระบบ")),
                        ),
                      )
                    ],
                  ),
                )
              ],
            ),
          ),
        ));
  }

  Future<void> routetoservice(Widget myWidget) async {
    MaterialPageRoute route = MaterialPageRoute(builder: (context) => myWidget);
    Navigator.pushAndRemoveUntil(context, route, (route) => false);
  }
}
