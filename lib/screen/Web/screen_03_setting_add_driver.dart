// ignore_for_file: avoid_print

import 'package:dio/dio.dart';
import 'package:fleetdemo/model/model_compay_name.dart';
import 'package:fleetdemo/model/model_driver_name.dart';
import 'package:fleetdemo/utility/dialog.dart';
import 'package:fleetdemo/utility/my_style.dart';
import 'package:fleetdemo/utility/myconstant.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ScreenSettingAddDriverWeb extends StatefulWidget {
  const ScreenSettingAddDriverWeb({Key? key}) : super(key: key);

  @override
  _ScreenSettingAddDriverWebState createState() =>
      _ScreenSettingAddDriverWebState();
}

class _ScreenSettingAddDriverWebState extends State<ScreenSettingAddDriverWeb> {
  bool _status = true;
  bool _loadstatus = true;
  bool _inserData = true;
  bool _updateData = false;

  String empCode = "-", empName = "-", empTel = "-", empToken = "-";
  String? custName;

  final _id = TextEditingController();
  final _empCode = TextEditingController();
  final _empName = TextEditingController();
  final _empTel = TextEditingController();
  final _empToken = TextEditingController();
  final _custName = TextEditingController();

  List<CompanyNameModel> companyNameModels = [];
  List<DriverNameModel> driverNameModels = [];

  @override
  void initState() {
    super.initState();
    apiGetListCompany();
    apiGetListDriver();
  }

  Future<void> apiGetListCompany() async {
    if (companyNameModels.isNotEmpty) {
      companyNameModels.clear();
    }
    await Dio().get(MyConstant().urlSettingDropdownCustomer).then((value) {
      if (value.toString() != 'null') {
        for (var map in value.data) {
          CompanyNameModel companyNameModel = CompanyNameModel.fromJson(map);
          setState(() {
            companyNameModels.add(companyNameModel);
          });
        }
      } else {}
    });
  }

  Future<void> apiGetListDriver() async {
    if (driverNameModels.isNotEmpty) {
      driverNameModels.clear();
    }
    await Dio().get(MyConstant().urlSettingListDriver).then((value) {
      setState(() {
        _loadstatus = false;
      });
      if (value.toString() != 'null') {
        for (var map in value.data) {
          DriverNameModel driverNameModel = DriverNameModel.fromJson(map);
          setState(() {
            driverNameModels.add(driverNameModel);
            _status = true;
          });
        }
      } else {
        setState(() {
          _status = false;
        });
      }
    });
  }

  Future<void> apiAddDriver() async {
    showDialog(
      context: context,
      builder: (context) => SimpleDialog(
        title: Mystyle().textCustom(
            "คุณต้องการเพิ่มข้อมูลคนขับรถใช่หรือไม่", 20.0, Colors.red),
        children: <Widget>[
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: <Widget>[
              TextButton.icon(
                onPressed: () async {
                  await Dio().post(MyConstant().urlSettingDriverAdd, data: {
                    "emp_code": empCode,
                    "emp_fullname": empName,
                    "emp_tel": empTel,
                    "emp_token": empToken,
                    "com_name": custName
                  }).then(
                    (value) {
                      if (value.toString() == 'SUCCESS') {
                        Navigator.pop(context);
                      } else {
                        Navigator.pop(context);
                        normalDialog(
                            context, 'การกระทำไม่สำเร็จ กรุณาลองใหม่อีกครั้ง');
                      }
                      setState(() {
                        _inserData = true;
                        _updateData = false;
                        empCode = "-";
                        empName = "-";
                        empTel = "-";
                        empToken = "-";
                        custName = null;
                        _id.clear();
                        _empCode.clear();
                        _empName.clear();
                        _empTel.clear();
                        _empToken.clear();
                        _custName.clear();
                        apiGetListCompany();
                        apiGetListDriver();
                      });
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
                    _inserData = true;
                    _updateData = false;
                    empCode = "-";
                    empName = "-";
                    empTel = "-";
                    empToken = "-";
                    custName = null;
                    _id.clear();
                    _empCode.clear();
                    _empName.clear();
                    _empTel.clear();
                    _empToken.clear();
                    _custName.clear();
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

  Future<void> apiUpdateDriver(String url, String header) async {
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
                    "emp_code": empCode,
                    "emp_fullname": empName,
                    "emp_tel": empTel,
                    "emp_token": empToken,
                    "com_name": custName
                  }).then(
                    (value) {
                      if (value.toString() == 'SUCCESS') {
                        Navigator.pop(context);
                        setState(() {
                          _inserData = true;
                          _updateData = false;
                          empCode = "-";
                          empName = "-";
                          empTel = "-";
                          empToken = "-";
                          custName = null;
                          _id.clear();
                          _empCode.clear();
                          _empName.clear();
                          _empTel.clear();
                          _empToken.clear();
                          _custName.clear();
                          apiGetListCompany();
                          apiGetListDriver();
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
                    _inserData = true;
                    _updateData = false;
                    empCode = "-";
                    empName = "-";
                    empTel = "-";
                    empToken = "-";
                    custName = null;
                    _id.clear();
                    _empCode.clear();
                    _empName.clear();
                    _empTel.clear();
                    _empToken.clear();
                    _custName.clear();
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
        title: Mystyle().textHeader("เพิ่มข้อมูลคนขับรถ"),
        centerTitle: true,
      ),
      body: _loadstatus
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
                        _inserData ? insertData() : updateData(),
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
    if (_status == false) {
      return const Center(
        child: Text(
          'ยังไม่มีข้อมูลพนักงานขับรถ',
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
                columnSpacing: 20,
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
                      'รหัสพนักงาน',
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
                      'ชื่อ นามสกุล',
                      style: TextStyle(
                        color: Colors.red,
                        fontSize: 15,
                        fontFamily: 'Sarabun',
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ), // ),
                  DataColumn(
                    label: Text(
                      'เบอร์โทร',
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
                      'บริษัท',
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
                      'Token Line',
                      style: TextStyle(
                        color: Colors.red,
                        fontSize: 15,
                        fontFamily: 'Sarabun',
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
                rows: driverNameModels
                    .map(
                      (driverNameModel) => DataRow(
                        onSelectChanged: (newValue) {
                          setState(() {
                            _inserData = false;
                            _updateData = true;
                            _id.text = driverNameModel.id!.toString();
                            _empCode.text = driverNameModel.empCode!;
                            _empName.text = driverNameModel.empFullname!;
                            _empTel.text = driverNameModel.empTel!;
                            _empToken.text = driverNameModel.empToken!;
                            _custName.text = driverNameModel.comName!;

                            empCode = driverNameModel.empCode!;
                            empName = driverNameModel.empFullname!;
                            empTel = driverNameModel.empTel!;
                            empToken = driverNameModel.empToken!;
                            custName = driverNameModel.comName!;
                          });
                        },
                        cells: [
                          // DataCell(
                          //   SizedBox(
                          //     width: MediaQuery.of(context).size.width * 0.2,
                          //     child: Text(
                          //       driverNameModel.id.toString(),
                          //       style: TextStyle(
                          //         color: Colors.blue.shade400,
                          //         fontSize: 13,
                          //         fontFamily: 'Sarabun',
                          //         fontWeight: FontWeight.bold,
                          //       ),
                          //       overflow: TextOverflow.ellipsis,
                          //     ),
                          //   ),
                          // ),
                          DataCell(
                            SizedBox(
                              // width: MediaQuery.of(context).size.width * 0.2,
                              child: Text(
                                driverNameModel.empCode.toString(),
                                style: const TextStyle(
                                  color: Colors.black,
                                  fontSize: 13,
                                  fontFamily: 'Sarabun',
                                  fontWeight: FontWeight.bold,
                                ),
                                overflow: TextOverflow.clip,
                              ),
                            ),
                          ),
                          DataCell(
                            SizedBox(
                              // width: MediaQuery.of(context).size.width * 0.1,
                              child: Text(
                                driverNameModel.empFullname.toString(),
                                style: const TextStyle(
                                  color: Colors.green,
                                  fontSize: 13,
                                  fontFamily: 'Sarabun',
                                  fontWeight: FontWeight.bold,
                                ),
                                overflow: TextOverflow.clip,
                              ),
                            ),
                          ),
                          DataCell(
                            SizedBox(
                              // width: MediaQuery.of(context).size.width * 0.2,
                              child: Text(
                                driverNameModel.empTel.toString(),
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
                              width: MediaQuery.of(context).size.width * 0.15,
                              child: Text(
                                driverNameModel.comName.toString(),
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
                              width: MediaQuery.of(context).size.width * 0.2,
                              child: Text(
                                driverNameModel.empToken.toString(),
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

  Widget bodyMenu() {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Mystyle().textHeader("รหัสพนักงาน"),
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
                  maxLength: 8,
                  controller: _empCode,
                  style: const TextStyle(
                      fontFamily: "Sarabun",
                      fontSize: 20,
                      fontWeight: FontWeight.bold),
                  onChanged: (value) {
                    empCode = value.trim();
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
            Mystyle().textHeader("ชื่อนามสกุล"),
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
                  controller: _empName,
                  style: const TextStyle(
                      fontFamily: "Sarabun",
                      fontSize: 20,
                      fontWeight: FontWeight.bold),
                  onChanged: (value) {
                    empName = value.trim();
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
            Mystyle().textHeader("เบอร์โทร"),
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
                  maxLength: 10,
                  controller: _empTel,
                  style: const TextStyle(
                      fontFamily: "Sarabun",
                      fontSize: 20,
                      fontWeight: FontWeight.bold),
                  onChanged: (value) {
                    empTel = value.trim();
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
            Mystyle().textHeader("Token Line"),
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
                  maxLines: 2,
                  controller: _empToken,
                  style: const TextStyle(
                      fontFamily: "Sarabun",
                      fontSize: 20,
                      fontWeight: FontWeight.bold),
                  onChanged: (value) {
                    empToken = value.trim();
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
            Mystyle().textHeader("บริษัท"),
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
                width: MediaQuery.of(context).size.width * 0.2,
                padding: const EdgeInsets.all(8.0),
                child: DropdownButtonHideUnderline(
                  child: DropdownButton<String>(
                    hint: Mystyle().textHeader("ระบุลูกค้า"),
                    value: custName,
                    isDense: true,
                    onChanged: (String? newValue) {
                      setState(() {
                        custName = newValue!;
                      });
                    },
                    items: companyNameModels.map((CompanyNameModel map) {
                      return DropdownMenuItem<String>(
                        value: map.comName,
                        child: Text(
                          map.comName!,
                          style: const TextStyle(
                              fontFamily: "Sarabun",
                              fontSize: 18,
                              fontWeight: FontWeight.bold),
                        ),
                        // child: Mystyle().textHeader(map.custName!),
                      );
                    }).toList(),
                  ),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget insertData() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        ok(),
        cancel(),
      ],
    );
  }

  Widget updateData() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        delete(),
        Mystyle().mySizeBox(10.0, 10.0),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            update(),
            cancel(),
          ],
        ),
      ],
    );
  }

  Widget update() {
    var w = MediaQuery.of(context).size.width * 0.1;
    return Visibility(
      visible: _updateData,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          fixedSize: Size(w, 50.0),
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
          primary: Colors.orange.shade200,
          elevation: 20,
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
        ),
        onPressed: () {
          apiUpdateDriver(MyConstant().urlSettingDriverUpdate,
              "คุณต้องการแก้ไขข้อมูลคนขับรถใช่หรือไม่");
        },
        child: Mystyle().textCustom("แก้ไขข้อมูล", 20.0, Colors.black),
      ),
    );
  }

  Widget ok() {
    var w = MediaQuery.of(context).size.width * 0.1;
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        fixedSize: Size(w, 50.0),
        shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
        primary: Colors.cyan,
        elevation: 20,
        padding: const EdgeInsets.symmetric(horizontal: 50, vertical: 20),
      ),
      onPressed: () {
        print("empCode = $empCode");
        print("empName = $empName");
        print("empTel = $empTel");
        print("empToken = $empToken");
        print("custName = $custName");
        print("-----------------------------------------------------------");
        if (empCode == "-" ||
            empCode.isEmpty ||
            empName == "-" ||
            empName.isEmpty ||
            empTel == "-" ||
            empTel.isEmpty ||
            empToken == "-" ||
            empToken.isEmpty ||
            custName == null) {
          // apiPOSTcarNew();
          normalDialog(context, "กรุณากรอกข้อมูลให้ครบ");
        } else {
          apiAddDriver();
          // normalDialog(context, "ขอบคุณครับ");
        }
      },
      child: Mystyle().textHeader("เพิ่มข้อมูล"),
    );
  }

  Widget cancel() {
    var w = MediaQuery.of(context).size.width * 0.1;
    return Visibility(
      visible: true,
      child: ElevatedButton(
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
            _inserData = true;
            _updateData = false;
            empCode = "-";
            empName = "-";
            empTel = "-";
            empToken = "-";
            custName = null;

            _empCode.clear();
            _empName.clear();
            _empTel.clear();
            _empToken.clear();
            _custName.clear();
          });
        },
        child: Mystyle().textHeader("ล้างหน้าจอ"),
      ),
    );
  }

  Widget delete() {
    var w = MediaQuery.of(context).size.width * 0.1;
    return Visibility(
      visible: true,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          fixedSize: Size(w, 50.0),
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
          primary: Colors.pink.shade400,
          elevation: 20,
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
        ),
        onPressed: () {
          apiUpdateDriver(MyConstant().urlSettingDriverDelete,
              "คุณต้องการลบข้อมูลคนขับรถใช่หรือไม่");
        },
        child: Mystyle().textCustom("ลบข้อมูล", 20.0, Colors.white),
      ),
    );
  }
}
