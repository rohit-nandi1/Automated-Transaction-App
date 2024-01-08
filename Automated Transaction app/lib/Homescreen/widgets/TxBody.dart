import 'package:expense/Homescreen/widgets/addNote.dart';
import 'package:expense/Provider/database.dart';
import 'package:expense/palette.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class TxBody extends StatelessWidget {
  TxBody({
    Key? key,
    required this.maxWidth,
  }) : super(key: key);

  final double maxWidth;
  final ScrollController controller1 = new ScrollController(initialScrollOffset: 0);
  final ScrollController controller2 = new ScrollController(initialScrollOffset: 0);

  @override
  Widget build(BuildContext context) {
    final db = Provider.of<Database>(context, listen: false);
    return SingleChildScrollView(
        physics: BouncingScrollPhysics(),
        child: Column(
          children: [
            ...db.monthData.keys.map((e) {
              double expense = db.getDailyTx(db.monthData[e])[0];
              double income = db.getDailyTx(db.monthData[e])[1];
              String s = e.substring(8, 10) + ", " + DateFormat('EEEE').format(DateTime.parse(db.monthData[e]![0]["id"]));
              return Container(
                padding: EdgeInsets.symmetric(horizontal: 10),
                margin: EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                width: maxWidth,
                // height: 300,
                decoration: BoxDecoration(
                  color: mainColor,
                  boxShadow: [
                    BoxShadow(
                      color: Color.fromRGBO(69, 69, 69, 1),
                      offset: Offset(-3.74, -3.74),
                      blurRadius: 11.21,
                    ),
                    BoxShadow(
                      color: Color.fromRGBO(9, 5, 5, 0.25),
                      offset: Offset(5.6, 5.6),
                      blurRadius: 11.21,
                    )
                  ],
                  borderRadius: BorderRadius.circular(15),
                ),
                child: Column(
                  children: [
                    SizedBox(
                      height: 10,
                    ),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          s,
                          style: TextStyle(
                            fontFamily: "Poppins",
                            fontSize: 14,
                            color: Colors.white,
                          ),
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Text(
                              "Rs " + expense.toString(),
                              style: TextStyle(
                                fontFamily: "Poppins",
                                fontSize: 10,
                                color: Color.fromRGBO(255, 105, 105, 1),
                              ),
                            ),
                            Text(
                              "Rs " + income.toString(),
                              style: TextStyle(
                                fontFamily: "Poppins",
                                fontSize: 10,
                                color: Color.fromRGBO(74, 209, 120, 1),
                              ),
                            ),
                          ],
                        )
                      ],
                    ),
                    Column(
                      children: [
                        ...db.monthData[e]!.map((f) {
                          return Stack(
                            children: [
                              Container(
                                padding: EdgeInsets.symmetric(horizontal: 10),
                                width: maxWidth,
                                margin: EdgeInsets.symmetric(vertical: 5),
                                height: 50,
                                decoration: BoxDecoration(
                                  color: mainColor,
                                  boxShadow: [
                                    BoxShadow(
                                      color: Color.fromRGBO(69, 69, 69, 1),
                                      offset: Offset(-3.74, -3.74),
                                      blurRadius: 11.21,
                                    ),
                                    BoxShadow(
                                      color: Color.fromRGBO(9, 5, 5, 0.25),
                                      offset: Offset(5.6, 5.6),
                                      blurRadius: 11.21,
                                    )
                                  ],
                                  borderRadius: BorderRadius.circular(15),
                                ),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    Container(
                                      width: 80,
                                      padding: EdgeInsets.only(right: 5),
                                      child: SingleChildScrollView(
                                        scrollDirection: Axis.horizontal,
                                        child: Text(
                                          "Rs " + f["amount"],
                                          style: TextStyle(
                                            fontFamily: "Poppins",
                                            fontSize: 14,
                                            color: f["type"] == "Expense" ? Color.fromRGBO(255, 105, 105, 1) : Color.fromRGBO(74, 209, 120, 1),
                                          ),
                                        ),
                                      ),
                                    ),

                                    Expanded(
                                      child: GestureDetector(
                                        onTap: () {
                                          showDialog(
                                              context: context,
                                              builder: (BuildContext context) {
                                                return AddNote(maxWidth: maxWidth, isEdit: true, data: {
                                                  "id": f["id"],
                                                  "text": f["note"],
                                                  "amount": f["amount"],
                                                  "category": f["category"],
                                                  "type": f["type"],
                                                  "date": f["date"],
                                                  "takenFrom": f["takenFrom"],
                                                });
                                              });
                                        },
                                        child: Container(
                                          padding: EdgeInsets.symmetric(horizontal: 10, vertical: 2),
                                          width: double.maxFinite,
                                          height: 30,
                                          decoration: BoxDecoration(
                                            color: Color.fromRGBO(196, 196, 196, 0.16),
                                            borderRadius: BorderRadius.circular(20),
                                          ),
                                          child: Align(
                                            alignment: Alignment.centerLeft,
                                            child: f["note"] == ""
                                                ? Text(
                                                    "Tap to add a note",
                                                    style: TextStyle(
                                                      fontFamily: "Poppins",
                                                      color: Colors.grey,
                                                      fontSize: 12,
                                                    ),
                                                  )
                                                : SingleChildScrollView(
                                                    physics: BouncingScrollPhysics(),
                                                    child: Text(
                                                      f["note"],
                                                      style: TextStyle(
                                                        fontFamily: "Poppins",
                                                        color: Colors.white,
                                                        fontSize: 12,
                                                      ),
                                                    ),
                                                  ),
                                          ),
                                        ),
                                      ),
                                    ),
                                    // SizedBox(width: 10),
                                    Container(
                                      width: 70,
                                      child: Text(
                                        DateFormat('jm').format(DateTime.parse(f["id"])),
                                        textAlign: TextAlign.right,
                                        style: TextStyle(
                                          fontFamily: "Poppins",
                                          color: Colors.white,
                                          fontSize: 12,
                                        ),
                                      ),
                                    )
                                  ],
                                ),
                              ),
                              if (f["takenFrom"] == "sms")
                                Positioned(
                                  right: 5,
                                  bottom: 10,
                                  child: Text(
                                    "SMS",
                                    style: TextStyle(
                                      fontFamily: "Poppins",
                                      color: Colors.white,
                                      fontSize: 8,
                                    ),
                                  ),
                                ),
                            ],
                          );
                        })
                      ],
                    ),
                    SizedBox(
                      height: 10,
                    )
                  ],
                ),
              );
            })
          ],
        ));
  }
}
