import 'package:expense/DonateScreen/donate_screen.dart';
import 'package:expense/Permission/permissionScreen.dart';
import 'package:expense/Stats/statScreen.dart';
import 'package:expense/palette.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class MainDrawer extends StatelessWidget {
  const MainDrawer({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width / 1.5,
      height: MediaQuery.of(context).size.height,
      color: mainColor,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Material(
            color: mainColor,
            child: InkWell(
              onTap: () {
                Navigator.of(context).pushNamed(PermissionScreen.routeName);
              },
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                width: double.maxFinite,
                child: tile("Permissions"),
              ),
            ),
          ),
          Material(
            color: mainColor,
            child: InkWell(
              onTap: () {
                Navigator.of(context).pushNamed(StatScreen.routeName);
              },
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                width: double.maxFinite,
                child: tile("Stats"),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Text tile(String text) {
    return Text(
      text,
      style: TextStyle(
        fontFamily: "Poppins",
        color: Colors.white,
        fontSize: 20,
      ),
    );
  }
}
