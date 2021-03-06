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
import 'package:syncfusion_flutter_xlsio/xlsio.dart' as excel;
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
  //               Mystyle().textCustom("??????????????????????????? ${reportModel.id}", 15.0,
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
        '??????????????????????????????????????????????????????',
        style: TextStyle(
            fontWeight: FontWeight.bold, fontSize: 20, fontFamily: 'Sarabun'),
      ),
    );
  }

  Widget bodyTable() {
    if (status == false) {
      return const Center(
        child: Text(
          '??????????????????????????????????????????????????????',
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
                //     '???????????????????????????',
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
                    '????????????????????????????????????',
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
                    '???????????????????????????????????????????????????',
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
                    '??????????????????????????????????????????',
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
                    '????????????????????????????????????',
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
                    '???????????????????????????',
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
                    '??????????????? ????????????',
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
                    '??????????????? ?????????',
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
                    '????????????????????????',
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
                    '???????????????????????????',
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
                    '????????????',
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
                    '?????????????????????',
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
                    '???????????????????????????????????????',
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
                    '??????????????????????????????',
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
                    '?????????????????????',
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
            .textCustom("????????????????????????????????????????????????????????????????????????????????????????????????", 20.0, Colors.red),
        children: [
          textBox(),
          TextButton.icon(
            onPressed: () {
              if (_valFileName.text.isEmpty) {
                normalDialog(context, "???????????????????????????????????????????????????");
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
            label: Mystyle().textCustom("????????????", 20, Colors.black),
          ),
          TextButton.icon(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: const Icon(
              Icons.clear,
              color: Colors.red,
            ),
            label: Mystyle().textCustom("??????????????????", 20, Colors.black),
          ),
        ],
      ),
    );
  }

  Future<void> createExcel() async {
    final excel.Workbook workbook = excel.Workbook();

    final excel.Worksheet sheet = workbook.worksheets[0];

    // sheet.getRangeByName('A1').setText('???????????????????????????');
    // sheet.getRangeByName('B1').setText('???????????????');
    // sheet.getRangeByName('C1').setText('?????????????????????????????????');
    // sheet.getRangeByName('D1').setText('?????????????????????????????????????????????');
    // sheet.getRangeByName('E1').setText('?????????????????????????????????');
    // sheet.getRangeByName('F1').setText('???????????????????????????');
    // sheet.getRangeByName('G1').setText('??????????????? ????????????');
    // sheet.getRangeByName('H1').setText('??????????????? ?????????');
    // sheet.getRangeByName('I1').setText('????????????????????????');
    // sheet.getRangeByName('J1').setText('???????????????????????????');
    // sheet.getRangeByName('K1').setText('????????????');
    // sheet.getRangeByName('L1').setText('?????????????????????');
    // sheet.getRangeByName('M1').setText('???????????????????????????????????????');
    // sheet.getRangeByName('N1').setText('??????????????????????????????');
    // sheet.getRangeByName('O1').setText('?????????????????????');

    sheet.getRangeByName('A1').setText('No');
    sheet.getRangeByName('B1').setText('Invoice');
    sheet.getRangeByName('C1').setText('Date Create');
    sheet.getRangeByName('D1').setText('Date Finish');
    sheet.getRangeByName('E1').setText('Emp Name');
    sheet.getRangeByName('F1').setText('Car Regist');
    sheet.getRangeByName('G1').setText('Limit Volumn');
    sheet.getRangeByName('H1').setText('Limit Amount');
    sheet.getRangeByName('I1').setText('Amount');
    sheet.getRangeByName('J1').setText('Volumn');
    sheet.getRangeByName('K1').setText('Price');
    sheet.getRangeByName('L1').setText('Pump ID');
    sheet.getRangeByName('M1').setText('Last Milage');
    sheet.getRangeByName('N1').setText('Status');
    sheet.getRangeByName('O1').setText('Destination');

    for (var item in reportmodels) {
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
      setState(() {
        count = count + 1;
      });
    }
    sheet.autoFitColumn(1);
    sheet.autoFitColumn(2);
    sheet.autoFitColumn(3);
    sheet.autoFitColumn(4);
    sheet.autoFitColumn(5);
    sheet.autoFitColumn(6);
    sheet.autoFitColumn(7);
    sheet.autoFitColumn(8);
    sheet.autoFitColumn(9);
    sheet.autoFitColumn(10);
    sheet.autoFitColumn(11);
    sheet.autoFitColumn(12);
    sheet.autoFitColumn(13);
    sheet.autoFitColumn(14);
    sheet.autoFitColumn(15);

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
      //     Platform.isWindows ? '$path\\??????????????????.xlsx' : '$path/??????????????????.xlsx';
      // final File file = File(fileName);
      // await file.writeAsBytes(bytes, flush: true);
      // OpenFile.open(fileName);
    }
  }
}
