import 'package:expense/Provider/database.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class SlideWidget extends StatefulWidget {
  @override
  State<SlideWidget> createState() => _SlideWidgetState();
}

class _SlideWidgetState extends State<SlideWidget> {
  int _curr = 0;

  PageController controller = PageController();

  @override
  Widget build(BuildContext context) {
    // isLoading == true ? init(context) : null;
    final db = Provider.of<Database>(context, listen: false);
    print("rebuilding!!!!");
    return Container(
      width: double.maxFinite,
      height: 60,
      padding: EdgeInsets.symmetric(horizontal: 10),
      margin: EdgeInsets.symmetric(horizontal: 10),
      decoration: BoxDecoration(
        color: Color.fromRGBO(58, 56, 69, 1),
        boxShadow: [
          BoxShadow(
            blurRadius: 11.21,
            color: Color.fromRGBO(69, 69, 69, 1),
            offset: Offset(-3.74, -3.74),
          ),
          BoxShadow(
            blurRadius: 11.21,
            color: Color.fromRGBO(9, 5, 5, 0.25),
            offset: Offset(5.6, 5.6),
          ),
        ],
        borderRadius: BorderRadius.circular(15),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Expanded(
              child: PageView(
            physics: BouncingScrollPhysics(),
            children: [
              Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  "Total expenditure: " + db.totalExpenditure.toString(),
                  style: TextStyle(
                    fontFamily: "Poppins",
                    color: Color.fromRGBO(255, 105, 105, 1),
                    fontSize: 18,
                  ),
                ),
              ),
              Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  "Total income: " + db.totalIncome.toString(),
                  style: TextStyle(
                    fontFamily: "Poppins",
                    color: Color.fromRGBO(74, 209, 120, 1),
                    fontSize: 18,
                  ),
                ),
              ),
              Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  db.netIncome <= 0 ? "Net income: " + db.netIncome.toString().substring(1) : "Net expenditure: " + db.netIncome.toString(),
                  style: TextStyle(
                    fontFamily: "Poppins",
                    color: db.netIncome > 0 ? Color.fromRGBO(255, 105, 105, 1) : Color.fromRGBO(74, 209, 120, 1),
                    fontSize: 18,
                  ),
                ),
              ),
            ],
            scrollDirection: Axis.vertical,
            controller: controller,
            onPageChanged: (num) {
              setState(() {
                _curr = num;
              });
            },
          )),
          // Spacer(),
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              pageIndicator(0),
              pageIndicator(1),
              pageIndicator(2),
            ],
          )
        ],
      ),
    );

    // child:
  }

  Container pageIndicator(int index) {
    return Container(
      width: 5,
      height: _curr == index ? 14 : 10,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(15),
        color: _curr == index ? Colors.white : Colors.grey,
      ),
      margin: EdgeInsets.symmetric(vertical: 3),
    );
  }
}
