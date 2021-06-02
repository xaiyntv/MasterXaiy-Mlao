import 'package:flutter/material.dart';
// import 'package:mlao/screens/homes.dar
import 'package:shared_preferences/shared_preferences.dart';
import 'package:mlao/screens/home.dart';

Future<Null> signOutProcess(BuildContext context) async {
  SharedPreferences preferences = await SharedPreferences.getInstance();
  preferences.clear();
  // exit(0);

  MaterialPageRoute route = MaterialPageRoute(
    builder: (context) => Home(),
  );
  Navigator.pushAndRemoveUntil(context, route, (route) => false);
}
