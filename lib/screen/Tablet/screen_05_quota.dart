// ignore_for_file: avoid_print

import 'package:dio/dio.dart';
import 'package:fleetdemo/model/model_quota_car.dart';
// import 'package:fleetdemo/model/model_quota_order.dart';
import 'package:fleetdemo/model/model_quota_route.dart';
import 'package:fleetdemo/screen/Tablet/screen_05_01_add.dart';
import 'package:fleetdemo/utility/my_style.dart';
import 'package:fleetdemo/utility/myconstant.dart';
import 'package:flutter/material.dart';

class ScreenQuotaTablet extends StatefulWidget {
  const ScreenQuotaTablet({Key? key}) : super(key: key);

  @override
  _ScreenQuotaTabletState createState() => _ScreenQuotaTabletState();
}

class _ScreenQuotaTabletState extends State<ScreenQuotaTablet> {
  bool status = true;
  bool loadstatus = false;
  bool enableLite = true;
  bool enableBath = true;

  List<DropdownCar> dropdowncars = [];
  List<DropdownRoute> dropdownroutes = [];
  // List<ModelOrder> modelorders = [];
  String? selectedCarName;
  String? selectedRouteName;
  String? lite = "0", bath = "0", ref = "-";

  @override
  void initState() {
    super.initState();
    apiGetListOrder();
  }

  Future<void> apiGetListOrder() async {
    // if (modelorders.isNotEmpty) {
    //   modelorders.clear();
    // }
    await Dio().get(MyConstant().urlQuotaDetail).then((value) {
      setState(() {
        loadstatus = false;
      });
      if (value.toString() != 'null') {
        for (var map in value.data) {
          // ModelOrder modelOrder = ModelOrder.fromJson(map);
          setState(() {
            // modelorders.add(modelOrder);
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
    return loadstatus
        ? Mystyle().showprogress()
        : Stack(children: [
            // bodyTable(),
            addQuota(),
          ]);
  }

  // Widget bodyTable() {
  //   if (status == false) {
  //     return const Center(
  //       child: Text(
  //         'ยังไม่มีโควต้าที่ค้างอยู่',
  //         style: TextStyle(
  //             fontWeight: FontWeight.bold, fontSize: 20, fontFamily: 'Sarabun'),
  //       ),
  //     );
  //   } else {
  //     return SingleChildScrollView(
  //       child: Center(
  //         child: DataTable(
  //           columns: const <DataColumn>[
  //             DataColumn(
  //               label: Text(
  //                 'รายการที่',
  //                 style: TextStyle(
  //                   color: Colors.red,
  //                   fontSize: 15,
  //                   fontFamily: 'Sarabun',
  //                   fontWeight: FontWeight.bold,
  //                 ),
  //               ),
  //             ),
  //             DataColumn(
  //               label: Text(
  //                 'หมายเลขใบงาน',
  //                 style: TextStyle(
  //                   color: Colors.red,
  //                   fontSize: 15,
  //                   fontFamily: 'Sarabun',
  //                   fontWeight: FontWeight.bold,
  //                 ),
  //               ),
  //             ),
  //             DataColumn(
  //               label: Text(
  //                 'วันที่สร้างออเดอร์',
  //                 style: TextStyle(
  //                   color: Colors.red,
  //                   fontSize: 15,
  //                   fontFamily: 'Sarabun',
  //                   fontWeight: FontWeight.bold,
  //                 ),
  //               ),
  //             ),
  //             DataColumn(
  //               label: Text(
  //                 'ทะเบียนรถ',
  //                 style: TextStyle(
  //                   color: Colors.red,
  //                   fontSize: 15,
  //                   fontFamily: 'Sarabun',
  //                   fontWeight: FontWeight.bold,
  //                 ),
  //               ),
  //             ),
  //             DataColumn(
  //               label: Text(
  //                 'ลิมิต ลิตร',
  //                 style: TextStyle(
  //                   color: Colors.red,
  //                   fontSize: 15,
  //                   fontFamily: 'Sarabun',
  //                   fontWeight: FontWeight.bold,
  //                 ),
  //               ),
  //             ),
  //             DataColumn(
  //               label: Text(
  //                 'ลิมิตร บาท',
  //                 style: TextStyle(
  //                   color: Colors.red,
  //                   fontSize: 15,
  //                   fontFamily: 'Sarabun',
  //                   fontWeight: FontWeight.bold,
  //                 ),
  //               ),
  //             ),
  //             DataColumn(
  //               label: Text(
  //                 'สถานะของใบงาน',
  //                 style: TextStyle(
  //                   color: Colors.red,
  //                   fontSize: 15,
  //                   fontFamily: 'Sarabun',
  //                   fontWeight: FontWeight.bold,
  //                 ),
  //               ),
  //             ),
  //             DataColumn(
  //               label: Text(
  //                 'ปลายทาง',
  //                 style: TextStyle(
  //                   color: Colors.red,
  //                   fontSize: 15,
  //                   fontFamily: 'Sarabun',
  //                   fontWeight: FontWeight.bold,
  //                 ),
  //               ),
  //             ),
  //             DataColumn(
  //               label: Text(
  //                 'อ้างอิง',
  //                 style: TextStyle(
  //                   color: Colors.red,
  //                   fontSize: 15,
  //                   fontFamily: 'Sarabun',
  //                   fontWeight: FontWeight.bold,
  //                 ),
  //               ),
  //             ),
  //           ],
  //           rows: modelorders
  //               .map(
  //                 (modelOrder) => DataRow(
  //                   cells: [
  //                     DataCell(
  //                       SizedBox(
  //                         // width: MediaQuery.of(context).size.width * 0.2,
  //                         child: Text(
  //                           modelOrder.id.toString(),
  //                           style: TextStyle(
  //                             color: Colors.blue.shade400,
  //                             fontSize: 13,
  //                             fontFamily: 'Sarabun',
  //                             fontWeight: FontWeight.bold,
  //                           ),
  //                         ),
  //                       ),
  //                     ),
  //                     DataCell(
  //                       SizedBox(
  //                         // width: MediaQuery.of(context).size.width * 0.2,
  //                         child: Text(
  //                           modelOrder.recRef.toString(),
  //                           style: const TextStyle(
  //                             color: Colors.black,
  //                             fontSize: 13,
  //                             fontFamily: 'Sarabun',
  //                             fontWeight: FontWeight.bold,
  //                           ),
  //                         ),
  //                       ),
  //                     ),
  //                     DataCell(
  //                       SizedBox(
  //                         // width: MediaQuery.of(context).size.width * 0.2,
  //                         child: Text(
  //                           modelOrder.recCreate.toString(),
  //                           style: const TextStyle(
  //                             color: Colors.green,
  //                             fontSize: 13,
  //                             fontFamily: 'Sarabun',
  //                             fontWeight: FontWeight.bold,
  //                           ),
  //                         ),
  //                       ),
  //                     ),
  //                     DataCell(
  //                       SizedBox(
  //                         // width: MediaQuery.of(context).size.width * 0.2,
  //                         child: Text(
  //                           modelOrder.carRegistration.toString(),
  //                           style: const TextStyle(
  //                             color: Colors.green,
  //                             fontSize: 13,
  //                             fontFamily: 'Sarabun',
  //                             fontWeight: FontWeight.bold,
  //                           ),
  //                         ),
  //                       ),
  //                     ),
  //                     DataCell(
  //                       SizedBox(
  //                         // width: MediaQuery.of(context).size.width * 0.2,
  //                         child: Text(
  //                           modelOrder.limitLite.toString(),
  //                           style: const TextStyle(
  //                             color: Colors.green,
  //                             fontSize: 13,
  //                             fontFamily: 'Sarabun',
  //                             fontWeight: FontWeight.bold,
  //                           ),
  //                         ),
  //                       ),
  //                     ),
  //                     DataCell(
  //                       SizedBox(
  //                         // width: MediaQuery.of(context).size.width * 0.2,
  //                         child: Text(
  //                           modelOrder.limitBath.toString(),
  //                           style: const TextStyle(
  //                             color: Colors.green,
  //                             fontSize: 13,
  //                             fontFamily: 'Sarabun',
  //                             fontWeight: FontWeight.bold,
  //                           ),
  //                         ),
  //                       ),
  //                     ),
  //                     DataCell(
  //                       SizedBox(
  //                         // width: MediaQuery.of(context).size.width * 0.2,
  //                         child: Text(
  //                           modelOrder.recStatus.toString(),
  //                           style: const TextStyle(
  //                             color: Colors.green,
  //                             fontSize: 13,
  //                             fontFamily: 'Sarabun',
  //                             fontWeight: FontWeight.bold,
  //                           ),
  //                         ),
  //                       ),
  //                     ),
  //                     DataCell(
  //                       SizedBox(
  //                         // width: MediaQuery.of(context).size.width * 0.2,
  //                         child: Text(
  //                           modelOrder.desination.toString(),
  //                           style: const TextStyle(
  //                             color: Colors.green,
  //                             fontSize: 13,
  //                             fontFamily: 'Sarabun',
  //                             fontWeight: FontWeight.bold,
  //                           ),
  //                         ),
  //                       ),
  //                     ),
  //                     DataCell(
  //                       SizedBox(
  //                         // width: MediaQuery.of(context).size.width * 0.2,
  //                         child: Text(
  //                           modelOrder.ref1.toString(),
  //                           style: const TextStyle(
  //                             color: Colors.green,
  //                             fontSize: 13,
  //                             fontFamily: 'Sarabun',
  //                             fontWeight: FontWeight.bold,
  //                           ),
  //                         ),
  //                       ),
  //                     ),
  //                   ],
  //                 ),
  //               )
  //               .toList(),
  //         ),
  //       ),
  //     );
  //   }
  // }

  Widget addQuota() => Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Container(
                padding: const EdgeInsets.only(bottom: 10, right: 10),
                child: FloatingActionButton.extended(
                    heroTag: 'addjob',
                    onPressed: () {
                      MaterialPageRoute route = MaterialPageRoute(
                          builder: (context) =>
                              const ScreenQuotaTabletAddData());
                      Navigator.push(context, route)
                          .then((value) => apiGetListOrder());
                    },
                    icon: const Icon(Icons.add_circle),
                    label: Mystyle().textHeader("เพิ่มโควต้า")),
              ),
            ],
          ),
        ],
      );
}
