import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:async';
import '../constants/nav_constants.dart';
import '../constants/str_constants.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  late bool flag;

  @override
  void initState() {
    super.initState();
    flag = false;

    Timer(
      const Duration(seconds: 4),
      () =>
          Navigator.of(context).pushReplacementNamed(NavConstants.cityListPage),
    );
  }

  Future<bool> _onWillPop() {
    if (flag == false) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text(StrConstants.pressAgain),
          action: SnackBarAction(
            label: StrConstants.ok,
            onPressed: () {
              // Code to execute.
            },
          ),
        ),
      );
      flag = true;
      return Future.value(false);
    }
    SystemChannels.platform.invokeMethod('SystemNavigator.pop');
    return Future.value(true);
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: _onWillPop,
      child: Container(
        color: Colors.orangeAccent,
        child: Image.asset(
          StrConstants.images[7],
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
        ),
      ),
    );
  }
}
