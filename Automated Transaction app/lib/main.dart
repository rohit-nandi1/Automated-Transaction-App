import 'dart:convert';

import 'package:expense/DonateScreen/donate_screen.dart';
import 'package:expense/Homescreen/homescreen.dart';
import 'package:expense/Permission/permissionScreen.dart';
import 'package:expense/Provider/database.dart';
import 'package:expense/Stats/statScreen.dart';
import 'package:expense/db.dart';
import 'package:expense/test.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:telephony/telephony.dart';

final Telephony telephony = Telephony.instance;

onBackgroundMessage(SmsMessage message) async {
  DB.insertIntoTable("messages", {
    "id": DateTime.now().toString(),
    "body": message.body.toString(),
    "date": DateTime.now().toString().substring(0, 10),
  });
  print("added data!");
}

void main() async {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (ctx) => Database(),
        ),
      ],
      child: Consumer<Database>(
        builder: (ctx, auth, _) {
          return MaterialApp(
              title: 'Flutter Demo',
              theme: ThemeData(
                // This is the theme of your application.
                //
                // Try running your application with "flutter run". You'll see the
                // application has a blue toolbar. Then, without quitting the app, try
                // changing the primarySwatch below to Colors.green and then invoke
                // "hot reload" (press "r" in the console where you ran "flutter run",
                // or simply save your changes to "hot reload" in a Flutter IDE).
                // Notice that the counter didn't reset back to zero; the application
                // is not restarted.
                primarySwatch: Colors.blue,
              ),
              home: Test(),
              routes: {
                HomeScreen.routeName: (ctx) => HomeScreen(),
                PermissionScreen.routeName: (ctx) => PermissionScreen(),
                StatScreen.routeName: (ctx) => StatScreen(),
                // DonateScreen.routeName: (ctx) => DonateScreen(),
              });
        },
      ),
    );
  }
}
