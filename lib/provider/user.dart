import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../services/user.dart';
import '../model/user.dart';

enum Status { Uninitialized, Authenticated, Authenticating, Unauthenticated }

class UserProvider with ChangeNotifier {
  FirebaseAuth? _auth = FirebaseAuth.instance;
  User? _user;
  UserServices _userServicse = UserServices();
  UserModel? _userModel;
  String? fileName;
  Status _status = Status.Uninitialized;

//  getter
  UserModel get userModel => _userModel!;
  User get user => _user!;
  Status get status => _status;

  TextEditingController email = TextEditingController();
  TextEditingController password = TextEditingController();
  TextEditingController name = TextEditingController();
  TextEditingController phone = TextEditingController();
  TextEditingController country = TextEditingController();
  TextEditingController companyName = TextEditingController();
  TextEditingController code = TextEditingController();

  UserProvider() : _auth = FirebaseAuth.instance {
    _auth!.authStateChanges().listen(_onStateChanged);
  }

  Future<void> _onStateChanged(User? firebaseUser) async {
    if (firebaseUser == null) {
      _status = Status.Unauthenticated;
    } else {
      _user = firebaseUser;
      _status = Status.Authenticated;
      _userModel = await _userServicse.getUserById(user.uid);
    }
  }

  Future<void> reloadUser(String id) async {
    _userModel = await _userServicse.getUserById(id);
  }

  Future<bool> signIn() async {
    try {
      await _auth!.signInWithEmailAndPassword(
          email: email.text.trim(), password: password.text.trim());
      _user = _auth!.currentUser;
      return true;
    } catch (e) {
      return false;
    }
  }

  Future signOut() async {
    _auth!.signOut();

    return Future.delayed(Duration.zero);
  }

  void clearController() {
    name.text = "";
    password.text = "";
    email.text = "";
    phone.text = "";
  }

  Future<void> reloadUserModel() async {
    _userModel = await _userServicse.getUserById(user.uid);
  }
}
