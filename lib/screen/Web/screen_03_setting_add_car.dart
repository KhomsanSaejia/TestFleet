import 'package:dio/dio.dart';
import 'package:fleetdemo/model/model_car.dart';
import 'package:fleetdemo/model/model_company.dart';
import 'package:fleetdemo/model/model_product.dart';
import 'package:fleetdemo/utility/dialog.dart';
import 'package:fleetdemo/utility/my_style.dart';
import 'package:fleetdemo/utility/myconstant.dart';
import 'package:flutter/material.dart';

class ScreenSettingAddCarWeb extends StatefulWidget {
  const ScreenSettingAddCarWeb({Key? key}) : super(key: key);

  @override
  _ScreenSettingAddCarWebState createState() => _ScreenSettingAddCarWebState();
}

class _ScreenSettingAddCarWebState extends State<ScreenSettingAddCarWeb> {
  bool status = true;
  bool loadstatus = true;

  bool _inserDataCar = true;
  bool _updateDataCar = false;

  String carRegistration = "-", carMilage = "-";
  String? selectedCustId;
  String? selectedProductId;

  final _carRegistration = TextEditingController();
  final _carMilage = TextEditingController();
  final _id = TextEditingController();

  List<ProductModel> productModels = [];
  List<CarDetailModel> carDetailModels = [];
  List<CompanyModel> companyModels = [];

  @override
  void initState() {
    super.initState();
    apiGetListOil();
    apiGetListCompany();
    apiGetListCar();
  }

  Future<void> apiGetListOil() async {
    if (productModels.isNotEmpty) {
      productModels.clear();
    }
    await Dio().get(MyConstant().urlSettingProdList).then((value) {
      if (value.toString() != 'null') {
        for (var map in value.data) {
          ProductModel productModel = ProductModel.fromJson(map);
          setState(() {
            productModels.add(productModel);
          });
        }
      } else {}
    });
  }

  Future<void> apiGetListCompany() async {
    if (companyModels.isNotEmpty) {
      companyModels.clear();
    }
    await Dio().get(MyConstant().urlSettingCarCompany).then((value) {
      if (value.toString() != 'null') {
        for (var map in value.data) {
          CompanyModel companyModel = CompanyModel.fromJson(map);
          setState(() {
            companyModels.add(companyModel);
          });
        }
      } else {}
    });
  }

  Future<void> apiGetListCar() async {
    if (carDetailModels.isNotEmpty) {
      carDetailModels.clear();
    }
    await Dio().get(MyConstant().urlSettingCarDetail).then((value) {
      setState(() {
        loadstatus = false;
      });
      if (value.toString() != 'null') {
        for (var map in value.data) {
          CarDetailModel carDetailModel = CarDetailModel.fromJson(map);
          setState(() {
            carDetailModels.add(carDetailModel);
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

  // Future<void> apiPOSTcarNew() async {
  //   try {
  //     Response response =
  //         await Dio().post(MyConstant().urlSettingCarAdd, data: {
  //       "car_registration": carRegistration,
  //       "cust_id": selectedCustId,
  //       "pump_product": selectedProductId,
  //       "last_mileage": carMilage,
  //     });
  //     // ignore: avoid_print
  //     print('response = $response');
  //     if (response.toString() == 'SUCCESS') {
  //       setState(() {
  //         _carRegistration.clear();
  //         _carMilage.clear();
  //         selectedCustId = null;
  //         selectedProductId = null;

  //         apiGetListCar();
  //       });
  //     } else {
  //       normalDialog(context, 'ไม่สามารถเพิ่มข้อมูลรถได้ กรุณาลองใหม่อีกครั้ง');
  //     }
  //   } catch (e) {
  //     normalDialog(context, e.toString());
  //   }
  // }
  Future<void> apiPOSTcarNew() async {
    showDialog(
      context: context,
      builder: (context) => SimpleDialog(
        title: Mystyle()
            .textCustom("คุณต้องการเพิ่มข้อมูลรถใช่หรือไม่", 20.0, Colors.red),
        children: <Widget>[
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: <Widget>[
              TextButton.icon(
                onPressed: () async {
                  await Dio().post(MyConstant().urlSettingCarAdd, data: {
                    "car_registration": carRegistration,
                    "cust_id": selectedCustId,
                    "pump_product": selectedProductId,
                    "last_mileage": carMilage,
                  }).then(
                    (value) {
                      if (value.toString() == 'SUCCESS') {
                        Navigator.pop(context);
                        setState(() {
                          _inserDataCar = true;
                          _updateDataCar = false;
                          carRegistration = "-";
                          carMilage = "-";
                          selectedCustId = null;
                          selectedProductId = null;
                          _id.clear();
                          _carRegistration.clear();
                          _carMilage.clear();
                          apiGetListCompany();
                          apiGetListOil();
                          apiGetListCar();
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
                    _inserDataCar = true;
                    _updateDataCar = false;
                    carRegistration = "-";
                    carMilage = "-";
                    selectedCustId = null;
                    selectedProductId = null;
                    _id.clear();
                    _carRegistration.clear();
                    _carMilage.clear();
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

  Future<void> apiUpdateCar(String url, String header) async {
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
                    "car_registration": carRegistration,
                    "cust_id": selectedCustId,
                    "pump_product": selectedProductId,
                    "last_mileage": carMilage,
                  }).then(
                    (value) {
                      if (value.toString() == 'SUCCESS') {
                        Navigator.pop(context);
                        setState(() {
                          _inserDataCar = true;
                          _updateDataCar = false;
                          carRegistration = "-";
                          carMilage = "-";
                          selectedCustId = null;
                          selectedProductId = null;
                          _id.clear();
                          _carRegistration.clear();
                          _carMilage.clear();
                          apiGetListCompany();
                          apiGetListOil();
                          apiGetListCar();
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
                    _inserDataCar = true;
                    _updateDataCar = false;
                    carRegistration = "-";
                    carMilage = "-";
                    selectedCustId = null;
                    selectedProductId = null;
                    _id.clear();
                    _carRegistration.clear();
                    _carMilage.clear();
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
        title: Mystyle().textHeader("เพิ่มข้อมูลรถ"),
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
                        _inserDataCar ? insertCarButton() : updateCarButton(),
                        // Row(
                        //   mainAxisAlignment: MainAxisAlignment.spaceAround,
                        //   children: [
                        //     ok(),
                        //     cancel(),
                        //   ],
                        // )
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
          'ยังไม่มีประวัติรถ',
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
                      'ทะเบียนรถ',
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
                      'รหัสบริษัท',
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
                      'ชื่อย่อ',
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
                      'เลขไมล์ล่าสุด',
                      style: TextStyle(
                        color: Colors.red,
                        fontSize: 15,
                        fontFamily: 'Sarabun',
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
                rows: carDetailModels
                    .map(
                      (carDetailModel) => DataRow(
                        onSelectChanged: (newValue) {
                          setState(() {
                            
                          });
                        },
                        cells: [
                          // DataCell(
                          //   SizedBox(
                          //     // width: MediaQuery.of(context).size.width * 0.2,
                          //     child: Text(
                          //       carDetailModel.carId.toString(),
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
                                carDetailModel.carRegistration.toString(),
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
                                carDetailModel.comId.toString(),
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
                                carDetailModel.comName.toString(),
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
                                carDetailModel.comReference.toString(),
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
                                carDetailModel.productId.toString(),
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
                                carDetailModel.productName.toString(),
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
                                carDetailModel.productDetail.toString(),
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
                                carDetailModel.lastMileage.toString(),
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

  Widget insertCarButton() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          ok(),
          Mystyle().mySizeBox(10.0, 10.0),
          cancel(),
        ],
      ),
    );
  }

  Widget updateCarButton() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
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
              Mystyle().mySizeBox(10.0, 10.0),
              cancel(),
            ],
          ),
        ],
      ),
    );
  }

  Widget bodyMenu() {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          
          children: [
            Mystyle().textHeader("ทะเบียนรถ"),
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
                  controller: _carRegistration,
                  style: const TextStyle(
                      fontFamily: "Sarabun",
                      fontSize: 20,
                      fontWeight: FontWeight.bold),
                  onChanged: (value) {
                    carRegistration = value.trim();
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
            Mystyle().textHeader("ลูกค้า"),
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
                    value: selectedCustId,
                    isDense: true,
                    onChanged: (String? newValue) {
                      setState(() {
                        selectedCustId = newValue!;
                      });
                    },
                    items: companyModels.map((CompanyModel map) {
                      return DropdownMenuItem<String>(
                        value: map.comId.toString(),
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
        Mystyle().mySizeBox(20.0, 20.0),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Mystyle().textHeader("ชนิดน้ำมัน"),
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
                    hint: Mystyle().textHeader("ระบุชนิดน้ำมัน"),
                    value: selectedProductId,
                    isDense: true,
                    onChanged: (String? newValue) {
                      setState(() {
                        selectedProductId = newValue!;
                      });
                    },
                    items: productModels.map((ProductModel map) {
                      return DropdownMenuItem<String>(
                        value: map.productId.toString(),
                        child: Mystyle().textHeader(map.productName!),
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
            Mystyle().textHeader("เลขไมล์ตั้งต้น"),
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
                  controller: _carMilage,
                  style: const TextStyle(
                      fontFamily: "Sarabun",
                      fontSize: 20,
                      fontWeight: FontWeight.bold),
                  onChanged: (value) => carMilage = value.trim(),
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
      visible: _updateDataCar,
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
          apiUpdateCar(MyConstant().urlSettingCarUpdate,
              "คุณต้องการอัพเดทข้อมูลรถใช่หรือไม่");
        },
        child: Mystyle().textCustom("แก้ไขข้อมูล", 20.0, Colors.black),
      ),
    );
  }

  Widget delete() {
    var w = MediaQuery.of(context).size.width * 0.1;
    return Visibility(
      visible: _updateDataCar,
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
          apiUpdateCar(MyConstant().urlSettingCarDelete,
              "คุณต้องการลบข้อมูลรถใช่หรือไม่");
        },
        child: Mystyle().textCustom("ลบข้อมูล", 20.0, Colors.white),
      ),
    );
  }

  Widget ok() {
    var w = MediaQuery.of(context).size.width * 0.1;
    return Visibility(
      visible: _inserDataCar,
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
          if (carRegistration == "-" ||
              carRegistration.isEmpty ||
              carMilage == "-" ||
              carMilage.isEmpty ||
              selectedCustId == null ||
              selectedProductId == null) {
            normalDialog(context, "กรุณากรอกข้อมูลให้ครบ");
          } else {
            apiPOSTcarNew();
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
          _inserDataCar = true;
          _updateDataCar = false;
          carRegistration = "-";
          carMilage = "-";
          selectedCustId = null;
          selectedProductId = null;
          _carRegistration.clear();
          _carMilage.clear();
        });
      },
      child: Mystyle().textHeader("ยกเลิก"),
    );
  }
  
}
