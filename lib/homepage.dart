import 'package:fleetdemo/screen/Mobile/screen_01_login.dart';
import 'package:fleetdemo/screen/Tablet/screen_01_login.dart';
import 'package:fleetdemo/screen/Web/screen_01_login.dart';
import 'package:flutter/material.dart';
import 'package:responsive_builder/responsive_builder.dart';

class HomeView extends StatelessWidget {
  const HomeView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ScreenTypeLayout(
      breakpoints:
          const ScreenBreakpoints(desktop: 800, tablet: 550, watch: 200),
      // const ScreenBreakpoints(desktop: 1240, tablet: 900, watch: 250),
      mobile: OrientationLayoutBuilder(
        portrait: (context) => const ScreenLoginMobile(),
        landscape: (context) => const ScreenLoginMobile(),
      ),
      tablet: const ScreenLoginTablet(),
      desktop: const ScreenLoginWeb(),
    );
  }
}
