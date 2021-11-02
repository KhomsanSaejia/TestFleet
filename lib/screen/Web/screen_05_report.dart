// ignore_for_file: avoid_print

import 'package:dio/dio.dart';
import 'package:fleetdemo/model/model_report_all.dart';
import 'package:fleetdemo/utility/dialog.dart';
// import 'package:fleetdemo/utility/dialog.dart';
import 'package:fleetdemo/utility/my_style.dart';
import 'package:fleetdemo/utility/myconstant.dart';
import 'package:flutter/material.dart';
// import 'package:open_file/open_file.dart';
// import 'package:path_provider/path_provider.dart';
import 'package:syncfusion_flutter_xlsio/xlsio.dart';
import 'package:universal_html/html.dart' show AnchorElement;
import 'package:flutter/foundation.dart' show kIsWeb;
import 'dart:convert';
// import 'dart:io';

class ScreenReportWeb extends StatefulWidget {
  const ScreenReportWeb({Key? key}) : super(key: key);

  @override
  _ScreenReportWebState createState() => _ScreenReportWebState();
}

class _ScreenReportWebState extends State<ScreenReportWeb> {
  bool status = true;
  bool loadstatus = true;
  int count = 2;
  String? valFileName;
  final _valFileName = TextEditingController();

  List<ReportModel> reportmodels = [];
  List<Widget> gridViewReport = [];

  @override
  void initState() {
    super.initState();
    apiGetReportDetail();
  }

  Future<void> apiGetReportDetail() async {
    if (reportmodels.isNotEmpty) {
      reportmodels.clear();
    }
    await Dio().get(MyConstant().urlReportAll).then((value) {
      setState(() {
        loadstatus = false;
      });
      if (value.toString() != 'null') {
        // print(value.data);
        for (var map in value.data) {
          ReportModel reportModel = ReportModel.fromJson(map);

          setState(() {
            reportmodels.add(reportModel);
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: RefreshIndicator(
          child: loadstatus
              ? Mystyle().showprogress()
              : reportmodels.isEmpty
                  ? nodata()
                  : bodyTable(),
          onRefresh: apiGetReportDetail),
      floatingActionButton: FloatingActionButton(
          child: const Icon(Icons.file_download),
          onPressed: () {
            downloadExcel();
            // createExcel();
          }),
    );
  }

  // @override
  // Widget build(BuildContext context) {
  //   return Scaffold(
  //     body: RefreshIndicator(
  //         child: loadstatus
  //             ? Mystyle().showprogress()
  //             : reportmodels.isEmpty
  //                 ? nodata()
  //                 : SizedBox(
  //                     width: MediaQuery.of(context).size.width * 1,
  //                     child: GridView.extent(
  //                       maxCrossAxisExtent: 200,
  //                       children: gridViewReport,
  //                     ),
  //                   ),
  //         onRefresh: apiGetReportDetail),
  //     floatingActionButton: FloatingActionButton(
  //         child: const Icon(Icons.file_download), onPressed: () {}),
  //   );
  // }

  // Widget cardReport(ReportModel reportModel) {
  //   return Padding(
  //     padding: const EdgeInsets.all(5.0),
  //     child: InkWell(
  //       borderRadius: BorderRadius.circular(10),
  //       hoverColor: Colors.black,
  //       // highlightColor: Colors.black,
  //       onTap: () {
  // normalDialogReport(
  //     context,
  //     reportModel.recRef!,
  //     reportModel.recCreate!,
  //     reportModel.recFinish!,
  //     reportModel.empFullname!,
  //     reportModel.carRegistration!,
  //     reportModel.limitLite!,
  //     reportModel.limitBath!,
  //     reportModel.pumpAmount!,
  //     reportModel.pumpLite!,
  //     reportModel.pumpPrice!,
  //     reportModel.pumpId!,
  //     reportModel.newMileage!,
  //     reportModel.desination!);
  //       },
  //       child: Container(
  //         decoration: BoxDecoration(
  //           boxShadow: [
  //             BoxShadow(
  //               color: Colors.grey.withOpacity(0.5),
  //               spreadRadius: 5,
  //               blurRadius: 7,
  //               offset: const Offset(0, 3), // changes position of shadow
  //             ),
  //           ],
  //           borderRadius: BorderRadius.circular(10),
  //           color: reportModel.recStatus == "WAIT"
  //               // ? Colors.red.shade300
  //               ? const Color.fromRGBO(236, 112, 99, 0.5)
  //               : const Color.fromRGBO(88, 214, 141, 0.5),
  //         ),
  //         child: Padding(
  //           padding: const EdgeInsets.all(10.0),
  //           child: Column(
  //             mainAxisAlignment: MainAxisAlignment.spaceBetween,
  //             crossAxisAlignment: CrossAxisAlignment.start,
  //             children: [
  //               Mystyle().textCustom("รายการที่ ${reportModel.id}", 15.0,
  //                   const Color(0xFFFFFFFF)),
  //               Mystyle()
  //                   .textCustom("${reportModel.recRef}", 15.0, Colors.white),
  //               Row(
  //                 children: [
  //                   const Icon(Icons.people),
  //                   Mystyle().textCustom(
  //                       " : ${reportModel.empFullname} ", 15.0, Colors.white),
  //                 ],
  //               ),
  //               Row(
  //                 children: [
  //                   const Icon(Icons.drive_eta_rounded),
  //                   Mystyle().textCustom(" : ${reportModel.carRegistration}",
  //                       15.0, Colors.white),
  //                 ],
  //               ),
  //               Row(
  //                 children: [
  //                   const Icon(Icons.add_location),
  //                   Mystyle().textCustom(
  //                       " : ${reportModel.desination}", 15.0, Colors.white),
  //                 ],
  //               ),
  //             ],
  //           ),
  //         ),
  //       ),
  //     ),
  //   );
  // }

  Widget nodata() {
    return const Center(
      child: Text(
        'ยังไม่มีรายการเติม',
        style: TextStyle(
            fontWeight: FontWeight.bold, fontSize: 20, fontFamily: 'Sarabun'),
      ),
    );
  }

  Widget bodyTable() {
    if (status == false) {
      return const Center(
        child: Text(
          'ยังไม่มีรายการเติม',
          style: TextStyle(
              fontWeight: FontWeight.bold, fontSize: 20, fontFamily: 'Sarabun'),
        ),
      );
    } else {
      return SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Center(
            child: DataTable(
              showCheckboxColumn: false,
              showBottomBorder: true,
              columns: const <DataColumn>[
                // DataColumn(
                //   label: Text(
                //     'รายการที่',
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
                    'หมายเลขใบงาน',
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
                    'วันที่จบรายการ',
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
                    'พนักงานขับรถ',
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
                DataColumn(
                  label: Text(
                    'ลิมิต ลิตร',
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
                    'ลิมิต บาท',
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
                    'จำนวนบาท',
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
                    'จำนวนลิตร',
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
                    'ราคา',
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
                    'ตู้จ่าย',
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
                DataColumn(
                  label: Text(
                    'สถานะใบงาน',
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
                    'ปลายทาง',
                    style: TextStyle(
                      color: Colors.red,
                      fontSize: 15,
                      fontFamily: 'Sarabun',
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
              rows: reportmodels
                  .map(
                    (reportmodels) => DataRow(
                      onSelectChanged: (newValue) {
                        normalDialogReport(
                            context,
                            reportmodels.recRef!,
                            reportmodels.recCreate!,
                            reportmodels.recFinish!,
                            reportmodels.empFullname!,
                            reportmodels.carRegistration!,
                            reportmodels.limitLite!,
                            reportmodels.limitBath!,
                            reportmodels.pumpAmount!,
                            reportmodels.pumpLite!,
                            reportmodels.pumpPrice!,
                            reportmodels.pumpId!,
                            reportmodels.newMileage!,
                            reportmodels.desination!);
                      },
                      cells: [
                        // DataCell(
                        //   SizedBox(
                        //     // width: MediaQuery.of(context).size.width * 0.2,
                        //     child: Text(
                        //       reportmodels.id.toString(),
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
                              reportmodels.recRef.toString(),
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
                              reportmodels.recCreate.toString(),
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
                              reportmodels.recFinish.toString(),
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
                              reportmodels.empFullname.toString(),
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
                              reportmodels.carRegistration.toString(),
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
                              reportmodels.limitLite.toString(),
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
                              reportmodels.limitBath.toString(),
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
                              reportmodels.pumpAmount.toString(),
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
                              reportmodels.pumpLite.toString(),
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
                              reportmodels.pumpPrice.toString(),
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
                              reportmodels.pumpId.toString(),
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
                              reportmodels.newMileage.toString(),
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
                              reportmodels.recStatus.toString(),
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
                              reportmodels.desination.toString(),
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
      );
    }
  }

  Widget textBox() {
    return Container(
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
          controller: _valFileName,
          style: const TextStyle(
              fontFamily: "Sarabun", fontSize: 20, fontWeight: FontWeight.bold),
          onChanged: (value) {
            valFileName = value.trim();
          },
        ),
      ),
    );
  }

  Future<void> downloadExcel() async {
    showDialog(
      context: context,
      builder: (context) => SimpleDialog(
        title: Mystyle()
            .textCustom("คุณต้องการบันทึกเอกสารใช่หรือไม่", 20.0, Colors.red),
        children: [
          textBox(),
          TextButton.icon(
            onPressed: () {
              if (_valFileName.text.isEmpty) {
                normalDialog(context, "กรุณากรอกชื่อไฟล์");
              } else {
                createExcel();
                Navigator.pop(context);
                setState(() {
                  _valFileName.clear();
                });
              }
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
            label: Mystyle().textCustom("ยกเลิก", 20, Colors.black),
          ),
        ],
      ),
    );
  }

  Future<void> createExcel() async {
    final Workbook workbook = Workbook();

    final Worksheet sheet = workbook.worksheets[0];
    final Range range = sheet.getRangeByName('A1:O1');
    sheet.getRangeByName('A1').setText('รายการที่');
    sheet.getRangeByName('B1').setText('ใบงาน');
    sheet.getRangeByName('C1').setText('วันที่สร้าง');
    sheet.getRangeByName('D1').setText('วันที่เติมเสร็จ');
    sheet.getRangeByName('E1').setText('ชื่อพนักงาน');
    sheet.getRangeByName('F1').setText('ทะเบียนรถ');
    sheet.getRangeByName('G1').setText('ลิมิต ลิตร');
    sheet.getRangeByName('H1').setText('ลิมิต บาท');
    sheet.getRangeByName('I1').setText('จำนวนบาท');
    sheet.getRangeByName('J1').setText('จำนวนลิตร');
    sheet.getRangeByName('K1').setText('ราคา');
    sheet.getRangeByName('L1').setText('ตู้จ่าย');
    sheet.getRangeByName('M1').setText('เลขไมล์ล่าสุด');
    sheet.getRangeByName('N1').setText('สถานะใบงาน');
    sheet.getRangeByName('O1').setText('ปลายทาง');
    range.autoFitRows();
    range.autoFitColumns();
    // sheet.autoFitRow(1);
    // sheet.autoFitColumn(1);

    for (var item in reportmodels) {
      // final Range range1 = sheet.getRangeByName('A$count:O$count');
      sheet.getRangeByName('A$count').setText(item.id.toString());
      sheet.getRangeByName('B$count').setText(item.recRef);
      sheet.getRangeByName('C$count').setText(item.recCreate);
      sheet.getRangeByName('D$count').setText(item.recFinish);
      sheet.getRangeByName('E$count').setText(item.empFullname);
      sheet.getRangeByName('F$count').setText(item.carRegistration);
      sheet.getRangeByName('G$count').setText(item.limitLite);
      sheet.getRangeByName('H$count').setText(item.limitBath);
      sheet.getRangeByName('I$count').setText(item.pumpAmount);
      sheet.getRangeByName('J$count').setText(item.pumpLite);
      sheet.getRangeByName('K$count').setText(item.pumpPrice);
      sheet.getRangeByName('L$count').setText(item.pumpId);
      sheet.getRangeByName('M$count').setText(item.newMileage);
      sheet.getRangeByName('N$count').setText(item.recStatus);
      sheet.getRangeByName('O$count').setText(item.desination);
      // range1.autoFitColumns();
      setState(() {
        count = count + 1;
      });
    }

    final List<int> bytes = workbook.saveAsStream();
    workbook.dispose();
    if (kIsWeb) {
      AnchorElement(
          href:
              'data:application/octet-stream;charset=utf-16le;base64,${base64.encode(bytes)}')
        ..setAttribute('download', 'REPORT-${_valFileName.text}.xlsx')
        ..click();
    } else {
      // final String path = (await getApplicationSupportDirectory()).path;
      // final String fileName =
      //     Platform.isWindows ? '$path\\เอกสาร.xlsx' : '$path/เอกสาร.xlsx';
      // final File file = File(fileName);
      // await file.writeAsBytes(bytes, flush: true);
      // OpenFile.open(fileName);
    }
  }
}
