import 'dart:async';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sap/provider/ship.dart';
import 'helper/screen_navigation.dart';
import 'provider/user.dart';
import 'screen/home.dart';

class SplashPage extends StatefulWidget {
  @override
  _SplashPageState createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  @override
  void initState() {
    Timer(
      Duration(seconds: 3),
      () => pushAndRemoveUntil(
        context,
        HomeScreen(),
      ),
    );

    super.initState();
  }

  Widget build(BuildContext context) {
    final user = Provider.of<UserProvider>(context);
    final ship = Provider.of<ShipProvider>(context);

    load() async {
      await user.reloadUserModel();
      await ship.getSealine();
      await ship.getPortsInfo();
    }

    load();
    return SafeArea(
      child: Scaffold(
        body: Container(
          child: GestureDetector(
            onTap: () {
              FocusScope.of(context).requestFocus(
                new FocusNode(),
              );
            },
            child: Center(
              child: Container(
                width: MediaQuery.of(context).size.width / 2,
                child: Image.asset('assets/ic_logo.png'),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
