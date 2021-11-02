// ignore_for_file: avoid_print

import 'dart:async';

import 'package:dio/dio.dart';
import 'package:fleetdemo/model/model_car.dart';
import 'package:fleetdemo/model/model_driver_qouta.dart';
import 'package:fleetdemo/model/model_quota_order.dart';
import 'package:fleetdemo/model/model_quota_route.dart';
import 'package:fleetdemo/utility/dialog.dart';
import 'package:fleetdemo/utility/my_style.dart';
import 'package:fleetdemo/utility/myconstant.dart';
import 'package:flutter/material.dart';

class ScreenQuotaWeb extends StatefulWidget {
  const ScreenQuotaWeb({Key? key}) : super(key: key);

  @override
  _ScreenQuotaWebState createState() => _ScreenQuotaWebState();
}

class _ScreenQuotaWebState extends State<ScreenQuotaWeb> {
  bool visibleDriver = false;
  bool _inserDataQuota = true;
  bool _updateQuota = false;
  bool enableLimitLite = true;
  bool enableLimitBath = true;
  bool loadstatusQuotaDetail = true;
  bool statusQuotaDetail = true;
  bool loadstatusDriver = true;
  bool statusDriver = true;
  String? selectCar, selectDriver, selectRoute;
  String limitLiteValue = "0";
  final _limitLiteValue = TextEditingController();
  String limitBathValue = "0";
  final _limitBathValue = TextEditingController();
  String reference = "-";
  final _reference = TextEditingController();
  static const timer = Duration(seconds: 1);

  List<CarDetailModel> carDetailModels = [];
  List<DriverQuotaModel> driverQuotaModels = [];
  List<DropdownRoute> dropDownRoutsModels = [];
  List<QuotaModel> quotaDetailModels = [];

  @override
  void initState() {
    super.initState();
    apiGetListDestination();
    timer;
    apiGetListCar();
    timer;
    apiGetQuotaDetail();
  }

  Future<void> apiGetListCar() async {
    if (carDetailModels.isNotEmpty) {
      carDetailModels.clear();
    }
    await Dio().get(MyConstant().urlQuotaDropdownCar).then((value) {
      if (value.toString() != 'null') {
        for (var map in value.data) {
          CarDetailModel carDetailModel = CarDetailModel.fromJson(map);
          setState(() {
            carDetailModels.add(carDetailModel);
          });
        }
      } else {}
    });
  }

  Future<void> apiGetListDriver(String carid) async {
    if (driverQuotaModels.isNotEmpty) {
      driverQuotaModels.clear();
    }
    await Dio().get(MyConstant().urlQuotaDropdownDriver + carid).then((value) {
      if (value.toString() != 'null') {
        for (var map in value.data) {
          DriverQuotaModel driverQuotaModel = DriverQuotaModel.fromJson(map);
          setState(() {
            driverQuotaModels.add(driverQuotaModel);
            visibleDriver = true;
            selectDriver = null;
          });
        }
      } else {
        setState(() {
          visibleDriver = false;
        });
      }
    });
  }

  Future<void> apiGetListDestination() async {
    if (dropDownRoutsModels.isNotEmpty) {
      dropDownRoutsModels.clear();
    }
    await Dio().get(MyConstant().urlQuotaDropdownRoute).then((value) {
      if (value.toString() != 'null') {
        for (var map in value.data) {
          DropdownRoute dropdownRoute = DropdownRoute.fromJson(map);
          setState(() {
            dropDownRoutsModels.add(dropdownRoute);
          });
        }
      } else {}
    });
  }

  Future<void> apiGetQuotaDetail() async {
    if (quotaDetailModels.isNotEmpty) {
      quotaDetailModels.clear();
    }
    await Dio().get(MyConstant().urlQuotaDetail).then((value) {
      setState(() {
        loadstatusQuotaDetail = false;
      });
      if (value.toString() != 'null') {
        for (var map in value.data) {
          QuotaModel quotaModel = QuotaModel.fromJson(map);
          print(quotaModel);
          setState(() {
            quotaDetailModels.add(quotaModel);
            statusQuotaDetail = true;
          });
        }
      } else {
        setState(() {
          statusQuotaDetail = false;
        });
      }
    });
  }

  Future<void> apiAddQuota() async {
    showDialog(
      context: context,
      builder: (context) => SimpleDialog(
        title: Mystyle().textCustom(
            "คุณต้องการเพิ่มข้อมูลโควต้าใช่หรือไม่", 20.0, Colors.red),
        children: <Widget>[
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: <Widget>[
              TextButton.icon(
                onPressed: () async {
                  await Dio().post(MyConstant().urlQuotaNew, data: {
                    "car_id": selectCar,
                    "emp_code": selectDriver,
                    "limit_lite": limitLiteValue,
                    "limit_bath": limitBathValue,
                    "desination": selectRoute,
                    "ref1": reference
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
                        _inserDataQuota = true;
                        _updateQuota = false;

                        selectCar = null;
                        selectDriver = null;
                        _limitLiteValue.clear();
                        _limitBathValue.clear();
                        selectRoute = null;
                        _reference.clear();

                        limitBathValue = "0";
                        limitLiteValue = "0";
                        reference = "-";
                        apiGetQuotaDetail();
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
                    _inserDataQuota = true;
                    _updateQuota = false;

                    selectCar = null;
                    selectDriver = null;
                    _limitLiteValue.clear();
                    _limitBathValue.clear();
                    selectRoute = null;
                    _reference.clear();

                    limitBathValue = "0";
                    limitLiteValue = "0";
                    reference = "-";
                    // apiGetListProduct();
                    // apiGetListTank();
                    // apiGetListPump();
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

  Future<void> apiAddQuotaCancel(String recRef) async {
    showDialog(
      context: context,
      builder: (context) => SimpleDialog(
        title: Mystyle().textCustom(
            "คุณต้องการยกเลิกใบงาน $recRef ใช่หรือไม่", 20.0, Colors.red),
        children: <Widget>[
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: <Widget>[
              TextButton.icon(
                onPressed: () async {
                  await Dio().post(MyConstant().urlQuotaCancel, data: {
                    "rec_status": "CANCEL",
                    "rec_ref": recRef
                  }).then((value) {
                    if (value.toString() == 'SUCCESS') {
                      Navigator.pop(context);
                      apiGetQuotaDetail();
                    } else {
                      Navigator.pop(context);
                      normalDialog(context, 'กรุณาลองใหม่อีกครั้ง');
                    }
                  });
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
                },
                icon: const Icon(
                  Icons.clear,
                  color: Colors.red,
                ),
                label: Mystyle().textCustom("ย้อนกลับ", 20, Colors.black),
              ),
            ],
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return loadstatusQuotaDetail
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
                      _inserDataQuota
                          ? insertProductButton()
                          : updateProductButton(),
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
          );
  }

  Widget bodyTable() {
    if (statusQuotaDetail == false) {
      return const Center(
        child: Text(
          'ไม่มีโควต้าค้างอยู่',
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
                columnSpacing: 40,
                columns: const <DataColumn>[
                  DataColumn(
                    label: Text(
                      'ลำดับที่',
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
                      'เลขใบงาน',
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
                      'วันที่สร้างรายการ',
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
                      'ชื่อพนักงาน',
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
                      'ลิมิตลิตร',
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
                      'ลิมิตรบาท',
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
                      'รหัสน้ำมัน',
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
                      'ชื่อน้ำมัน',
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
                      'ทะเบียนรถ',
                      style: TextStyle(
                        color: Colors.red,
                        fontSize: 15,
                        fontFamily: 'Sarabun',
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
                rows: quotaDetailModels
                    .map(
                      (quotaDetailModel) => DataRow(
                        onSelectChanged: (newValue) {
                          apiAddQuotaCancel(quotaDetailModel.recRef!);
                          // setState(() {
                          //   _inserDataQuota = false;
                          //   _updateQuota = true;

                          //   print(quotaDetailModel.id);
                          //   print(quotaDetailModel.recRef);
                          //   print(quotaDetailModel.recCreate);
                          //   print(quotaDetailModel.empFullname);
                          //   print(quotaDetailModel.limitLite);
                          //   print(quotaDetailModel.limitBath);
                          //   print(quotaDetailModel.productId);
                          //   print(quotaDetailModel.productName);
                          //   print(quotaDetailModel.carRegistration);
                          // });
                        },
                        cells: [
                          DataCell(
                            SizedBox(
                              // width: MediaQuery.of(context).size.width * 0.2,
                              child: Text(
                                quotaDetailModel.id.toString(),
                                style: TextStyle(
                                  color: Colors.blue.shade400,
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
                                quotaDetailModel.recRef.toString(),
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
                                quotaDetailModel.recCreate.toString(),
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
                                quotaDetailModel.empCode.toString(),
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
                                quotaDetailModel.empFullname.toString(),
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
                                quotaDetailModel.limitLite.toString(),
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
                                quotaDetailModel.limitBath.toString(),
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
                                quotaDetailModel.productId.toString(),
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
                                quotaDetailModel.productName.toString(),
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
                                quotaDetailModel.carRegistration.toString(),
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
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        selectedCar(),
        Mystyle().mySizeBox(10.0, 10.0),
        selectedDriver(),
        Mystyle().mySizeBox(10.0, 10.0),
        limitLite(),
        Mystyle().mySizeBox(10.0, 10.0),
        limitBath(),
        Mystyle().mySizeBox(10.0, 10.0),
        selectedRoute(),
        Mystyle().mySizeBox(10.0, 10.0),
        reFerence()
      ],
    );
  }

  Widget limitLite() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Mystyle().textHeader("ลิมิตลิตร"),
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
              enabled: enableLimitLite,
              controller: _limitLiteValue,
              style: const TextStyle(
                  fontFamily: "Sarabun",
                  fontSize: 20,
                  fontWeight: FontWeight.bold),
              onChanged: (value) {
                limitLiteValue = value.trim();
                if (limitLiteValue.isNotEmpty) {
                  setState(() {
                    enableLimitBath = false;
                  });
                } else {
                  setState(() {
                    enableLimitBath = true;
                    limitLiteValue = "0";
                  });
                }
              },
            ),
          ),
        ),
      ],
    );
  }

  Widget limitBath() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Mystyle().textHeader("ลิมิตบาท"),
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
              enabled: enableLimitBath,
              controller: _limitBathValue,
              style: const TextStyle(
                  fontFamily: "Sarabun",
                  fontSize: 20,
                  fontWeight: FontWeight.bold),
              onChanged: (value) {
                limitBathValue = value.trim();
                if (limitBathValue.isNotEmpty) {
                  setState(() {
                    enableLimitLite = false;
                  });
                } else {
                  setState(() {
                    enableLimitLite = true;
                    limitBathValue = "0";
                  });
                }
              },
            ),
          ),
        ),
      ],
    );
  }

  Widget reFerence() {
    return Row(
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
              maxLines: 5,
              controller: _reference,
              style: const TextStyle(
                  fontFamily: "Sarabun",
                  fontSize: 20,
                  fontWeight: FontWeight.bold),
              onChanged: (value) {
                reference = value.trim();
                if (reference.isEmpty) {
                  setState(() {
                    reference = "-";
                  });
                }
              },
            ),
          ),
        ),
      ],
    );
  }

  Widget selectedCar() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Mystyle().textHeader("กรุณาเลือกรถ"),
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
                hint: Mystyle().textHeader("เลือกรถ"),
                value: selectCar,
                isDense: true,
                onChanged: (String? newValue) {
                  setState(() {
                    selectCar = newValue!;
                    apiGetListDriver(selectCar!);
                  });
                },
                items: carDetailModels.map((CarDetailModel map) {
                  return DropdownMenuItem<String>(
                    value: map.carId.toString(),
                    child: Text(
                      map.carRegistration!,
                      style: const TextStyle(
                          fontFamily: "Sarabun",
                          fontSize: 18,
                          fontWeight: FontWeight.bold),
                    ),
                  );
                }).toList(),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget selectedDriver() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Mystyle().textHeader("เลือกคนขับ"),
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
            child: Visibility(
              visible: visibleDriver,
              child: DropdownButtonHideUnderline(
                child: DropdownButton<String>(
                  hint: Mystyle().textHeader("ระบุคนขับ"),
                  value: selectDriver,
                  isDense: true,
                  onChanged: (String? newValue) {
                    setState(() {
                      selectDriver = newValue!;
                    });
                  },
                  items: driverQuotaModels.map((DriverQuotaModel map) {
                    return DropdownMenuItem<String>(
                      value: map.empCode,
                      child: Text(
                        map.empFullname! + " ",
                        style: const TextStyle(
                            fontFamily: "Sarabun",
                            fontSize: 18,
                            fontWeight: FontWeight.bold),
                      ),
                    );
                  }).toList(),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget selectedRoute() {
    return Row(
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
            width: MediaQuery.of(context).size.width * 0.2,
            padding: const EdgeInsets.all(8.0),
            child: DropdownButtonHideUnderline(
              child: DropdownButton<String>(
                hint: Mystyle().textHeader("ระบุปลายทาง"),
                value: selectRoute,
                isDense: true,
                onChanged: (String? newValue) {
                  setState(() {
                    selectRoute = newValue!;
                  });
                },
                items: dropDownRoutsModels.map((DropdownRoute map) {
                  return DropdownMenuItem<String>(
                    value: map.routeName,
                    child: Text(
                      map.routeName!,
                      style: const TextStyle(
                          fontFamily: "Sarabun",
                          fontSize: 18,
                          fontWeight: FontWeight.bold),
                    ),
                  );
                }).toList(),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget updateProductButton() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        // crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          updateQuota(),
          Mystyle().mySizeBox(10.0, 10.0),
          cancelQuota(),
        ],
      ),
    );
  }

  Widget insertProductButton() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        // crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          addQuota(),
          Mystyle().mySizeBox(10.0, 10.0),
          cancelQuota(),
        ],
      ),
    );
  }

  Widget updateQuota() {
    var w = MediaQuery.of(context).size.width * 0.1;
    return Visibility(
      visible: _updateQuota,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          fixedSize: Size(w, 70.0),
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
          primary: Colors.orange.shade200,
          elevation: 20,
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 20),
        ),
        onPressed: () {
          // apiUpdateProduct();
        },
        child: Mystyle().textCustom("แก้ไขข้อมูล", 30.0, Colors.white),
      ),
    );
  }

  Widget cancelQuota() {
    var w = MediaQuery.of(context).size.width * 0.1;
    return Visibility(
      visible: true,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          fixedSize: Size(w, 70.0),
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
          primary: Colors.red,
          elevation: 20,
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
        ),
        onPressed: () {
          setState(() {
            selectCar = null;
            selectDriver = null;
            _limitLiteValue.clear();
            _limitBathValue.clear();
            selectRoute = null;
            _reference.clear();

            limitBathValue = "0";
            limitLiteValue = "0";
            reference = "-";
            _inserDataQuota = true;
            _updateQuota = false;
          });
        },
        child: Mystyle().textCustom("ยกเลิก", 30.0, Colors.white),
      ),
    );
  }

  Widget addQuota() {
    var w = MediaQuery.of(context).size.width * 0.1;
    return Visibility(
      visible: _inserDataQuota,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          fixedSize: Size(w, 70.0),
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
          primary: Colors.cyan,
          elevation: 20,
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
        ),
        onPressed: () {
          print("selectCar = $selectCar");
          print("selectDriver = $selectDriver");
          print("limitLiteValue =  $limitLiteValue");
          print("limitBathValue =  $limitBathValue");
          print("selectRoute =  $selectRoute");
          print("reference = $reference");
          print("* * * * * * * * * * * * * * * * * *");
          if (selectCar != null &&
              selectDriver != null &&
              limitLiteValue != "0" &&
              limitBathValue == "0" &&
              selectRoute != null) {
            apiAddQuota();
          } else if (selectCar != null &&
              selectDriver != null &&
              limitLiteValue == "0" &&
              limitBathValue != "0" &&
              selectRoute != null) {
            apiAddQuota();
          } else {
            normalDialog(context, "กรุณากรอกข้อมูลให้ครบ");
          }
        },
        child: Mystyle().textCustom("เพิ่มข้อมูล", 30.0, Colors.white),
      ),
    );
  }
}
