// ignore_for_file: avoid_print

import 'package:dio/dio.dart';
import 'package:fleetdemo/model/model_destination.dart';
import 'package:fleetdemo/utility/dialog.dart';
import 'package:fleetdemo/utility/my_style.dart';
import 'package:fleetdemo/utility/myconstant.dart';
import 'package:flutter/material.dart';

class ScreenSettingAddDestinationWeb extends StatefulWidget {
  const ScreenSettingAddDestinationWeb({Key? key}) : super(key: key);

  @override
  _ScreenSettingAddDestinationWebState createState() =>
      _ScreenSettingAddDestinationWebState();
}

class _ScreenSettingAddDestinationWebState
    extends State<ScreenSettingAddDestinationWeb> {
  bool status = true;
  bool loadstatus = true;

  bool _inserDataDestination = true;
  bool _updateDataDestination = false;

  String routename = "-", routelat = "-", routelong = "-", routeref = "-";

  final _id = TextEditingController();
  final _routename = TextEditingController();
  final _routelat = TextEditingController();
  final _routelong = TextEditingController();
  final _routeref = TextEditingController();

  List<DestinationModel> destinationModels = [];

  @override
  void initState() {
    super.initState();
    apiGetListDestination();
  }

  Future<void> apiGetListDestination() async {
    if (destinationModels.isNotEmpty) {
      destinationModels.clear();
    }
    await Dio().get(MyConstant().urlSettingDestinationList).then((value) {
      setState(() {
        loadstatus = false;
      });
      if (value.toString() != 'null') {
        for (var map in value.data) {
          DestinationModel destinationModel = DestinationModel.fromJson(map);
          setState(() {
            destinationModels.add(destinationModel);
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

  Future<void> apiUpdateDestination(String url, String header) async {
    showDialog(
      context: context,
      builder: (context) => SimpleDialog(
        title: Mystyle().textCustom(header, 20.0, Colors.red),
        children: <Widget>[
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: <Widget>[
              TextButton.icon(
                onPressed: () async {
                  await Dio().post(url, data: {
                    "id": _id.text,
                    "route_name": routename,
                    "route_lat": routelat,
                    "route_long": routelong,
                    "route_ref": routeref
                  }).then(
                    (value) {
                      if (value.toString() == 'SUCCESS') {
                        Navigator.pop(context);
                        setState(() {
                          _routename.clear();
                          _routelat.clear();
                          _routelong.clear();
                          _routeref.clear();
                          _inserDataDestination = true;
                          _updateDataDestination = false;
                          routename = "-";
                          routelat = "-";
                          routelong = "-";
                          routeref = "-";

                          apiGetListDestination();
                        });
                      } else {
                        Navigator.pop(context);
                        normalDialog(
                            context, 'การกระทำไม่สำเร็จ กรุณาลองใหม่อีกครั้ง');
                      }
                    },
                  );
                },
                icon: const Icon(
                  Icons.check,
                  color: Colors.green,
                ),
                label: Mystyle().textCustom("ตกลง", 20, Colors.black),
              ),
              TextButton.icon(
                onPressed: () {
                  Navigator.pop(context);
                  setState(() {
                    _routename.clear();
                    _routelat.clear();
                    _routelong.clear();
                    _routeref.clear();
                    _inserDataDestination = true;
                    _updateDataDestination = false;
                    routename = "-";
                    routelat = "-";
                    routelong = "-";
                    routeref = "-";
                  });
                },
                icon: const Icon(
                  Icons.clear,
                  color: Colors.red,
                ),
                label: Mystyle().textCustom("ยกเลิก", 20, Colors.black),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Future<void> apiPOSTDestinationNew() async {
    showDialog(
      context: context,
      builder: (context) => SimpleDialog(
        title: Mystyle().textCustom(
            "คุณต้องการเพิ่มข้อมูลปลายทางใช่หรือไม่", 20.0, Colors.red),
        children: <Widget>[
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: <Widget>[
              TextButton.icon(
                onPressed: () async {
                  await Dio()
                      .post(MyConstant().urlSettingDestinationAdd, data: {
                    "route_name": routename,
                    "route_lat": routelat,
                    "route_long": routelat,
                    "route_ref": routelong,
                  }).then(
                    (value) {
                      if (value.toString() == 'SUCCESS') {
                        Navigator.pop(context);
                        setState(() {
                          _routename.clear();
                          _routelat.clear();
                          _routelong.clear();
                          _routeref.clear();
                          _inserDataDestination = true;
                          _updateDataDestination = false;
                          routename = "-";
                          routelat = "-";
                          routelong = "-";
                          routeref = "-";

                          apiGetListDestination();
                        });
                      } else {
                        Navigator.pop(context);
                        normalDialog(
                            context, 'การกระทำไม่สำเร็จ กรุณาลองใหม่อีกครั้ง');
                      }
                    },
                  );
                },
                icon: const Icon(
                  Icons.check,
                  color: Colors.green,
                ),
                label: Mystyle().textCustom("ตกลง", 20, Colors.black),
              ),
              TextButton.icon(
                onPressed: () {
                  Navigator.pop(context);
                  setState(() {
                    _routename.clear();
                    _routelat.clear();
                    _routelong.clear();
                    _routeref.clear();
                    _inserDataDestination = true;
                    _updateDataDestination = false;
                    routename = "-";
                    routelat = "-";
                    routelong = "-";
                    routeref = "-";
                  });
                },
                icon: const Icon(
                  Icons.clear,
                  color: Colors.red,
                ),
                label: Mystyle().textCustom("ยกเลิก", 20, Colors.black),
              ),
            ],
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Mystyle().textHeader("เพิ่มข้อมูลเส้นทาง"),
        centerTitle: true,
      ),
      body: loadstatus
          ? Mystyle().showprogress()
          : Container(
              width: MediaQuery.of(context).size.width * 1,
              color: Colors.grey.shade200,
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(20.0),
                    width: MediaQuery.of(context).size.width * 0.3,
                    color: Colors.grey.shade400,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        bodyMenu(),
                        _inserDataDestination
                            ? insertDestinationButton()
                            : updateDestinationButton(),
                      ],
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.all(20.0),
                    width: MediaQuery.of(context).size.width * 0.7,
                    color: Colors.grey.shade100,
                    child: bodyTable(),
                  ),
                ],
              ),
            ),
    );
  }

  Widget bodyTable() {
    if (status == false) {
      return const Center(
        child: Text(
          'ยังไม่มีประวัติปลายทาง',
          style: TextStyle(
              fontWeight: FontWeight.bold, fontSize: 20, fontFamily: 'Sarabun'),
        ),
      );
    } else {
      return Column(
        children: [
          SingleChildScrollView(
            child: Center(
              child: DataTable(
                showCheckboxColumn: false,
                showBottomBorder: true,
                columnSpacing: 50,
                columns: const <DataColumn>[
                  // DataColumn(
                  //   label: Text(
                  //     'ลำดับที่',
                  //     style: TextStyle(
                  //       color: Colors.red,
                  //       fontSize: 15,
                  //       fontFamily: 'Sarabun',
                  //       fontWeight: FontWeight.bold,
                  //     ),
                  //   ),
                  // ),
                  DataColumn(
                    label: Text(
                      'ปลายทาง',
                      style: TextStyle(
                        color: Colors.red,
                        fontSize: 15,
                        fontFamily: 'Sarabun',
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  DataColumn(
                    label: Text(
                      'ละติจูด',
                      style: TextStyle(
                        color: Colors.red,
                        fontSize: 15,
                        fontFamily: 'Sarabun',
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  DataColumn(
                    label: Text(
                      'ลองติจูด',
                      style: TextStyle(
                        color: Colors.red,
                        fontSize: 15,
                        fontFamily: 'Sarabun',
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  DataColumn(
                    label: Text(
                      'อ้างอิง',
                      style: TextStyle(
                        color: Colors.red,
                        fontSize: 15,
                        fontFamily: 'Sarabun',
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
                rows: destinationModels
                    .map(
                      (destinationModel) => DataRow(
                        onSelectChanged: (newValue) {
                          setState(() {
                            _inserDataDestination = false;
                            _updateDataDestination = true;

                            _id.text = destinationModel.id.toString();

                            _routename.text = destinationModel.routeName!;
                            _routelat.text = destinationModel.routeLat!;
                            _routelong.text = destinationModel.routeLong!;
                            _routeref.text = destinationModel.routeRef!;

                            routename = _routename.text;
                            routelat = _routelat.text;
                            routelong = _routelong.text;
                            routeref = _routeref.text;
                          });
                        },
                        cells: [
                          // DataCell(
                          //   SizedBox(
                          //     // width: MediaQuery.of(context).size.width * 0.2,
                          //     child: Text(
                          //       destinationModel.id.toString(),
                          //       style: TextStyle(
                          //         color: Colors.blue.shade400,
                          //         fontSize: 13,
                          //         fontFamily: 'Sarabun',
                          //         fontWeight: FontWeight.bold,
                          //       ),
                          //     ),
                          //   ),
                          // ),
                          DataCell(
                            SizedBox(
                              // width: MediaQuery.of(context).size.width * 0.2,
                              child: Text(
                                destinationModel.routeName!,
                                style: const TextStyle(
                                  color: Colors.black,
                                  fontSize: 13,
                                  fontFamily: 'Sarabun',
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                          DataCell(
                            SizedBox(
                              // width: MediaQuery.of(context).size.width * 0.2,
                              child: Text(
                                destinationModel.routeLat!,
                                style: const TextStyle(
                                  color: Colors.green,
                                  fontSize: 13,
                                  fontFamily: 'Sarabun',
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                          DataCell(
                            SizedBox(
                              // width: MediaQuery.of(context).size.width * 0.2,
                              child: Text(
                                destinationModel.routeLong!,
                                style: const TextStyle(
                                  color: Colors.green,
                                  fontSize: 13,
                                  fontFamily: 'Sarabun',
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                          DataCell(
                            SizedBox(
                              // width: MediaQuery.of(context).size.width * 0.2,
                              child: Text(
                                destinationModel.routeRef!,
                                style: const TextStyle(
                                  color: Colors.green,
                                  fontSize: 13,
                                  fontFamily: 'Sarabun',
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    )
                    .toList(),
              ),
            ),
          ),
        ],
      );
    }
  }

  Widget insertDestinationButton() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      // crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        ok(),
        Mystyle().mySizeBox(10.0, 10.0),
        cancel(),
      ],
    );
  }

  Widget updateDestinationButton() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        delete(),
        Mystyle().mySizeBox(10.0, 10.0),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            update(),
            // Mystyle().mySizeBox(10.0, 10.0),
            cancel(),
          ],
        ),
      ],
    );
  }

  Widget bodyMenu() {
    return Column(
      children: [
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
                width: MediaQuery.of(context).size.width * 0.2,
                padding: const EdgeInsets.all(8.0),
                child: TextField(
                  controller: _routename,
                  style: const TextStyle(
                      fontFamily: "Sarabun",
                      fontSize: 20,
                      fontWeight: FontWeight.bold),
                  onChanged: (value) {
                    routename = value.trim();
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
            Mystyle().textHeader("ละติจูด"),
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
                width: MediaQuery.of(context).size.width * 0.2,
                padding: const EdgeInsets.all(8.0),
                child: TextField(
                  controller: _routelat,
                  style: const TextStyle(
                      fontFamily: "Sarabun",
                      fontSize: 20,
                      fontWeight: FontWeight.bold),
                  onChanged: (value) {
                    routelat = value.trim();
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
            Mystyle().textHeader("ลองติจูด"),
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
                width: MediaQuery.of(context).size.width * 0.2,
                padding: const EdgeInsets.all(8.0),
                child: TextField(
                  controller: _routelong,
                  style: const TextStyle(
                      fontFamily: "Sarabun",
                      fontSize: 20,
                      fontWeight: FontWeight.bold),
                  onChanged: (value) {
                    routelong = value.trim();
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
                width: MediaQuery.of(context).size.width * 0.2,
                padding: const EdgeInsets.all(8.0),
                child: TextField(
                  controller: _routeref,
                  style: const TextStyle(
                      fontFamily: "Sarabun",
                      fontSize: 20,
                      fontWeight: FontWeight.bold),
                  onChanged: (value) {
                    routeref = value.trim();
                  },
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget update() {
    var w = MediaQuery.of(context).size.width * 0.1;
    return Visibility(
      visible: _updateDataDestination,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          fixedSize: Size(w, 50.0),
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
          primary: Colors.orange.shade200,
          elevation: 20,
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 20),
        ),
        onPressed: () {
          apiUpdateDestination(MyConstant().urlSettingDestinationUpdate,
              "คุณต้องการอัพเดทข้อมูลปลายทางใช่หรือไม่");
        },
        child: Mystyle().textCustom("แก้ไขข้อมูล", 20.0, Colors.black),
      ),
    );
  }

  Widget ok() {
    var w = MediaQuery.of(context).size.width * 0.1;
    return Visibility(
      visible: _inserDataDestination,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          fixedSize: Size(w, 50.0),
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
          primary: Colors.cyan,
          elevation: 20,
          padding: const EdgeInsets.symmetric(horizontal: 50, vertical: 20),
        ),
        onPressed: () {
          if (routelat == "-" ||
              routelat.isEmpty ||
              routelong == "-" ||
              routelong.isEmpty ||
              routename == "-" ||
              routename.isEmpty ||
              routeref == "-" ||
              routeref.isEmpty) {
            normalDialog(context, "กรุณากรอกข้อมูลให้ครบ");
          } else {
            apiPOSTDestinationNew();
          }
        },
        child: Mystyle().textHeader("เพิ่มข้อมูล"),
      ),
    );
  }

  Widget cancel() {
    var w = MediaQuery.of(context).size.width * 0.1;
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        fixedSize: Size(w, 50.0),
        shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
        primary: Colors.red,
        elevation: 20,
        padding: const EdgeInsets.symmetric(horizontal: 50, vertical: 20),
      ),
      onPressed: () {
        setState(() {
          _inserDataDestination = true;
          _updateDataDestination = false;
          _routename.clear();
          _routelat.clear();
          _routelong.clear();
          _routeref.clear();
          routename = "-";
          routelat = "-";
          routelong = "-";
          routeref = "-";
        });
      },
      child: Mystyle().textHeader("ยกเลิก"),
    );
  }

  Widget delete() {
    var w = MediaQuery.of(context).size.width * 0.1;
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        fixedSize: Size(w, 50.0),
        shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
        primary: Colors.pink.shade400,
        elevation: 20,
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
      ),
      onPressed: () {
        apiUpdateDestination(MyConstant().urlSettingDestinationDelete,
            "คุณต้องการลบข้อมูลปลายทางใช่หรือไม่");
      },
      child: Mystyle().textCustom("ลบข้อมูล", 20.0, Colors.white),
    );
  }
}
