import 'dart:async';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../helper/screen_navigation.dart';
import '../helper/shared_preferences_service.dart';
import '../provider/user.dart';
import 'home.dart';
import 'login.dart';

class SplashView extends StatefulWidget {
  @override
  SplashViewState createState() => SplashViewState();
}

class SplashViewState extends State<SplashView>
    with SingleTickerProviderStateMixin {
  final PrefService _prefService = PrefService();

  AnimationController? _controller;
  Animation<double>? _anmation;
  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 2000),
    )..repeat();

    _anmation = CurvedAnimation(parent: _controller!, curve: Curves.ease);
  }

  @override
  void dispose() {
    _controller!.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<UserProvider>(context);

    load() async {
      _prefService.readCache("password").then((value) async {
        if (value != null) {
          await user.reloadUser(value);
          Timer(
            Duration(milliseconds: 3500),
            () => pushAndRemoveUntil(
              context,
              HomeScreen(),
            ),
          );
        } else {
          Timer(
            Duration(milliseconds: 3500),
            () => pushAndRemoveUntil(
              context,
              LoginScreen(),
            ),
          );
        }
      });
    }

    load();
    return SafeArea(
      child: Scaffold(
        body: Container(
          child: Center(
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Card(
                    shadowColor: Colors.black,
                    color: Colors.amberAccent[700],
                    elevation: 10,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(100),
                    ),
                    child: Padding(
                      padding: EdgeInsets.all(30.0),
                      child: Image.asset(
                        'assets/logo.png',
                        width: 200,
                        height: 200,
                      ),
                    ),
                  ),
                ),
                RotationTransition(
                  turns: _anmation!,
                  child: Center(
                    child: Padding(
                      padding: const EdgeInsets.all(30.0),
                      child: Container(
                        height: 200,
                        width: 200,
                        child: Image.asset(
                          'assets/1234.png',
                          height: 250,
                          width: 250,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
