import 'dart:convert';

import 'package:expense/Homescreen/homescreen.dart';
import 'package:expense/Provider/database.dart';
import 'package:expense/db.dart';
import 'package:expense/main.dart';
import 'package:expense/palette.dart';
import 'package:flutter/material.dart';
import 'package:flutter_background/flutter_background.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:telephony/telephony.dart';

class Test extends StatefulWidget {
  const Test({Key? key}) : super(key: key);

  @override
  State<Test> createState() => _TestState();
}

class _TestState extends State<Test> {
  @override
  void initState() {
    super.initState();
    initialise();
  }

  Future<void> initialise() async {
    String monthString = DateTime.now().month.toString();
    if (monthString.length == 1) monthString = "0" + monthString;
    await Provider.of<Database>(context, listen: false).setData(monthString, DateTime.now().year.toString());
    Navigator.of(context).pushReplacementNamed(HomeScreen.routeName);
  }

  @override
  Widget build(BuildContext context) {
    final db = Provider.of<Database>(context);
    return Scaffold(
        backgroundColor: Colors.white,
        body: Container(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
          color: mainColor,
        ));
  }
}
