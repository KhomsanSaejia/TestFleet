// import 'package:fleetdemo/model/model_quota_order.dart';
import 'package:fleetdemo/utility/my_style.dart';
import 'package:flutter/material.dart';

Future<void> normalDialog(BuildContext context, String message) async {
  showDialog(
    context: context,
    builder: (context) => SimpleDialog(
      title: Center(
        child: Text(
          message,
          style: const TextStyle(
              fontSize: 18, fontWeight: FontWeight.bold, fontFamily: "Sarabun"),
        ),
      ),
      children: <Widget>[
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text(
                'OK',
                style: TextStyle(fontSize: 15, color: Colors.red),
              ),
            ),
          ],
        )
      ],
    ),
  );
}

Future<void> normalDialogReport(
  BuildContext context,
  String message,
  String dateCreate,
  String dateFinish,
  String driver,
  String car,
  String limitlite,
  String limitbath,
  String pumpAmount,
  String pumpLite,
  String pumpPrice,
  String pumpId,
  String newMileage,
  String desination,
) async {
  showDialog(
    context: context,
    builder: (context) => SimpleDialog(
      title: Center(
        child: Text(
          "ใบงานเลขที่ : " + message,
          style: const TextStyle(
              color: Colors.green,
              fontSize: 18,
              fontWeight: FontWeight.bold,
              fontFamily: "Sarabun"),
        ),
      ),
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.all(5.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              rowBody("วันที่สร้างรายการ ", dateCreate),
              rowBody("วันที่จบรายการ ", dateFinish),
              rowBody("พนักงานขับรถ ", driver + " "),
              rowBody("ทะเบียนรถ ", car),
              rowBody("ลิมิต จำนวนลิตร ", limitlite),
              rowBody("ลิมิต จำนวนบาท ", limitbath),
              rowBody("จำนวนเงิน ", pumpAmount),
              rowBody("จำนวนลิตร ", pumpLite),
              rowBody("ราคา/ลิตร ", pumpPrice),
              rowBody("ตู้จ่าย ", pumpId),
              rowBody("เลขไมล์ปัจจุบัน ", newMileage),
              rowBody("ปลายทาง ", desination),
            ],
          ),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text(
                'OK',
                style: TextStyle(fontSize: 15, color: Colors.red),
              ),
            ),
          ],
        )
      ],
    ),
  );
}

Widget rowBody(String label, String data) {
  return Row(
    // mainAxisAlignment: MainAxisAlignment.spaceAround,
    children: [
      SizedBox(width: 135, child: Mystyle().textCustom(label, 18, Colors.red)),
      const SizedBox(
        height: 40,
      ),
      Mystyle().textCustom(": ", 18, Colors.black),
      const SizedBox(
        height: 40,
      ),
      Mystyle().textCustom(data, 18, Colors.blue),
      const SizedBox(
        height: 40,
      ),
    ],
  );
}

