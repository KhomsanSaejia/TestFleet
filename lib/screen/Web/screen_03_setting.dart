import 'package:flutter/material.dart';

import 'screen_03_setting_add_car.dart';
import 'screen_03_setting_add_customer.dart';
import 'screen_03_setting_add_destination.dart';
import 'screen_03_setting_add_driver.dart';
import 'screen_03_setting_add_pump.dart';

class ScreenSettingWeb extends StatefulWidget {
  const ScreenSettingWeb({Key? key}) : super(key: key);

  @override
  _ScreenSettingWebState createState() => _ScreenSettingWebState();
}

class _ScreenSettingWebState extends State<ScreenSettingWeb> {
  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.grey.shade200,
      width: MediaQuery.of(context).size.width * 1,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          menuCompany(),
          menuAddDriver(),
          menuCar(),
          menuPump(),
          menuDestination(),
        ],
      ),
    );
  }

  Widget menuAddDriver() => Container(
        alignment: Alignment.center,
        child: Card(
          color: Colors.amber,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          elevation: 20,
          child: InkWell(
            borderRadius: BorderRadius.circular(20.0),
            splashColor: Colors.blue.withAlpha(30),
            onTap: () {
              MaterialPageRoute route = MaterialPageRoute(
                  builder: (context) => const ScreenSettingAddDriverWeb());
              Navigator.push(context, route).then((value) {});
            },
            child: Container(
              alignment: Alignment.center,
              height: 60,
              width: MediaQuery.of(context).size.width * 0.1,
              child: const Text(
                'เพิ่มคนขับ',
                style: TextStyle(
                  color: Colors.indigo,
                  fontFamily: 'Sarabun',
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ),
      );
  Widget menuCompany() => Container(
        alignment: Alignment.center,
        child: Card(
          color: Colors.amber,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          elevation: 20,
          child: InkWell(
            borderRadius: BorderRadius.circular(20.0),
            splashColor: Colors.blue.withAlpha(30),
            onTap: () {
              MaterialPageRoute route = MaterialPageRoute(
                  builder: (context) => const ScreenSettingAddCustomerWeb());
              Navigator.push(context, route).then((value) {});
            },
            child: Container(
              alignment: Alignment.center,
              height: 60,
              width: MediaQuery.of(context).size.width * 0.1,
              child: const Text(
                'เพิ่มบริษัท',
                style: TextStyle(
                  color: Colors.indigo,
                  fontFamily: 'Sarabun',
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ),
      );
  Widget menuCar() => Container(
        alignment: Alignment.center,
        child: Card(
          color: Colors.amber,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          elevation: 20,
          child: InkWell(
            borderRadius: BorderRadius.circular(20.0),
            splashColor: Colors.blue.withAlpha(30),
            onTap: () {
              MaterialPageRoute route = MaterialPageRoute(
                  builder: (context) => const ScreenSettingAddCarWeb());
              Navigator.push(context, route).then((value) {});
            },
            child: Container(
              alignment: Alignment.center,
              height: 60,
              width: MediaQuery.of(context).size.width * 0.1,
              child: const Text(
                'เพิ่มรถ',
                style: TextStyle(
                  color: Colors.indigo,
                  fontFamily: 'Sarabun',
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ),
      );
  Widget menuPump() => Container(
        alignment: Alignment.center,
        child: Card(
          color: Colors.amber,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          elevation: 20,
          child: InkWell(
            borderRadius: BorderRadius.circular(20.0),
            splashColor: Colors.blue.withAlpha(30),
            onTap: () {
              MaterialPageRoute route = MaterialPageRoute(
                  builder: (context) => const ScreenSettingAddPumpProductWeb());
              Navigator.push(context, route).then((value) {});
            },
            child: Container(
              alignment: Alignment.center,
              height: 60,
              width: MediaQuery.of(context).size.width * 0.1,
              child: const Text(
                'ตั้งค่าตู้จ่าย',
                style: TextStyle(
                  color: Colors.indigo,
                  fontFamily: 'Sarabun',
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ),
      );
  Widget menuDestination() => AbsorbPointer(
        absorbing: false,
        child: Container(
          alignment: Alignment.center,
          child: Card(
            color: Colors.amber,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),
            elevation: 20,
            child: InkWell(
              borderRadius: BorderRadius.circular(20.0),
              splashColor: Colors.blue.withAlpha(30),
              onTap: () {
                MaterialPageRoute route = MaterialPageRoute(
                    builder: (context) =>
                        const ScreenSettingAddDestinationWeb());
                Navigator.push(context, route).then((value) {});
              },
              child: Container(
                alignment: Alignment.center,
                height: 60,
                width: MediaQuery.of(context).size.width * 0.1,
                child: const Text(
                  'เพิ่มเส้นทาง',
                  style: TextStyle(
                    color: Colors.indigo,
                    fontFamily: 'Sarabun',
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ),
        ),
      );
}
