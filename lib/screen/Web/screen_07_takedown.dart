// ignore_for_file: avoid_print

import 'package:dio/dio.dart';
import 'package:fleetdemo/model/model_pumpdetail.dart';
import 'package:fleetdemo/model/model_recieve_oil.dart';
import 'package:fleetdemo/utility/dialog.dart';
import 'package:fleetdemo/utility/my_style.dart';
import 'package:fleetdemo/utility/myconstant.dart';
import 'package:flutter/material.dart';

class ScreenTakeDownWeb extends StatefulWidget {
  const ScreenTakeDownWeb({Key? key}) : super(key: key);

  @override
  _ScreenTakeDownWebState createState() => _ScreenTakeDownWebState();
}

class _ScreenTakeDownWebState extends State<ScreenTakeDownWeb> {
  bool loadstatus = true;
  bool status = true;
  List<RecieveOilModel> recieveModels = [];
  List<PumpDetailModel> pumpDetailModels = [];
  bool _update = false;
  bool _insert = true;
  static const timer = Duration(seconds: 1);

  DateTime? dateTime;
  int? pumpTankVolumn;

  DateTime timestamp = DateTime.now();

  String? volumn, price, ref, pumpTankCode, pumpTankProduct;

  final dateRecieve = TextEditingController();
  final _textBoxRef = TextEditingController();
  final _textBoxVolumn = TextEditingController();
  final _textBoxPrice = TextEditingController();
  final _pumpTankProduct = TextEditingController();

  Future pickDateTime(BuildContext context) async {
    final date = await pickDate(context);
    if (date == null) return;

    final time = await pickTime(context);
    if (time == null) return;

    setState(() {
      dateTime = DateTime(
        date.year,
        date.month,
        date.day,
        time.hour,
        time.minute,
      );
      dateRecieve.text = dateTime.toString();
    });
  }

  Future<DateTime?> pickDate(BuildContext context) async {
    final initialDate = DateTime.now();
    final newDate = await showDatePicker(
      context: context,
      initialDate: dateTime ?? initialDate,
      firstDate: DateTime(DateTime.now().year - 5),
      lastDate: DateTime(DateTime.now().year + 5),
    );

    if (newDate == null) return null;

    return newDate;
  }

  Future<TimeOfDay?> pickTime(BuildContext context) async {
    const initialTime = TimeOfDay(hour: 9, minute: 0);
    final newTime = await showTimePicker(
      context: context,
      initialTime: dateTime != null
          ? TimeOfDay(hour: dateTime!.hour, minute: dateTime!.minute)
          : initialTime,
    );

    if (newTime == null) return null;

    return newTime;
  }

  @override
  void initState() {
    super.initState();
    apiGetListTank();
    // timer;
    apiGetRecieveOil();
    // timer;
  }

  Future<void> apiGetListTank() async {
    if (pumpDetailModels.isNotEmpty) {
      pumpDetailModels.clear();
    }
    await Dio().get(MyConstant().urlSettingPumpDetail).then((value) {
      if (value.toString() != 'null') {
        for (var map in value.data) {
          PumpDetailModel pumpDetailModel = PumpDetailModel.fromJson(map);
          setState(() {
            pumpDetailModels.add(pumpDetailModel);
          });
        }
      }
    });
  }

  Future<void> apiGetRecieveOil() async {
    if (recieveModels.isNotEmpty) {
      recieveModels.clear();
    }
    print("start get ${MyConstant().urlOilRecieve} ${timestamp.toString()}");
    await Dio().get(MyConstant().urlOilRecieve).then((value) {
      setState(() {
        loadstatus = false;
        timestamp = DateTime.now();
      });
      print("finish get ${MyConstant().urlOilRecieve} ${timestamp.toString()}");
      if (value.toString() != 'null') {
        for (var map in value.data) {
          RecieveOilModel recieveOilModel = RecieveOilModel.fromJson(map);
          setState(() {
            recieveModels.add(recieveOilModel);
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

  Future<void> apiAddQuota() async {
    showDialog(
      context: context,
      builder: (context) => SimpleDialog(
        title: Mystyle().textCustom(
            "คุณต้องการเพิ่มข้อมูลลงรับใช่หรือไม่", 20.0, Colors.red),
        children: <Widget>[
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: <Widget>[
              TextButton.icon(
                onPressed: () async {
                  await Dio().post(MyConstant().urlOilRecAdd, data: {
                    "recieve_DateRecieve": dateTime.toString(),
                    "recieve_Ref": ref,
                    "tank_id": pumpTankCode,
                    "product_name": pumpTankProduct,
                    "recieve_volumn": volumn,
                    "recieve_price": price
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
                        dateTime = null;
                        pumpTankVolumn = null;
                        volumn = null;
                        price = null;
                        ref = null;
                        pumpTankCode = null;
                        pumpTankProduct = null;
                        dateRecieve.clear();
                        _textBoxRef.clear();
                        _textBoxVolumn.clear();
                        _textBoxPrice.clear();
                        _pumpTankProduct.clear();
                        apiGetRecieveOil();
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
                    dateTime = null;
                    pumpTankVolumn = null;
                    volumn = null;
                    price = null;
                    ref = null;
                    pumpTankCode = null;
                    pumpTankProduct = null;
                    dateRecieve.clear();
                    _textBoxRef.clear();
                    _textBoxVolumn.clear();
                    _textBoxPrice.clear();
                    _pumpTankProduct.clear();
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
    return loadstatus
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
                      _insert ? insertRecieveButton() : updateRecieveButton(),
                    ],
                  ),
                ),
                Container(
                  padding: const EdgeInsets.all(20.0),
                  width: MediaQuery.of(context).size.width * 0.7,
                  // color: Colors.grey.shade100,
                  child: bodyRecieve(),
                ),
              ],
            ),
          );
  }

  Widget updateRecieveButton() => Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            updateQuota(),
            Mystyle().mySizeBox(10.0, 10.0),
            cancelQuota(),
          ],
        ),
      );
  Widget insertRecieveButton() => Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            addQuota(),
            Mystyle().mySizeBox(10.0, 10.0),
            cancelQuota(),
          ],
        ),
      );
  Widget updateQuota() {
    var w = MediaQuery.of(context).size.width * 0.1;
    return Visibility(
      visible: _update,
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
            dateTime = null;
            pumpTankVolumn = null;
            volumn = null;
            price = null;
            ref = null;
            pumpTankCode = null;
            pumpTankProduct = null;
            dateRecieve.clear();
            _textBoxRef.clear();
            _textBoxVolumn.clear();
            _textBoxPrice.clear();
            _pumpTankProduct.clear();
          });
        },
        child: Mystyle().textCustom("ยกเลิก", 30.0, Colors.white),
      ),
    );
  }

  Widget addQuota() {
    var w = MediaQuery.of(context).size.width * 0.1;
    return Visibility(
      visible: _insert,
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
          if (dateTime == null ||
              ref == null ||
              pumpTankCode == null ||
              pumpTankProduct == null ||
              volumn == null) {
            normalDialog(context, "กรุณากรอกข้อมูลให้ครบถ้วน");
          } else {
            var intVolumn = int.parse(volumn!);
            if (intVolumn > pumpTankVolumn!) {
              normalDialog(context, "ปริมาณลงรับ มากกว่า ความจุถัง");
            } else {
              apiAddQuota();
            }
          }
        },
        child: Mystyle().textCustom("เพิ่มข้อมูล", 30.0, Colors.white),
      ),
    );
  }

  Widget bodyRecieve() {
    if (status == false) {
      return const Center(
        child: Text(
          'ไม่มีรายการลงรับ',
          style: TextStyle(
              fontWeight: FontWeight.bold, fontSize: 20, fontFamily: 'Sarabun'),
        ),
      );
    } else {
      return Column(
        children: [
          SingleChildScrollView(
            scrollDirection: Axis.vertical,
            child: Center(
              child: DataTable(
                showCheckboxColumn: false,
                showBottomBorder: true,
                columnSpacing: 40,
                columns: const <DataColumn>[
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
                      'วันที่ทำรายการ',
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
                      'เลขที่ REF',
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
                      'หมายเลขถัง',
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
                      'น้ำมัน',
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
                      'ปริมาณลงรับ',
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
                      'ราคาลงรับ',
                      style: TextStyle(
                        color: Colors.red,
                        fontSize: 15,
                        fontFamily: 'Sarabun',
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
                rows: recieveModels
                    .map(
                      (recieveModel) => DataRow(
                        onSelectChanged: (newValue) {},
                        cells: [
                          DataCell(
                            SizedBox(
                              child: Text(
                                recieveModel.recieveCreateDate!,
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
                              child: Text(
                                recieveModel.recieveDateRecieve!,
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
                              child: Text(
                                recieveModel.recieveRef!,
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
                              child: Text(
                                recieveModel.tankId!,
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
                              child: Text(
                                recieveModel.productName!,
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
                              child: Text(
                                recieveModel.recieveVolumn!,
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
                              child: Text(
                                recieveModel.recievePrice!,
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

  Widget bodyMenu() => Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          rowselectDate(),
          Mystyle().mySizeBox(10.0, 10.0),
          refInvoice(),
          Mystyle().mySizeBox(10.0, 10.0),
          selectTanks(),
          Mystyle().mySizeBox(10.0, 10.0),
          productName(),
          Mystyle().mySizeBox(10.0, 10.0),
          recieveVolumn(),
          Mystyle().mySizeBox(10.0, 10.0),
          recievePrice(),
        ],
      );
  Widget rowselectDate() => Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Mystyle().textHeader("วันที่เวลา"),
          Mystyle().mySizeBox(10.0, 10.0),
          Container(
            width: MediaQuery.of(context).size.width * 0.2,
            padding: const EdgeInsets.all(5),
            decoration: Mystyle().myBoxDecoration(),
            child: Container(
              padding: const EdgeInsets.all(8.0),
              child: TextField(
                textAlign: TextAlign.center,
                controller: dateRecieve,
                style: const TextStyle(
                    fontFamily: "Sarabun",
                    fontSize: 20,
                    fontWeight: FontWeight.bold),
              ),
            ),
          ),
          Mystyle().mySizeBox(10.0, 10.0),
          IconButton(
            onPressed: () {
              pickDateTime(context);
            },
            icon: const Icon(Icons.date_range_sharp),
          ),
        ],
      );
  Widget refInvoice() => Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Mystyle().textHeader("เลขที่ REF "),
          Mystyle().mySizeBox(10.0, 10.0),
          Container(
            padding: const EdgeInsets.all(5),
            decoration: Mystyle().myBoxDecoration(),
            child: Container(
              width: MediaQuery.of(context).size.width * 0.2,
              padding: const EdgeInsets.all(8.0),
              child: TextField(
                controller: _textBoxRef,
                style: Mystyle().myTextFieldStyle(),
                onChanged: (value) {
                  ref = value.trim();
                },
              ),
            ),
          ),
        ],
      );
  Widget selectTanks() => Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Mystyle().textHeader("ถังน้ำมัน"),
          Mystyle().mySizeBox(10.0, 10.0),
          Container(
            padding: const EdgeInsets.all(5),
            decoration: Mystyle().myBoxDecoration(),
            child: Container(
              height: 65,
              width: MediaQuery.of(context).size.width * 0.2,
              padding: const EdgeInsets.all(8.0),
              child: DropdownButtonHideUnderline(
                child: DropdownButton<String>(
                  hint: Mystyle().textHeader("เลือกถัง"),
                  value: pumpTankCode,
                  isDense: true,
                  onChanged: (String? newValue) {
                    setState(() {
                      pumpTankCode = newValue!;
                    });
                  },
                  items: pumpDetailModels.map((PumpDetailModel map) {
                    return DropdownMenuItem<String>(
                      value: map.tankId.toString(),
                      onTap: () {
                        setState(() {
                          _pumpTankProduct.text = map.productDetail!;
                          pumpTankProduct = map.productDetail!;
                          pumpTankVolumn = map.tankCapacity!;
                        });
                      },
                      child: Text(
                        map.tankId.toString(),
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
  Widget productName() => Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Mystyle().textHeader("ชนิดน้ำมัน"),
          Mystyle().mySizeBox(10.0, 10.0),
          Container(
            padding: const EdgeInsets.all(5),
            decoration: Mystyle().myBoxDecoration(),
            child: Container(
              width: MediaQuery.of(context).size.width * 0.2,
              padding: const EdgeInsets.all(8.0),
              child: TextField(
                enabled: false,
                controller: _pumpTankProduct,
                style: Mystyle().myTextFieldStyle(),
                onChanged: (value) {
                  pumpTankProduct = value.trim();
                },
              ),
            ),
          ),
        ],
      );
  Widget recieveVolumn() => Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Mystyle().textHeader("ปริมาณลงรับ"),
          Mystyle().mySizeBox(10.0, 10.0),
          Container(
            padding: const EdgeInsets.all(5),
            decoration: Mystyle().myBoxDecoration(),
            child: Container(
              width: MediaQuery.of(context).size.width * 0.2,
              padding: const EdgeInsets.all(8.0),
              child: TextField(
                controller: _textBoxVolumn,
                style: Mystyle().myTextFieldStyle(),
                onChanged: (value) {
                  volumn = value.trim();
                },
              ),
            ),
          ),
        ],
      );
  Widget recievePrice() => Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Mystyle().textHeader("ราคาลงรับ"),
          Mystyle().mySizeBox(10.0, 10.0),
          Container(
            padding: const EdgeInsets.all(5),
            decoration: Mystyle().myBoxDecoration(),
            child: Container(
              width: MediaQuery.of(context).size.width * 0.2,
              padding: const EdgeInsets.all(8.0),
              child: TextField(
                controller: _textBoxPrice,
                style: Mystyle().myTextFieldStyle(),
                onChanged: (value) {
                  price = value.trim();
                },
              ),
            ),
          ),
        ],
      );
}
