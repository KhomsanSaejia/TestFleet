import 'package:dio/dio.dart';
import 'package:fleetdemo/model/model_product.dart';
import 'package:fleetdemo/model/model_pumpdetail.dart';
import 'package:fleetdemo/model/model_tank.dart';
import 'package:fleetdemo/utility/dialog.dart';
import 'package:fleetdemo/utility/my_style.dart';
import 'package:fleetdemo/utility/myconstant.dart';
import 'package:flutter/material.dart';

class ScreenSettingAddPumpProductWeb extends StatefulWidget {
  const ScreenSettingAddPumpProductWeb({Key? key}) : super(key: key);

  @override
  _ScreenSettingAddPumpProductWebState createState() =>
      _ScreenSettingAddPumpProductWebState();
}

class _ScreenSettingAddPumpProductWebState
    extends State<ScreenSettingAddPumpProductWeb> {
  bool _statusProduct = true;
  bool _loadstatusProduct = true;
  bool _inserDataProduct = true;
  bool _updateDataProduct = false;
  String productCode = "-", productName = "-", productDetail = "-";
  final _id = TextEditingController();
  final _productCode = TextEditingController();
  final _productName = TextEditingController();
  final _productDetail = TextEditingController();

  bool _statusTank = true;
  bool _loadstatusTank = true;
  bool _inserDataTank = true;
  bool _updateDataTank = false;
  String? tankProductCode;
  String tankId = "-", tankCapacity = "-";
  final _tankId = TextEditingController();
  final _tankCapacity = TextEditingController();
  final _tankProductCode = TextEditingController();

  bool _statusPump = true;
  bool _loadstatusPump = true;
  bool _inserDataPump = true;
  bool _updateDataPump = false;
  String pumpId = "-", pumpChannal = "-", pumpNozzle = "-", keyPadId = "-";
  final _pumpId = TextEditingController();
  final _pumpChannal = TextEditingController();
  final _pumpNozzle = TextEditingController();
  final _keyPadId = TextEditingController();
  String? pumpTankCode;
  static const timer = Duration(seconds: 1);

  List<ProductModel> productModels = [];
  List<TankModel> tankModels = [];
  List<PumpDetailModel> pumpDetailModels = [];

  @override
  void initState() {
    super.initState();
    apiGetListProduct();
    timer;
    apiGetListTank();
    timer;
    apiGetListPump();
  }

  Future<void> apiGetListProduct() async {
    if (productModels.isNotEmpty) {
      productModels.clear();
    }
    await Dio().get(MyConstant().urlSettingProdList).then((value) {
      setState(() {
        _loadstatusProduct = false;
      });
      if (value.toString() != 'null') {
        for (var map in value.data) {
          ProductModel driverNameModel = ProductModel.fromJson(map);
          setState(() {
            productModels.add(driverNameModel);
            _statusProduct = true;
          });
        }
      } else {
        setState(() {
          _statusProduct = false;
        });
      }
    });
  }

  Future<void> apiGetListTank() async {
    if (tankModels.isNotEmpty) {
      tankModels.clear();
    }
    await Dio().get(MyConstant().urlSettingTankList).then((value) {
      setState(() {
        _loadstatusTank = false;
      });
      if (value.toString() != 'null') {
        for (var map in value.data) {
          TankModel tankModel = TankModel.fromJson(map);
          setState(() {
            tankModels.add(tankModel);
            _statusTank = true;
          });
        }
      } else {
        setState(() {
          _statusTank = false;
        });
      }
    });
  }

  Future<void> apiGetListPump() async {
    if (pumpDetailModels.isNotEmpty) {
      pumpDetailModels.clear();
    }
    await Dio().get(MyConstant().urlSettingPumpDetail).then((value) {
      setState(() {
        _loadstatusPump = false;
      });
      if (value.toString() != 'null') {
        for (var map in value.data) {
          PumpDetailModel pumpDetailModel = PumpDetailModel.fromJson(map);
          setState(() {
            pumpDetailModels.add(pumpDetailModel);
            _statusPump = true;
          });
        }
      } else {
        setState(() {
          _statusPump = false;
        });
      }
    });
  }

  Future<void> apiAddTank() async {
    showDialog(
      context: context,
      builder: (context) => SimpleDialog(
        title: Mystyle()
            .textCustom("คุณต้องการเพิ่มข้อมูลถังใช่หรือไม่", 20.0, Colors.red),
        children: <Widget>[
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: <Widget>[
              TextButton.icon(
                onPressed: () async {
                  await Dio().post(MyConstant().urlSettingTankAdd, data: {
                    "tank_id": tankId,
                    "tank_capacity": tankCapacity,
                    "product_id": tankProductCode
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
                        _inserDataTank = true;
                        _updateDataTank = false;
                        tankId = "-";
                        tankCapacity = "-";
                        tankProductCode = null;

                        _tankId.clear();
                        _tankCapacity.clear();
                        _tankProductCode.clear();
                        apiGetListProduct();
                        apiGetListTank();
                        apiGetListPump();
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
                    _inserDataTank = true;
                    _updateDataTank = false;
                    tankId = "-";
                    tankCapacity = "-";
                    tankProductCode = null;

                    _tankId.clear();
                    _tankCapacity.clear();
                    _tankProductCode.clear();
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

  Future<void> apiAddProduct() async {
    showDialog(
      context: context,
      builder: (context) => SimpleDialog(
        title: Mystyle().textCustom(
            "คุณต้องการเพิ่มข้อมูลน้ำมันใช่หรือไม่", 20.0, Colors.red),
        children: <Widget>[
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: <Widget>[
              TextButton.icon(
                onPressed: () async {
                  await Dio().post(MyConstant().urlSettingProdAdd, data: {
                    "product_id": productCode,
                    "product_name": productName,
                    "product_detail": productDetail
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
                        _inserDataProduct = true;
                        _updateDataProduct = false;
                        productCode = "-";
                        productName = "-";
                        productDetail = "-";

                        _id.clear();
                        _productCode.clear();
                        _productName.clear();
                        _productDetail.clear();
                        apiGetListProduct();
                        apiGetListTank();
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
                    _inserDataProduct = true;
                    _updateDataProduct = false;
                    productCode = "-";
                    productName = "-";
                    productDetail = "-";

                    _id.clear();
                    _productCode.clear();
                    _productName.clear();
                    _productDetail.clear();
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

  Future<void> apiAddPump() async {
    showDialog(
      context: context,
      builder: (context) => SimpleDialog(
        title: Mystyle().textCustom(
            "คุณต้องการเพิ่มข้อมูลตู้จ่ายใช่หรือไม่", 20.0, Colors.red),
        children: <Widget>[
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: <Widget>[
              TextButton.icon(
                onPressed: () async {
                  await Dio().post(MyConstant().urlSettingPumpAdd, data: {
                    "pump_id": pumpId,
                    "pump_channal": pumpChannal,
                    "pump_nozzle": pumpNozzle,
                    "tank_id": pumpTankCode,
                    "keypad_id": keyPadId
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
                        _inserDataPump = true;
                        _updateDataPump = false;
                        pumpId = "-";
                        pumpChannal = "-";
                        pumpNozzle = "-";
                        pumpTankCode = null;
                        keyPadId = "-";

                        _pumpId.clear();
                        _pumpChannal.clear();
                        _pumpNozzle.clear();
                        _keyPadId.clear();
                        apiGetListProduct();
                        apiGetListTank();
                        apiGetListPump();
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
                    _inserDataPump = true;
                    _updateDataPump = false;
                    pumpId = "-";
                    pumpChannal = "-";
                    pumpNozzle = "-";
                    pumpTankCode = null;
                    keyPadId = "-";

                    _pumpId.clear();
                    _pumpChannal.clear();
                    _pumpNozzle.clear();
                    _keyPadId.clear();
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

  Future<void> apiUpdateProduct(String url, String header) async {
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
                    "product_id": productCode,
                    "product_name": productName,
                    "product_detail": productDetail
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
                        _inserDataProduct = true;
                        _updateDataProduct = false;
                        productCode = "-";
                        productName = "-";
                        productDetail = "-";

                        _productCode.clear();
                        _productName.clear();
                        _productDetail.clear();
                        apiGetListProduct();
                        apiGetListTank();
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
                    _inserDataProduct = true;
                    _updateDataProduct = false;
                    productCode = "-";
                    productName = "-";
                    productDetail = "-";

                    _id.clear();
                    _productCode.clear();
                    _productName.clear();
                    _productDetail.clear();
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

  Future<void> apiUpdatePump(String url, String header) async {
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
                    "pump_id": pumpId,
                    "pump_channal": pumpChannal,
                    "pump_nozzle": pumpNozzle,
                    "tank_id": pumpTankCode,
                    "keypad_id": keyPadId
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
                        _inserDataPump = true;
                        _updateDataPump = false;
                        pumpId = "-";
                        pumpChannal = "-";
                        pumpNozzle = "-";
                        pumpTankCode = null;
                        keyPadId = "-";

                        _pumpId.clear();
                        _pumpChannal.clear();
                        _pumpNozzle.clear();
                        _keyPadId.clear();
                        apiGetListProduct();
                        apiGetListTank();
                        apiGetListPump();
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
                    _inserDataPump = true;
                    _updateDataPump = false;
                    pumpId = "-";
                    pumpChannal = "-";
                    pumpNozzle = "-";
                    pumpTankCode = null;
                    keyPadId = "-";

                    _pumpId.clear();
                    _pumpChannal.clear();
                    _pumpNozzle.clear();
                    _keyPadId.clear();
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

  Future<void> apiUpdateTank(String url, String header) async {
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
                    "tank_id": tankId,
                    "tank_capacity": tankCapacity,
                    "product_id": tankProductCode
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
                        _inserDataTank = true;
                        _updateDataTank = false;
                        tankId = "-";
                        tankCapacity = "-";
                        tankProductCode = null;

                        _tankId.clear();
                        _tankCapacity.clear();
                        _tankProductCode.clear();
                        apiGetListProduct();
                        apiGetListTank();
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
                    _inserDataTank = true;
                    _updateDataTank = false;
                    tankId = "-";
                    tankCapacity = "-";
                    tankProductCode = null;

                    _tankId.clear();
                    _tankCapacity.clear();
                    _tankProductCode.clear();
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
        title: Mystyle().textHeader("เพิ่มข้อมูล ตู้จ่าย และ ชนิดน้ำมัน"),
        centerTitle: true,
      ),
      body: _loadstatusProduct
          ? Mystyle().showprogress()
          : Container(
              color: Colors.grey.shade200,
              width: MediaQuery.of(context).size.width * 1,
              child: Column(
                children: [
                  aRows(),
                  _loadstatusPump ? Mystyle().showprogress() : bRows()
                ],
              ),
            ),
    );
  }

  Widget bRows() {
    return Container(
      padding: const EdgeInsets.all(8.0),
      width: MediaQuery.of(context).size.width * 1,
      height: (MediaQuery.of(context).size.width * 0.26) - 8.6,
      decoration: BoxDecoration(
        // color: Colors.red.shade200,
        border: Border.all(width: 2),
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              munuPump(),
              Container(
                  child:
                      _inserDataPump ? insertPumpButton() : updatePumpButton()),
            ],
          ),
          Container(
            width: MediaQuery.of(context).size.width * 1,
            height: (MediaQuery.of(context).size.width * 0.2) - 3.4,
            color: Colors.white,
            child: bodyPump(),
          ),
        ],
      ),
    );
  }

  Widget bodyPump() {
    if (_statusPump == false) {
      return const Center(
        child: Text(
          'ยังไม่มีข้อมูลตู้จ่าย',
          style: TextStyle(
              fontWeight: FontWeight.bold, fontSize: 20, fontFamily: 'Sarabun'),
        ),
      );
    } else {
      return SingleChildScrollView(
        child: Center(
          child: DataTable(
            showCheckboxColumn: false,
            showBottomBorder: true,
            columnSpacing: 100,
            columns: const <DataColumn>[
              DataColumn(
                label: Text(
                  'ตู้จ่าย ',
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
                  'หน้าจ่าย',
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
                  'มือจ่าย',
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
                  'ถัง',
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
                  'ชนิดน้ำมัน',
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
                  'รายละเอียด',
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
                  'ความจุถัง',
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
                  'คีย์แพด',
                  style: TextStyle(
                    color: Colors.red,
                    fontSize: 15,
                    fontFamily: 'Sarabun',
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
            rows: pumpDetailModels
                .map(
                  (pumpDetailModel) => DataRow(
                    onSelectChanged: (newValue) {
                      setState(() {
                        _inserDataPump = false;
                        _updateDataPump = true;

                        _pumpId.text = pumpDetailModel.pumpId.toString();
                        _pumpChannal.text =
                            pumpDetailModel.pumpChannal.toString();
                        _pumpNozzle.text =
                            pumpDetailModel.pumpNozzle.toString();
                        _keyPadId.text = pumpDetailModel.keypadId!;

                        pumpId = pumpDetailModel.pumpId.toString();
                        pumpChannal = pumpDetailModel.pumpChannal.toString();
                        pumpNozzle = pumpDetailModel.pumpNozzle.toString();
                        productDetail = pumpDetailModel.productDetail!;
                        pumpTankCode = pumpDetailModel.tankId.toString();
                        keyPadId = pumpDetailModel.keypadId!;
                      });
                    },
                    cells: [
                      DataCell(
                        SizedBox(
                          // width: MediaQuery.of(context).size.width * 0.2,
                          child: Text(
                            pumpDetailModel.pumpId.toString(),
                            style: TextStyle(
                              color: Colors.blue.shade400,
                              fontSize: 13,
                              fontFamily: 'Sarabun',
                              fontWeight: FontWeight.bold,
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ),
                      DataCell(
                        SizedBox(
                          // width: MediaQuery.of(context).size.width * 0.2,
                          child: Text(
                            pumpDetailModel.pumpChannal.toString(),
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
                            pumpDetailModel.pumpNozzle.toString(),
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
                          // width: MediaQuery.of(context).size.width * 0.1,
                          child: Text(
                            pumpDetailModel.tankId.toString(),
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
                            pumpDetailModel.productName.toString(),
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
                            pumpDetailModel.productDetail.toString(),
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
                            pumpDetailModel.productId.toString(),
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
                            pumpDetailModel.tankCapacity.toString(),
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
                            pumpDetailModel.keypadId.toString(),
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
      );
    }
  }

  Widget insertPumpButton() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          addPump(),
          Mystyle().mySizeBox(10.0, 10.0),
          cancelPump(),
        ],
      ),
    );
  }

  Widget updatePumpButton() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          updatePump(),
          Mystyle().mySizeBox(10.0, 10.0),
          deletePump(),
          Mystyle().mySizeBox(10.0, 10.0),
          cancelPump(),
        ],
      ),
    );
  }

  Widget munuPump() {
    return Row(
      children: [
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
            width: MediaQuery.of(context).size.width * 0.08,
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              decoration: const InputDecoration(hintText: "ระบุตู้จ่าย"),
              controller: _pumpId,
              style: const TextStyle(
                  fontFamily: "Sarabun",
                  fontSize: 20,
                  fontWeight: FontWeight.bold),
              onChanged: (value) {
                pumpId = value.trim();
              },
            ),
          ),
        ),
        Mystyle().mySizeBox(5.0, 5.0),
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
            width: MediaQuery.of(context).size.width * 0.08,
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              decoration: const InputDecoration(hintText: "ระบุหน้าจ่าย"),
              controller: _pumpChannal,
              style: const TextStyle(
                  fontFamily: "Sarabun",
                  fontSize: 20,
                  fontWeight: FontWeight.bold),
              onChanged: (value) {
                pumpChannal = value.trim();
              },
            ),
          ),
        ),
        Mystyle().mySizeBox(5.0, 5.0),
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
            width: MediaQuery.of(context).size.width * 0.08,
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              decoration: const InputDecoration(hintText: "ระบุมือจ่าย"),
              controller: _pumpNozzle,
              style: const TextStyle(
                  fontFamily: "Sarabun",
                  fontSize: 20,
                  fontWeight: FontWeight.bold),
              onChanged: (value) {
                pumpNozzle = value.trim();
              },
            ),
          ),
        ),
        Mystyle().mySizeBox(5.0, 5.0),
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
            width: MediaQuery.of(context).size.width * 0.08,
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
                items: tankModels.map((TankModel map) {
                  return DropdownMenuItem<String>(
                    value: map.tankId.toString(),
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
        Mystyle().mySizeBox(5.0, 5.0),
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
            width: MediaQuery.of(context).size.width * 0.08,
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              decoration: const InputDecoration(hintText: "คีย์แพด"),
              controller: _keyPadId,
              style: const TextStyle(
                  fontFamily: "Sarabun",
                  fontSize: 20,
                  fontWeight: FontWeight.bold),
              onChanged: (value) {
                keyPadId = value.trim();
              },
            ),
          ),
        ),
      ],
    );
  }

  Widget aRows() {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(2),
          width: MediaQuery.of(context).size.width * 0.5,
          height: MediaQuery.of(context).size.width * 0.22,
          decoration: BoxDecoration(
            border: Border.all(width: 2),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Container(
                child: munuProduct(),
              ),
              Mystyle().mySizeBox(5.0, 5.0),
              Center(
                  child: Container(
                      color: Colors.white,
                      height: MediaQuery.of(context).size.width * 0.22,
                      width: (MediaQuery.of(context).size.width * 0.34) - 3.8,
                      child: bodyProduct())),
            ],
          ),
        ),
        Container(
          padding: const EdgeInsets.all(2),
          width: MediaQuery.of(context).size.width * 0.5,
          height: MediaQuery.of(context).size.width * 0.22,
          decoration: BoxDecoration(
            border: Border.all(width: 2),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Container(
                child: munuTank(),
              ),
              Mystyle().mySizeBox(5.0, 5.0),
              Center(
                  child: Container(
                      color: Colors.white,
                      height: MediaQuery.of(context).size.width * 0.22,
                      width: (MediaQuery.of(context).size.width * 0.34) - 3.8,
                      child: bodyTank())),
            ],
          ),
        ),
      ],
    );
  }

  Widget bodyProduct() {
    if (_statusProduct == false) {
      return const Center(
        child: Text(
          'ยังไม่มีข้อมูลน้ำมัน',
          style: TextStyle(
              fontWeight: FontWeight.bold, fontSize: 20, fontFamily: 'Sarabun'),
        ),
      );
    } else {
      return SingleChildScrollView(
        child: Center(
          child: DataTable(
            showCheckboxColumn: false,
            showBottomBorder: true,
            columnSpacing: 20,
            columns: const <DataColumn>[
              DataColumn(
                label: Text(
                  'No. ',
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
                  'Product Code',
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
                  'Product Name',
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
                  'Product Desc',
                  style: TextStyle(
                    color: Colors.red,
                    fontSize: 15,
                    fontFamily: 'Sarabun',
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
            rows: productModels
                .map(
                  (productModel) => DataRow(
                    onSelectChanged: (newValue) {
                      setState(() {
                        _inserDataProduct = false;
                        _updateDataProduct = true;
                        // _id.text = productModel.id!.toString();
                        _id.text = productModel.id!.toString();
                        _productCode.text = productModel.productId!;
                        _productName.text = productModel.productName!;
                        _productDetail.text = productModel.productDetail!;

                        productCode = productModel.productId!;
                        productName = productModel.productName!;
                        productDetail = productModel.productDetail!;
                      });
                    },
                    cells: [
                      DataCell(
                        SizedBox(
                          // width: MediaQuery.of(context).size.width * 0.2,
                          child: Text(
                            productModel.id.toString(),
                            style: TextStyle(
                              color: Colors.blue.shade400,
                              fontSize: 13,
                              fontFamily: 'Sarabun',
                              fontWeight: FontWeight.bold,
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ),
                      DataCell(
                        SizedBox(
                          // width: MediaQuery.of(context).size.width * 0.2,
                          child: Text(
                            productModel.productId.toString(),
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
                            productModel.productName.toString(),
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
                            productModel.productDetail.toString(),
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
      );
    }
  }

  Widget munuProduct() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
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
                width: MediaQuery.of(context).size.width * 0.15,
                padding: const EdgeInsets.all(8.0),
                child: TextField(
                  decoration: const InputDecoration(hintText: "Product Code :"),
                  controller: _productCode,
                  style: const TextStyle(
                      fontFamily: "Sarabun",
                      fontSize: 20,
                      fontWeight: FontWeight.bold),
                  onChanged: (value) {
                    productCode = value.trim();
                  },
                ),
              ),
            ),
            Mystyle().mySizeBox(20.0, 10.0),
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
                width: MediaQuery.of(context).size.width * 0.15,
                padding: const EdgeInsets.all(8.0),
                child: TextField(
                  decoration: const InputDecoration(hintText: "Product Name :"),
                  controller: _productName,
                  style: const TextStyle(
                      fontFamily: "Sarabun",
                      fontSize: 20,
                      fontWeight: FontWeight.bold),
                  onChanged: (value) {
                    productName = value.trim();
                  },
                ),
              ),
            ),
            Mystyle().mySizeBox(20.0, 10.0),
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
                width: MediaQuery.of(context).size.width * 0.15,
                padding: const EdgeInsets.all(8.0),
                child: TextField(
                  decoration: const InputDecoration(hintText: "Product Desc :"),
                  controller: _productDetail,
                  style: const TextStyle(
                      fontFamily: "Sarabun",
                      fontSize: 20,
                      fontWeight: FontWeight.bold),
                  onChanged: (value) {
                    productDetail = value.trim();
                  },
                ),
              ),
            ),
          ],
        ),
        _inserDataProduct ? insertProductButton() : updateProductButton(),
      ],
    );
  }

  Widget updateProductButton() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          deleteProduct(),
          Mystyle().mySizeBox(10.0, 10.0),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              updateProduct(),
              Mystyle().mySizeBox(10.0, 10.0),
              cancelProduct(),
            ],
          ),
        ],
      ),
    );
  }

  Widget insertProductButton() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          addProduct(),
          Mystyle().mySizeBox(10.0, 10.0),
          cancelProduct(),
        ],
      ),
    );
  }

  Widget bodyTank() {
    if (_statusTank == false) {
      return const Center(
        child: Text(
          'ยังไม่มีข้อมูลถัง',
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
                  DataColumn(
                    label: Text(
                      'Tank No.',
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
                      'Tank Capacity',
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
                      'Product Code',
                      style: TextStyle(
                        color: Colors.red,
                        fontSize: 15,
                        fontFamily: 'Sarabun',
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ), // ),
                ],
                rows: tankModels
                    .map(
                      (tankModel) => DataRow(
                        onSelectChanged: (newValue) {
                          setState(() {
                            _inserDataTank = false;
                            _updateDataTank = true;

                            _tankId.text = tankModel.tankId.toString();
                            _tankCapacity.text =
                                tankModel.tankCapacity.toString();
                            _tankProductCode.text = tankModel.productId!;

                            tankId = tankModel.tankId.toString();
                            tankCapacity = tankModel.tankCapacity.toString();
                            tankProductCode = tankModel.productId!;
                          });
                        },
                        cells: [
                          DataCell(
                            SizedBox(
                              // width: MediaQuery.of(context).size.width * 0.2,
                              child: Text(
                                tankModel.tankId.toString(),
                                style: TextStyle(
                                  color: Colors.blue.shade400,
                                  fontSize: 13,
                                  fontFamily: 'Sarabun',
                                  fontWeight: FontWeight.bold,
                                ),
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ),
                          DataCell(
                            SizedBox(
                              // width: MediaQuery.of(context).size.width * 0.2,
                              child: Text(
                                tankModel.tankCapacity.toString(),
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
                                tankModel.productId.toString(),
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

  Widget munuTank() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
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
                width: MediaQuery.of(context).size.width * 0.15,
                padding: const EdgeInsets.all(8.0),
                child: TextField(
                  decoration: const InputDecoration(hintText: "ระบุหมายเลขถัง"),
                  controller: _tankId,
                  style: const TextStyle(
                      fontFamily: "Sarabun",
                      fontSize: 20,
                      fontWeight: FontWeight.bold),
                  onChanged: (value) {
                    tankId = value.trim();
                  },
                ),
              ),
            ),
            Mystyle().mySizeBox(20.0, 10.0),
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
                width: MediaQuery.of(context).size.width * 0.15,
                padding: const EdgeInsets.all(8.0),
                child: TextField(
                  decoration:
                      const InputDecoration(hintText: "ระบุความจุของถัง"),
                  controller: _tankCapacity,
                  style: const TextStyle(
                      fontFamily: "Sarabun",
                      fontSize: 20,
                      fontWeight: FontWeight.bold),
                  onChanged: (value) {
                    tankCapacity = value.trim();
                  },
                ),
              ),
            ),
            Mystyle().mySizeBox(20.0, 10.0),
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
                width: MediaQuery.of(context).size.width * 0.15,
                padding: const EdgeInsets.all(8.0),
                child: DropdownButtonHideUnderline(
                  child: DropdownButton<String>(
                    hint: Mystyle().textHeader("เลือกน้ำมัน"),
                    value: tankProductCode,
                    isDense: true,
                    onChanged: (String? newValue) {
                      setState(() {
                        tankProductCode = newValue!;
                      });
                    },
                    items: productModels.map((ProductModel map) {
                      return DropdownMenuItem<String>(
                        value: map.productId,
                        child: Text(
                          map.productId!,
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
            Mystyle().mySizeBox(20.0, 20.0),
          ],
        ),
        _inserDataTank ? insertTankButton() : updateTankButton(),
      ],
    );
  }

  Widget updateTankButton() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          deleteTank(),
          Mystyle().mySizeBox(10.0, 10.0),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              updateTank(),
              Mystyle().mySizeBox(10.0, 10.0),
              cancelTank(),
            ],
          ),
        ],
      ),
    );
  }

  Widget insertTankButton() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          addTank(),
          Mystyle().mySizeBox(10.0, 10.0),
          cancelTank(),
        ],
      ),
    );
  }

  Widget addPump() {
    var w = MediaQuery.of(context).size.width * 0.1;
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        fixedSize: Size(w, 74.0),
        shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
        primary: Colors.cyan,
        elevation: 20,
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
      ),
      onPressed: () {
        if (pumpId == "-" ||
            pumpId.isEmpty ||
            pumpChannal == "-" ||
            pumpChannal.isEmpty ||
            pumpNozzle == "-" ||
            pumpNozzle.isEmpty ||
            keyPadId == "-" ||
            keyPadId.isEmpty ||
            pumpTankCode == null) {
          normalDialog(context, "กรุณากรอกข้อมูลให้ครบ");
        } else {
          apiAddPump();
        }
      },
      child: Mystyle().textHeader("เพิ่มข้อมูล"),
    );
  }

  Widget updatePump() {
    var w = MediaQuery.of(context).size.width * 0.1;
    return Visibility(
      visible: _updateDataPump,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          fixedSize: Size(w, 74.0),
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
          primary: Colors.orange.shade200,
          elevation: 20,
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 20),
        ),
        onPressed: () {
          apiUpdatePump(MyConstant().urlSettingPumpUpdate,
              "คุณต้องการแก้ไขข้อมูลตู้จ่ายใช่หรือไม่");
        },
        child: Mystyle().textCustom("แก้ไขข้อมูล", 20.0, Colors.black),
      ),
    );
  }

  Widget deletePump() {
    var w = MediaQuery.of(context).size.width * 0.1;
    return Visibility(
      visible: _updateDataPump,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          fixedSize: Size(w, 74.0),
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
          primary: Colors.pink.shade400,
          elevation: 20,
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 20),
        ),
        onPressed: () {
          apiUpdatePump(MyConstant().urlSettingPumpDelete,
              "คุณต้องการลบข้อมูลตู้จ่ายใช่หรือไม่");
        },
        child: Mystyle().textCustom("ลบข้อมูล", 20.0, Colors.white),
      ),
    );
  }

  Widget cancelPump() {
    var w = MediaQuery.of(context).size.width * 0.1;
    return Visibility(
      visible: true,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          fixedSize: Size(w, 74.0),
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
          primary: Colors.red,
          elevation: 20,
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
        ),
        onPressed: () {
          setState(() {
            _inserDataPump = true;
            _updateDataPump = false;
            pumpId = "-";
            pumpChannal = "-";
            pumpNozzle = "-";
            keyPadId = "-";
            pumpTankCode = null;

            _pumpId.clear();
            _pumpChannal.clear();
            _pumpNozzle.clear();
            _keyPadId.clear();
          });
        },
        child: Mystyle().textHeader("ล้างหน้าจอ"),
      ),
    );
  }

  Widget addProduct() {
    var w = MediaQuery.of(context).size.width * 0.07;
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        fixedSize: Size(w, 50.0),
        shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
        primary: Colors.cyan,
        elevation: 20,
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
      ),
      onPressed: () {
        if (productCode == "-" ||
            productCode.isEmpty ||
            productName == "-" ||
            productName.isEmpty ||
            productDetail == "-" ||
            productDetail.isEmpty) {
          normalDialog(context, "กรุณากรอกข้อมูลให้ครบ");
        } else {
          apiAddProduct();
        }
      },
      child: Mystyle().textHeader("เพิ่มข้อมูล"),
    );
  }

  Widget updateProduct() {
    var w = MediaQuery.of(context).size.width * 0.07;
    return Visibility(
      visible: _updateDataProduct,
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
          apiUpdateProduct(MyConstant().urlSettingProdUpdate,
              "คุณต้องการแก้ไขข้อมูลน้ำมันใช่หรือไม่");
        },
        child: Mystyle().textCustom("แก้ไขข้อมูล", 20.0, Colors.black),
      ),
    );
  }

  Widget deleteProduct() {
    var w = MediaQuery.of(context).size.width * 0.07;
    return Visibility(
      visible: _updateDataProduct,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          fixedSize: Size(w, 50.0),
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
          primary: Colors.pink.shade400,
          elevation: 20,
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 20),
        ),
        onPressed: () {
          apiUpdateProduct(MyConstant().urlSettingProdDelete,
              "คุณต้องการลบข้อมูลน้ำมันใช่หรือไม่");
        },
        child: Mystyle().textCustom("ลบข้อมูล", 20.0, Colors.white),
      ),
    );
  }

  Widget cancelProduct() {
    var w = MediaQuery.of(context).size.width * 0.07;
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
            _inserDataProduct = true;
            _updateDataProduct = false;
            productCode = "-";
            productName = "-";
            productDetail = "-";

            _id.clear();
            _productCode.clear();
            _productName.clear();
            _productDetail.clear();
          });
        },
        child: Mystyle().textHeader("ล้างหน้าจอ"),
      ),
    );
  }

  Widget addTank() {
    var w = MediaQuery.of(context).size.width * 0.07;
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        fixedSize: Size(w, 50.0),
        shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
        primary: Colors.cyan,
        elevation: 20,
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
      ),
      onPressed: () {
        if (tankId == "-" ||
            tankId.isEmpty ||
            tankCapacity == "-" ||
            tankCapacity.isEmpty ||
            tankProductCode == "-" ||
            tankProductCode == null) {
          normalDialog(context, "กรุณากรอกข้อมูลให้ครบ");
        } else {
          apiAddTank();
        }
      },
      child: Mystyle().textHeader("เพิ่มข้อมูล"),
    );
  }

  Widget updateTank() {
    var w = MediaQuery.of(context).size.width * 0.07;
    return Visibility(
      visible: _updateDataTank,
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
          apiUpdateTank(MyConstant().urlSettingTankUpdate,
              "คุณต้องการแก้ไขข้อมูลถังใช่หรือไม่");
        },
        child: Mystyle().textCustom("แก้ไขข้อมูล", 20.0, Colors.black),
      ),
    );
  }

  Widget deleteTank() {
    var w = MediaQuery.of(context).size.width * 0.07;
    return Visibility(
      visible: _updateDataTank,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          fixedSize: Size(w, 50.0),
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
          primary: Colors.pink.shade400,
          elevation: 20,
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 20),
        ),
        onPressed: () {
          apiUpdateTank(MyConstant().urlSettingTankDelete,
              "คุณต้องการลบข้อมูลถังใช่หรือไม่");
        },
        child: Mystyle().textCustom("ลบข้อมูล", 20.0, Colors.white),
      ),
    );
  }

  Widget cancelTank() {
    var w = MediaQuery.of(context).size.width * 0.07;
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
            _inserDataTank = true;
            _updateDataTank = false;
            tankId = "-";
            tankCapacity = "-";
            tankProductCode = null;

            _tankId.clear();
            _tankCapacity.clear();
            _tankProductCode.clear();
          });
        },
        child: Mystyle().textHeader("ล้างหน้าจอ"),
      ),
    );
  }
}
