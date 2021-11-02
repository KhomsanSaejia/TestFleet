// ignore_for_file: avoid_print

import 'package:dio/dio.dart';
import 'package:fleetdemo/model/model_quota_car.dart';
import 'package:fleetdemo/model/model_quota_route.dart';
import 'package:fleetdemo/utility/dialog.dart';
import 'package:fleetdemo/utility/my_style.dart';
import 'package:fleetdemo/utility/myconstant.dart';
import 'package:flutter/material.dart';

class ScreenQuotaTabletAddData extends StatefulWidget {
  const ScreenQuotaTabletAddData({Key? key}) : super(key: key);

  @override
  _ScreenQuotaTabletAddDataState createState() =>
      _ScreenQuotaTabletAddDataState();
}

class _ScreenQuotaTabletAddDataState extends State<ScreenQuotaTabletAddData> {
  bool status = true;
  bool loadstatus = true;
  bool enableLite = true;
  bool enableBath = true;

  List<DropdownCar> dropdowncars = [];
  List<DropdownRoute> dropdownroutes = [];
  String? selectedCarName;
  String? selectedRouteName;
  String? lite = "0", bath = "0", ref = "-";

  @override
  void initState() {
    super.initState();
    apiGetListCar();
    apiGetListRoute();
  }

  Future<void> apiGetListCar() async {
    if (dropdowncars.isNotEmpty) {
      dropdowncars.clear();
    }
    await Dio().get(MyConstant().urlQuotaDropdownCar).then((value) {
      if (value.toString() != 'null') {
        for (var map in value.data) {
          DropdownCar dropdownCar = DropdownCar.fromJson(map);
          setState(() {
            dropdowncars.add(dropdownCar);
          });
        }
      } else {}
    });
  }

  Future<void> apiGetListRoute() async {
    if (dropdownroutes.isNotEmpty) {
      dropdownroutes.clear();
    }
    await Dio().get(MyConstant().urlQuotaDropdownRoute).then((value) {
      setState(() {
        loadstatus = false;
      });
      if (value.toString() != 'null') {
        for (var map in value.data) {
          DropdownRoute dropdownRoute = DropdownRoute.fromJson(map);
          setState(() {
            dropdownroutes.add(dropdownRoute);
            status = true;
          });
        }
      } else {
        setState(() {
          status = false;
        });
      }
    });
  }

  Future<void> apiPOSTquota() async {
    try {
      Response response = await Dio().post(MyConstant().urlQuotaNew, data: {
        "selectedCarName": selectedCarName,
        "lite": lite,
        "bath": bath,
        "selectedRouteName": selectedRouteName,
        "ref": ref
      });
      print('response = $response');
      if (response.toString() == 'SUCCESS') {
        normalDialog(context, 'Account successfully added');
      } else {
        normalDialog(context, 'ไม่สามารถเพิ่ม โควต้า ได้ กรุณาลองใหม่อีกครั้ง');
      }
    } catch (e) {
      normalDialog(context, e.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Mystyle().textHeader("เพิ่มโควต้า"),
        centerTitle: true,
      ),
      body: loadstatus
          ? Mystyle().showprogress()
          : Container(
              width: MediaQuery.of(context).size.width * 1,
              color: Colors.grey.shade200,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  children: [
                    Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        bodyMenu(),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            ok(),
                            Mystyle().mySizeBox(20.0, 20.0),
                            cancel(),
                          ],
                        )
                      ],
                    ),
                  ],
                ),
              ),
            ),
    );
  }

  Widget bodyMenu() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Mystyle().textHeader("กรุณาเลือกรถ"),
            Container(
              width: MediaQuery.of(context).size.width * 0.7,
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
              child: Container(
                height: 65,
                // width: MediaQuery.of(context).size.width * 0.7,
                padding: const EdgeInsets.all(8.0),
                child: DropdownButtonHideUnderline(
                  child: DropdownButton<String>(
                    hint: Mystyle().textHeader("เลือกรถ"),
                    value: selectedCarName,
                    isDense: true,
                    onChanged: (String? newValue) {
                      setState(() {
                        selectedCarName = newValue!;
                      });
                    },
                    items: dropdowncars.map((DropdownCar map) {
                      return DropdownMenuItem<String>(
                        value: map.carRegistration,
                        child: Mystyle().textHeader(map.carRegistration!),
                      );
                    }).toList(),
                  ),
                ),
              ),
            ),
          ],
        ),
        Mystyle().mySizeBox(20.0, 20.0),
        Center(
          child: Mystyle().textHeader("ระบุจำนวนลิตร/บาท"),
        ),
        Mystyle().mySizeBox(20.0, 20.0),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Mystyle().textHeader("จำนวนลิตร"),
            Mystyle().mySizeBox(20.0, 20.0),
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
              child: Container(
                width: MediaQuery.of(context).size.width * 0.7,
                padding: const EdgeInsets.all(8.0),
                child: TextField(
                  style: const TextStyle(
                      fontFamily: "Sarabun",
                      fontSize: 20,
                      fontWeight: FontWeight.bold),
                  enabled: enableLite,
                  keyboardType: TextInputType.number,
                  onChanged: (value) {
                    lite = value.trim();
                    if (lite != "") {
                      setState(() {
                        enableBath = false;
                      });
                    } else {
                      setState(() {
                        enableBath = true;
                      });
                    }
                  },
                ),
              ),
            ),
          ],
        ),
        Mystyle().mySizeBox(20.0, 10.0),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Mystyle().textHeader("จำนวนบาท"),
            Mystyle().mySizeBox(20.0, 20.0),
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
              child: Container(
                width: MediaQuery.of(context).size.width * 0.7,
                padding: const EdgeInsets.all(8.0),
                child: TextField(
                  style: const TextStyle(
                      fontFamily: "Sarabun",
                      fontSize: 20,
                      fontWeight: FontWeight.bold),
                  enabled: enableBath,
                  keyboardType: TextInputType.number,
                  onChanged: (value) {
                    bath = value.trim();
                    if (bath != "") {
                      setState(() {
                        enableLite = false;
                      });
                    } else {
                      setState(() {
                        enableLite = true;
                      });
                    }
                  },
                ),
              ),
            ),
          ],
        ),
        Mystyle().mySizeBox(20.0, 20.0),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Mystyle().textHeader("ปลายทาง"),
            Mystyle().mySizeBox(20.0, 20.0),
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
              child: Container(
                height: 65,
                width: MediaQuery.of(context).size.width * 0.7,
                padding: const EdgeInsets.all(8.0),
                child: DropdownButtonHideUnderline(
                  child: DropdownButton<String>(
                    hint: Mystyle().textHeader("เลือกปลายทาง"),
                    value: selectedRouteName,
                    isDense: true,
                    onChanged: (String? newValue) {
                      setState(() {
                        selectedRouteName = newValue!;
                      });
                    },
                    items: dropdownroutes.map((DropdownRoute map) {
                      return DropdownMenuItem<String>(
                        value: map.routeRef,
                        child: Mystyle().textHeader(map.routeRef!),
                      );
                    }).toList(),
                  ),
                ),
              ),
            ),
          ],
        ),
        Mystyle().mySizeBox(20.0, 20.0),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Mystyle().textHeader("อ้างอิง"),
            Mystyle().mySizeBox(20.0, 20.0),
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
              child: Container(
                width: MediaQuery.of(context).size.width * 0.7,
                padding: const EdgeInsets.all(8.0),
                child: TextField(
                  style: const TextStyle(
                      fontFamily: "Sarabun",
                      fontSize: 20,
                      fontWeight: FontWeight.bold),
                  maxLines: 5,
                  onChanged: (value) => ref = value.trim(),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget ok() {
    var w = MediaQuery.of(context).size.width * 0.4;
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        fixedSize: Size(w, 70.0),
        shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
        primary: Colors.cyan,
        elevation: 20,
        padding: const EdgeInsets.symmetric(horizontal: 50, vertical: 20),
      ),
      onPressed: () {
        print("selectedCarName = $selectedCarName");
        print("lite = $lite");
        print("bath = $bath");
        print("selectedRouteName = $selectedRouteName");
        print("selectedCarName = $selectedCarName");
        print("ref = $ref");
        print("* * * * * * * * * * * * * * * * * * * * * * * *");

        if (selectedCarName != null &&
                bath != null &&
                selectedRouteName != null ||
            selectedCarName != null &&
                lite != null &&
                selectedRouteName != null) {
          apiPOSTquota();
          // normalDialog(context, "ขอบคุณครับ");
        } else {
          normalDialog(context, "กรุณากรอกข้อมูลให้ครบ");
        }
      },
      child: Mystyle().textHeader("เพิ่มข้อมูล"),
    );
  }

  Widget cancel() {
    var w = MediaQuery.of(context).size.width * 0.4;
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        fixedSize: Size(w, 70.0),
        shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
        primary: Colors.red,
        elevation: 20,
        padding: const EdgeInsets.symmetric(horizontal: 50, vertical: 20),
      ),
      onPressed: () {},
      child: Mystyle().textHeader("ยกเลิก"),
    );
  }
}
