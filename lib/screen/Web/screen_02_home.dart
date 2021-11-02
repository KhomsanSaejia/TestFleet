import 'package:fleetdemo/screen/Web/screen_01_login.dart';
import 'package:fleetdemo/screen/Web/screen_03_setting.dart';
import 'package:fleetdemo/screen/Web/screen_04_quota.dart';
import 'package:fleetdemo/screen/Web/screen_05_report.dart';
import 'package:fleetdemo/screen/Web/screen_06_buckettemple.dart';
import 'package:fleetdemo/screen/Web/screen_07_takedown.dart';
import 'package:fleetdemo/utility/my_style.dart';
import 'package:flutter/material.dart';

class ScreenHomeWeb extends StatefulWidget {
  const ScreenHomeWeb({Key? key}) : super(key: key);

  @override
  _ScreenHomeWebState createState() => _ScreenHomeWebState();
}

class _ScreenHomeWebState extends State<ScreenHomeWeb> {
  int selectedIndex = 0;
  Widget currentWidget = const ScreenSettingWeb();

  String? nameAppbar;

  @override
  void initState() {
    super.initState();
    nameAppbar = "Web ตั้งค่า";
  }

  void onItemTapped(int index) {
    setState(() {
      selectedIndex = index;
      if (selectedIndex == 0) {
        nameAppbar = "Web ตั้งค่า";
        currentWidget = const ScreenSettingWeb();
      }
      if (selectedIndex == 1) {
        nameAppbar = "Web โควต้า";
        currentWidget = const ScreenQuotaWeb();
      }
      if (selectedIndex == 2) {
        nameAppbar = "Web รายงาน";
        currentWidget = const ScreenReportWeb();
      }
      if (selectedIndex == 3) {
        nameAppbar = "Web ลงรับ";
        currentWidget = const ScreenTakeDownWeb();
      }
      if (selectedIndex == 4) {
        nameAppbar = "Web วัดถัง";
        currentWidget = const ScreenBucketWeb();
      }
      if (selectedIndex == 5) {
        nameAppbar = "Web ทดสอบ";
        // currentWidget = const ScreenBucketWeb();
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
            icon: Icon(Icons.queue_rounded),
            label: 'โควต้า',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.sticky_note_2_outlined),
            label: 'รายงาน',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.add_chart_outlined),
            label: 'ลงรับ',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.add_rounded),
            label: 'วัดถัง',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.access_alarms),
            label: 'ทดสอบ',
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
                    builder: (context) => const ScreenLoginWeb(),
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
