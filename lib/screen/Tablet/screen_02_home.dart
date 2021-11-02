import 'package:fleetdemo/screen/Tablet/screen_01_login.dart';
import 'package:fleetdemo/screen/Tablet/screen_03_setting.dart';
import 'package:fleetdemo/screen/Tablet/screen_04_car.dart';
import 'package:fleetdemo/screen/Tablet/screen_05_quota.dart';
import 'package:fleetdemo/screen/Tablet/screen_06_report.dart';
import 'package:fleetdemo/screen/Tablet/screen_07_buckettemple.dart';
import 'package:fleetdemo/screen/Tablet/screen_08_takedown.dart';
import 'package:fleetdemo/utility/my_style.dart';
import 'package:flutter/material.dart';

class ScreenHomeTablet extends StatefulWidget {
  const ScreenHomeTablet({Key? key}) : super(key: key);

  @override
  _ScreenHomeTabletState createState() => _ScreenHomeTabletState();
}

class _ScreenHomeTabletState extends State<ScreenHomeTablet> {
  int selectedIndex = 0;
  Widget currentWidget = const ScreenSettingTablet();

  String? nameAppbar;

  @override
  void initState() {
    super.initState();
    nameAppbar = "ตั้งค่า";
  }

  void onItemTapped(int index) {
    setState(() {
      selectedIndex = index;
      if (selectedIndex == 0) {
        nameAppbar = "ตั้งค่า";
        currentWidget = const ScreenSettingTablet();
      }
      if (selectedIndex == 1) {
        nameAppbar = "รถ";
        currentWidget = const ScreenCarTablet();
      }
      if (selectedIndex == 2) {
        nameAppbar = "โควต้า";
        currentWidget = const ScreenQuotaTablet();
      }
      if (selectedIndex == 3) {
        nameAppbar = "รายงาน";
        currentWidget = const ScreenReportTablet();
      }
      if (selectedIndex == 4) {
        nameAppbar = "วัดถัง";
        currentWidget = const ScreenBucketTablet();
      }
      if (selectedIndex == 5) {
        nameAppbar = "ลงรับ";
        currentWidget = const ScreenTakeDownTablet();
      }

      // ignore: avoid_print
      print("selectedIndex = $selectedIndex , index = $index");
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(
              onPressed: () =>
                  signoutprocess(context, 'คุณต้องการออกจากระบบ', 'ใช่', 'ไม่'),
              icon: const Icon(Icons.exit_to_app))
        ],
        title: Mystyle().textHeader(nameAppbar!),
        centerTitle: true,
      ),
      body: currentWidget,
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.settings),
            label: 'ตั้งค่า',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.car_rental),
            label: 'รถ',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.queue_rounded),
            label: 'โควต้า',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.sticky_note_2_outlined),
            label: 'รายงาน',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.add_chart_outlined),
            label: 'วัดถัง',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.add_rounded),
            label: 'ลงรับ',
          ),
        ],
        currentIndex: selectedIndex,
        selectedItemColor: Colors.red,
        // selectedItemColor: Theme.of(context).primaryColor,
        unselectedItemColor: Colors.grey,
        onTap: onItemTapped,
      ),
    );
  }

  Future<void> signoutprocess(BuildContext context, String header,
      String confirm, String cancel) async {
    showDialog(
      context: context,
      builder: (context) => SimpleDialog(
        title: Mystyle().textHeader(header),
        children: <Widget>[
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: <Widget>[
              ElevatedButton(
                onPressed: () async {
                  MaterialPageRoute route = MaterialPageRoute(
                    builder: (context) => const ScreenLoginTablet(),
                  );
                  Navigator.pushAndRemoveUntil(
                      context, route, (route) => false);
                },
                child: Text(confirm),
              ),
              ElevatedButton(
                onPressed: () => Navigator.pop(context),
                child: Text(cancel),
              ),
            ],
          )
        ],
      ),
    );
  }
}
