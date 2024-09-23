import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../helper/screen_navigation.dart';
import '../helper/shared_preferences_service.dart';
import '../provider/action.dart';
import '../provider/user.dart';
import 'home.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  bool ob = true;
  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<UserProvider>(context);
    final action = Provider.of<ActionProvider>(context);
    final PrefService _prefService = PrefService();

    return SafeArea(
      child: Scaffold(
        body: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Center(
            child: ConstrainedBox(
              constraints: BoxConstraints(
                maxWidth: 680,
              ),
              child: Container(
                child: SingleChildScrollView(
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
                      SizedBox(height: 30.0),
                      Text("Login", style: GoogleFonts.lato(fontSize: 30.0)),
                      Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: Card(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          elevation: 10,
                          shadowColor: Colors.black,
                          child: Padding(
                            padding: const EdgeInsets.all(10),
                            child: TextFormField(
                              controller: authProvider.email,
                              decoration: InputDecoration(
                                border: InputBorder.none,
                                hintText: "Email",
                                icon: Icon(
                                  Icons.email,
                                  size: 32,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: Card(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          elevation: 10,
                          shadowColor: Colors.black,
                          child: Padding(
                            padding: const EdgeInsets.all(10),
                            child: TextFormField(
                              controller: authProvider.password,
                              decoration: InputDecoration(
                                suffixIcon: IconButton(
                                  onPressed: () {
                                    setState(() {
                                      ob = !ob;
                                    });
                                  },
                                  icon: Icon(
                                    ob
                                        ? Icons.visibility
                                        : Icons.visibility_off,
                                    size: 32,
                                  ),
                                ),
                                border: InputBorder.none,
                                hintText: "Password",
                                icon: Icon(
                                  Icons.lock,
                                  size: 32,
                                ),
                              ),
                              obscureText: ob,
                              autofocus: false,
                            ),
                          ),
                        ),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Card(
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                              elevation: 10,
                              shadowColor: Colors.black,
                              child: GestureDetector(
                                onTap: () async {
                                  if (!await authProvider.signIn()) {
                                    Fluttertoast.showToast(msg: "Login Failed");

                                    return;
                                  } else {
                                    _prefService
                                        .createCache(authProvider.user.uid)
                                        .whenComplete(() async {
                                      if (authProvider.email.text.isNotEmpty &&
                                          authProvider
                                              .password.text.isNotEmpty) {
                                        await authProvider.reloadUserModel();
                                        authProvider.clearController();
                                        await action.getAction(
                                            authProvider.userModel.name);

                                        pushAndRemoveUntil(
                                          context,
                                          HomeScreen(),
                                        );
                                        Fluttertoast.showToast(
                                            msg: "You Are logged-in now");
                                      }
                                    });
                                  }
                                },
                                child: Container(
                                  child: Padding(
                                    padding: const EdgeInsets.all(3.0),
                                    child: CircleAvatar(
                                      backgroundColor: Colors.orange,
                                      maxRadius: 25,
                                      child: Icon(
                                        Icons.play_arrow,
                                        size: 35,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
