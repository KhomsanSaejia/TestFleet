// ignore_for_file: avoid_print

import 'package:dio/dio.dart';
import 'package:fleetdemo/model/model_company.dart';
import 'package:fleetdemo/utility/dialog.dart';
import 'package:fleetdemo/utility/my_style.dart';
import 'package:fleetdemo/utility/myconstant.dart';
import 'package:flutter/material.dart';
// import 'package:http/http.dart';

class ScreenSettingAddCustomerWeb extends StatefulWidget {
  const ScreenSettingAddCustomerWeb({Key? key}) : super(key: key);

  @override
  _ScreenSettingAddCustomerWebState createState() =>
      _ScreenSettingAddCustomerWebState();
}

class _ScreenSettingAddCustomerWebState
    extends State<ScreenSettingAddCustomerWeb> {
  bool status = true;
  bool loadstatus = true;

  bool _inserData = true;
  bool _updateData = false;

  String? companyName,
      companyAddress,
      companyLat,
      companyLong,
      companyTel,
      companyRef;

  List<CompanyModel> companyModels = [];

  final _companyId = TextEditingController();
  final _companyName = TextEditingController();
  final _companyAddress = TextEditingController();
  final _companyLat = TextEditingController();
  final _companyLong = TextEditingController();
  final _companyTel = TextEditingController();
  final _companyRef = TextEditingController();

  @override
  void initState() {
    super.initState();
    apiGetListCompany();
  }

  Future<void> apiGetListCompany() async {
    if (companyModels.isNotEmpty) {
      companyModels.clear();
    }
    await Dio().get(MyConstant().urlSettingListCompany).then((value) {
      setState(() {
        loadstatus = false;
      });
      if (value.toString() != 'null') {
        for (var map in value.data) {
          CompanyModel companyModel = CompanyModel.fromJson(map);
          setState(() {
            companyModels.add(companyModel);
            print(companyModels.length);
            status = true;
          });
        }
        // setState(() {
        //   _companyId.text = (companyModels.length + 1).toString();
        // });
      } else {
        setState(() {
          status = false;
        });
      }
    });
  }

  // Future<void> apiPOSTcompanyNew() async {
  //   try {
  //     Response response =
  //         await Dio().post(MyConstant().urlSettingAddCompany, data: {
  //       "com_name": companyName,
  //       "com_address": companyAddress,
  //       "com_lat": companyLat,
  //       "com_long": companyLong,
  //       "com_tel": companyTel,
  //       "com_reference": companyRef,
  //     });
  //     print('response = $response');
  //     if (response.toString() == 'SUCCESS') {
  //       // normalDialog(context, 'Account successfully added');
  //       setState(() {
  //         _companyId.clear();
  //         _companyName.clear();
  //         _companyAddress.clear();
  //         _companyLat.clear();
  //         _companyLong.clear();
  //         _companyTel.clear();
  //         _companyRef.clear();
  //         apiGetListCompany();
  //       });
  //     } else {
  //       normalDialog(
  //           context, 'ไม่สามารถเพิ่มข้อมูลบริษัทได้ กรุณาลองใหม่อีกครั้ง');
  //     }
  //   } catch (e) {
  //     normalDialog(context, e.toString());
  //   }
  // }
  Future<void> apiPOSTcompanyNew() async {
    showDialog(
      context: context,
      builder: (context) => SimpleDialog(
        title: Mystyle().textCustom(
            "คุณต้องการเพิ่มข้อมูลลูกค้าใช่หรือไม่", 20.0, Colors.red),
        children: <Widget>[
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: <Widget>[
              TextButton.icon(
                onPressed: () async {
                  await Dio().post(MyConstant().urlSettingAddCompany, data: {
                    "com_name": companyName,
                    "com_address": companyAddress,
                    "com_lat": companyLat,
                    "com_long": companyLong,
                    "com_tel": companyTel,
                    "com_reference": companyRef,
                  }).then(
                    (value) {
                      if (value.toString() == 'SUCCESS') {
                        Navigator.pop(context);
                        setState(() {
                          _companyId.clear();
                          _companyName.clear();
                          _companyAddress.clear();
                          _companyLat.clear();
                          _companyLong.clear();
                          _companyTel.clear();
                          _companyRef.clear();
                          apiGetListCompany();
                        });
                      } else {
                        Navigator.pop(context);
                        normalDialog(context,
                            'ไม่สามารถเพิ่มข้อมูลบริษัทได้ กรุณาลองใหม่อีกครั้ง');
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
                    _companyId.clear();
                    _companyName.clear();
                    _companyAddress.clear();
                    _companyLat.clear();
                    _companyLong.clear();
                    _companyTel.clear();
                    _companyRef.clear();
                    apiGetListCompany();
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

  Future<void> apiUpdateCompany(String url, String header) async {
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
                    "com_id": _companyId.text,
                    "com_name": companyName,
                    "com_address": companyAddress,
                    "com_lat": companyLat,
                    "com_long": companyLong,
                    "com_tel": companyTel,
                    "com_reference": companyRef,
                  }).then(
                    (value) {
                      if (value.toString() == 'SUCCESS') {
                        Navigator.pop(context);
                        setState(() {
                          _inserData = true;
                          _updateData = false;
                          _companyId.clear();
                          _companyName.clear();
                          _companyAddress.clear();
                          _companyLat.clear();
                          _companyLong.clear();
                          _companyTel.clear();
                          _companyRef.clear();
                          apiGetListCompany();
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
                    _companyId.clear();
                    _companyName.clear();
                    _companyAddress.clear();
                    _companyLat.clear();
                    _companyLong.clear();
                    _companyTel.clear();
                    _companyRef.clear();
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
        title: Mystyle().textHeader("เพิ่มข้อมูลบริษัท"),
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
                        _inserData ? insertData() : updatEData(),
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
      // floatingActionButton: FloatingActionButton.extended(
      //   onPressed: () {},
      //   label: const Text("ABCD"),
      // ),
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

  Widget updatEData() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        deleteData(),
        Mystyle().mySizeBox(10.0, 10.0),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            updateData(),
            cancel(),
          ],
        ),
      ],
    );
  }

  Widget bodyTable() {
    if (status == false) {
      return const Center(
        child: Text(
          'ยังไม่มีข้อมูลบริษัท',
          style: TextStyle(
              fontWeight: FontWeight.bold, fontSize: 20, fontFamily: 'Sarabun'),
        ),
      );
    } else {
      return Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          SingleChildScrollView(
            child: Center(
              child: DataTable(
                showCheckboxColumn: false,
                showBottomBorder: true,
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
                      'ชื่อบริษัท',
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
                      'ที่อยู่',
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
                rows: companyModels
                    .map(
                      (companyModel) => DataRow(
                        onSelectChanged: (newValue) {
                          setState(() {
                            _inserData = false;
                            _updateData = true;
                            _companyId.text = companyModel.comId!.toString();
                            _companyName.text = companyModel.comName!;
                            _companyAddress.text = companyModel.comAddress!;
                            _companyLat.text = companyModel.comLat!;
                            _companyLong.text = companyModel.comLong!;
                            _companyTel.text = companyModel.comTel!;
                            _companyRef.text = companyModel.comReference!;

                            companyName = companyModel.comName!;
                            companyAddress = companyModel.comAddress!;
                            companyLat = companyModel.comLat!;
                            companyLong = companyModel.comLong!;
                            companyTel = companyModel.comTel!;
                            companyRef = companyModel.comReference!;
                          });
                        },
                        cells: [
                          // DataCell(
                          //   SizedBox(
                          //     // width: MediaQuery.of(context).size.width * 0.2,
                          //     child: Text(
                          //       companyModel.comId.toString(),
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
                                companyModel.comName.toString(),
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
                              // width: MediaQuery.of(context).size.width * 0.3,
                              child: Text(
                                companyModel.comAddress.toString(),
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
                          // DataCell(
                          //   SizedBox(
                          //     // width: MediaQuery.of(context).size.width * 0.2,
                          //     child: Text(
                          //       companyModel.comLat.toString(),
                          //       style: const TextStyle(
                          //         color: Colors.green,
                          //         fontSize: 13,
                          //         fontFamily: 'Sarabun',
                          //         fontWeight: FontWeight.bold,
                          //       ),
                          //     ),
                          //   ),
                          // ),
                          // DataCell(
                          //   SizedBox(
                          //     // width: MediaQuery.of(context).size.width * 0.2,
                          //     child: Text(
                          //       companyModel.comLong.toString(),
                          //       style: const TextStyle(
                          //         color: Colors.green,
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
                                companyModel.comTel.toString(),
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
                                companyModel.comReference.toString(),
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
          FloatingActionButton.extended(
            onPressed: () {},
            label: const Text("DATA"),
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
            Mystyle().textHeader("ชื่อบริษัท"),
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
                  controller: _companyName,
                  style: const TextStyle(
                      fontFamily: "Sarabun",
                      fontSize: 20,
                      fontWeight: FontWeight.bold),
                  onChanged: (value) {
                    companyName = value.trim();
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
            Mystyle().textHeader("ที่อยู่"),
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
                  controller: _companyAddress,
                  maxLines: 5,
                  style: const TextStyle(
                      fontFamily: "Sarabun",
                      fontSize: 20,
                      fontWeight: FontWeight.bold),
                  onChanged: (value) {
                    companyAddress = value.trim();
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
                  controller: _companyLat,
                  style: const TextStyle(
                      fontFamily: "Sarabun",
                      fontSize: 20,
                      fontWeight: FontWeight.bold),
                  onChanged: (value) {
                    companyLat = value.trim();
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
                  controller: _companyLong,
                  style: const TextStyle(
                      fontFamily: "Sarabun",
                      fontSize: 20,
                      fontWeight: FontWeight.bold),
                  onChanged: (value) {
                    companyLong = value.trim();
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
                  controller: _companyTel,
                  style: const TextStyle(
                      fontFamily: "Sarabun",
                      fontSize: 20,
                      fontWeight: FontWeight.bold),
                  onChanged: (value) {
                    companyTel = value.trim();
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
                  controller: _companyRef,
                  style: const TextStyle(
                      fontFamily: "Sarabun",
                      fontSize: 20,
                      fontWeight: FontWeight.bold),
                  onChanged: (value) {
                    companyRef = value.trim();
                  },
                ),
              ),
            ),
          ],
        ),
        Mystyle().mySizeBox(20.0, 20.0),
      ],
    );
  }

  Widget ok() {
    var w = MediaQuery.of(context).size.width * 0.1;
    return Visibility(
      visible: _inserData,
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
          if (companyName != null &&
                  companyAddress != null &&
                  companyLat != null ||
              companyLong != null && companyTel != null && companyRef != null) {
            apiPOSTcompanyNew();
            // normalDialog(context, "ขอบคุณครับ");
          } else {
            normalDialog(context, "กรุณากรอกข้อมูลให้ครบ");
          }
        },
        child: Mystyle().textHeader("เพิ่มข้อมูล"),
      ),
    );
  }

  Widget updateData() {
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
          apiUpdateCompany(MyConstant().urlSettingUpCompany,
              "คุณต้องการอัพเดทข้อมูลบริษัทใช่หรือไม่");
        },
        child: Mystyle().textCustom("แก้ไขข้อมูล", 20.0, Colors.black),
      ),
    );
  }

  Widget deleteData() {
    var w = MediaQuery.of(context).size.width * 0.1;
    return Visibility(
      visible: _updateData,
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
          apiUpdateCompany(MyConstant().urlSettingDeCompany,
              "คุณต้องการลบข้อมูลบริษัทใช่หรือไม่");
        },
        child: Mystyle().textCustom(
          "ลบข้อมูล",
          20.0,
          Colors.white,
        ),
      ),
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
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
        ),
        onPressed: () {
          setState(() {
            _inserData = true;
            _updateData = false;
            _companyId.clear();
            _companyName.clear();
            _companyAddress.clear();
            _companyLat.clear();
            _companyLong.clear();
            _companyTel.clear();
            _companyRef.clear();
          });
        },
        child: Mystyle().textHeader("ล้างหน้าจอ"),
      ),
    );
  }
}
