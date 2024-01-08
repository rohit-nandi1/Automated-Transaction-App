import 'package:expense/main.dart';
import 'package:expense/palette.dart';
import 'package:flutter/material.dart';
import 'package:flutter_background/flutter_background.dart';
import 'package:app_settings/app_settings.dart';
import 'package:permission_handler/permission_handler.dart';

class PermissionScreen extends StatelessWidget {
  static const routeName = "/permission";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: mainColor,
      body: SafeArea(
          child: Container(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // SizedBox(
            //   height: 10,
            // ),
            Material(
              color: mainColor,
              child: InkWell(
                onTap: () async {
                  String text;
                  bool messenger = false;

                  try {
                    bool? result = await telephony.requestPhoneAndSmsPermissions;

                    if (result == true) {
                      text = "Permission is given.";
                      messenger = true;
                    } else {
                      text = "There was an error. Please try manually!";
                      messenger = true;
                    }
                  } catch (e) {
                    text = "";
                    openAppSettings();
                  }
                  if (messenger)
                    ScaffoldMessenger.of(context).showSnackBar(new SnackBar(
                      content: Text(
                        text,
                      ),
                      duration: Duration(seconds: 3),
                    ));
                },
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "SMS Permission",
                        style: TextStyle(
                          fontFamily: "Poppins",
                          color: Colors.white,
                          fontSize: 18,
                        ),
                      ),
                      Text(
                        "Need this permission to look for incoming bank texts and add transactions. In case you have permanently disabled it in the pop up, kindly tap here and go to Permissions and give SMS permission to the app.",
                        style: TextStyle(
                          fontFamily: "Poppins",
                          color: Colors.grey,
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            Material(
              color: mainColor,
              child: InkWell(
                onTap: () async {
                  final androidConfig = FlutterBackgroundAndroidConfig(
                    notificationTitle: "flutter_background example app",
                    notificationText: "Background notification for keeping the example app running in the background",
                    notificationImportance: AndroidNotificationImportance.Default,
                    notificationIcon: AndroidResource(name: 'background_icon', defType: 'drawable'), // Default is ic_launcher from folder mipmap
                  );
                  bool success = await FlutterBackground.initialize(androidConfig: androidConfig);
                  bool success1 = await FlutterBackground.enableBackgroundExecution();
                  String text;
                  if (success1 == true) {
                    text = "Permission is given.";
                  } else {
                    text = "";
                    openAppSettings();
                  }
                  ScaffoldMessenger.of(context).showSnackBar(new SnackBar(
                    content: Text(
                      text,
                    ),
                    duration: Duration(milliseconds: 1500),
                  ));
                },
                child: Container(
                  width: MediaQuery.of(context).size.width,
                  padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Background permission",
                        style: TextStyle(
                          fontFamily: "Poppins",
                          color: Colors.white,
                          fontSize: 18,
                        ),
                      ),
                      Text(
                        "Need this permission to run the app in background.",
                        style: TextStyle(
                          fontFamily: "Poppins",
                          color: Colors.grey,
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            Material(
              color: mainColor,
              child: InkWell(
                onTap: () {
                  openAppSettings();
                },
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Other issues",
                        style: TextStyle(
                          fontFamily: "Poppins",
                          color: Colors.white,
                          fontSize: 18,
                        ),
                      ),
                      Text(
                        "If the app is not detecting the transactions, it might be because of battery optimisation by Android OS. Kindly tap here and go to Advanced -> Battery and then select \'Don't optimise\'.",
                        style: TextStyle(
                          fontFamily: "Poppins",
                          color: Colors.grey,
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      )),
    );
  }
}
