import 'package:expense/Homescreen/mainDrawer.dart';
import 'package:expense/Homescreen/widgets/TxBody.dart';
import 'package:expense/Homescreen/widgets/addNote.dart';
import 'package:expense/Homescreen/widgets/slideWidget.dart';
import 'package:expense/Provider/database.dart';
import 'package:expense/db.dart';
import 'package:expense/main.dart';
import 'package:expense/palette.dart';
import 'package:flutter/material.dart';
import 'package:flutter_background/flutter_background.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:telephony/telephony.dart';

class HomeScreen extends StatefulWidget {
  static const routeName = "/home";

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  Map<String, String> monthMap = {
    "1": "January",
    "2": "February",
    "3": "March",
    "4": "April",
    "5": "May",
    "6": "June",
    "7": "July",
    "8": "August",
    "9": "September",
    "10": "October",
    "11": "November",
    "12": "December",
  };
  int month = DateTime.now().month;
  int year = DateTime.now().year;
  final GlobalKey<ScaffoldState> _key = GlobalKey();

  String _message = "";
  final telephony = Telephony.instance;
  final androidConfig = FlutterBackgroundAndroidConfig(
    notificationTitle: "flutter_background example app",
    notificationText: "Background notification for keeping the example app running in the background",
    notificationImportance: AndroidNotificationImportance.Default,
    notificationIcon: AndroidResource(name: 'background_icon', defType: 'drawable'), // Default is ic_launcher from folder mipmap
  );

  onMessage(SmsMessage message) async {
    DB.insertIntoTable("messages", {
      "id": DateTime.now().toString(),
      "body": message.body.toString(),
      "date": DateTime.now().toString().substring(0, 10),
    });
    await Provider.of<Database>(context, listen: false).sms();
    print("added data!");
  }

  @override
  void initState() {
    super.initState();
    initPlatformState();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    setState(() {
      Provider.of<Database>(context, listen: false).sms();
    });
  }

  Future<void> initPlatformState() async {
    final bool? result = await telephony.requestPhoneAndSmsPermissions;

    bool success = await FlutterBackground.initialize(androidConfig: androidConfig);
    bool success1 = await FlutterBackground.enableBackgroundExecution();

    if (result != null && result) {
      telephony.listenIncomingSms(onNewMessage: onMessage, onBackgroundMessage: onBackgroundMessage);
    }

    if (!mounted) return;
  }

  @override
  Widget build(BuildContext context) {
    final db = Provider.of<Database>(context, listen: false);
    var maxWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      key: _key,
      drawer: MainDrawer(),
      backgroundColor: mainColor,
      floatingActionButton: FloatingActionButton(
        backgroundColor: mainColor,
        child: Icon(Icons.add),
        onPressed: () {
          showDialog(
              context: context,
              builder: (BuildContext context) {
                return AddNote(
                  maxWidth: maxWidth,
                  isEdit: false,
                  data: {},
                );
              });
        },
      ),
      body: SafeArea(
        child: Container(
          color: mainColor,
          width: maxWidth,
          child: Consumer<Database>(builder: (ctx, db, _) {
            return Column(
              children: [
                SizedBox(
                  height: 10,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    GestureDetector(
                      onTap: () => _key.currentState!.openDrawer(),
                      child: Container(
                        margin: EdgeInsets.only(left: 15),
                        height: 25,
                        child: Image.asset("assets/images/menu.png"),
                      ),
                    ),
                  ],
                ),
                SizedBox(
                  height: 20,
                ),
                SlideWidget(),
                SizedBox(
                  height: 5,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    IconButton(
                        onPressed: () async {
                          // setState(() {
                          await db.getAllRecordsFromTable();
                          if(db.dataFromDB.length == 0) return;
                          String locMon = db.dataFromDB[0]['date'].toString().substring(5, 7);
                          String locYear = db.dataFromDB[0]['date'].toString().substring(0, 4);

                          if (year >= int.parse(locYear) && month > int.parse(locMon)) {
                            print("run");
                            month--;
                            if (month == 0) {
                              month = 12;
                              year--;
                            }
                            db.monthString = month.toString();
                            db.yearString = year.toString();
                            // print(monthString);
                            // print(yearString);
                            if (db.monthString.length == 1) db.monthString = "0" + db.monthString;
                            db.getRecordsOfAMonth();
                          }
                          // });
                        },
                        icon: Icon(
                          Icons.arrow_back,
                          color: Colors.white,
                        )),
                    Text(
                      monthMap[month.toString()].toString() + ", $year",
                      style: TextStyle(
                        fontFamily: "Poppins",
                        fontSize: 20,
                        color: Colors.white,
                      ),
                    ),
                    IconButton(
                      onPressed: () {
                        if (year == DateTime.now().year && month + 1 > DateTime.now().month) return;
                        // setState(() {
                        month++;

                        if (month == 13) {
                          month = 1;
                          year++;
                        }
                        db.monthString = month.toString();
                        db.yearString = year.toString();
                        // print(monthString);
                        // print(yearString);
                        if (db.monthString.length == 1) db.monthString = "0" + db.monthString;
                        db.getRecordsOfAMonth();
                        // });
                      },
                      icon: Icon(
                        Icons.arrow_forward,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
                Expanded(child: TxBody(maxWidth: maxWidth))
              ],
            );
          }),
        ),
      ),
    );
  }
}
