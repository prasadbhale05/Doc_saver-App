import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';

class UserInfoProvider extends ChangeNotifier {
  String _userName = "";
  String get userName => _userName;
  final FirebaseDatabase _firebaseDatabase = FirebaseDatabase.instance;
  User? get user => FirebaseAuth.instance.currentUser;
  getUserName() async {
    await _firebaseDatabase
        .ref()
        .child("user_info/${user!.uid}")
        .get()
        .then((value) {
      _userName = (value.value as Map)['username'].toString();
      notifyListeners();
    });
  }

  updateUsername(String username, BuildContext context) async {
    await _firebaseDatabase
        .ref()
        .child("user_info/${user!.uid}")
        .update({'username': userName}).then((value) {
      _userName = username;
      notifyListeners();
      Navigator.of(context).pop();
    });
  }
}
