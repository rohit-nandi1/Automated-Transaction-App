import 'package:expense/Provider/database.dart';
import 'package:expense/palette.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

// // ignore_for_file: unnecessary_new
class _ChartData {
  _ChartData(this.x, this.y);

  final String x;
  final double y;
}

class StatScreen extends StatefulWidget {
  static const routeName = "/stat";

  @override
  State<StatScreen> createState() => _StatScreenState();
}

class _StatScreenState extends State<StatScreen> {
  int dailyObjective = 2;
  Map<String, double> data = {};
  late List<_PieData> pieData = [];
  List<Color> palette = [
    Color.fromRGBO(36, 120, 129, 1),
    Color.fromRGBO(242, 74, 114, 1),
    Color.fromRGBO(255, 209, 36, 1),
    Color.fromRGBO(48, 170, 221, 1),
    Color.fromRGBO(153, 0, 240, 1),
    Color.fromRGBO(182, 255, 206, 1),
    Color.fromRGBO(255, 24, 24, 1),
    Color.fromRGBO(255, 225, 98, 1),
  ];
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

  @override
  void initState() {
    palette.shuffle();
    initialise();
    super.initState();
  }

  Future<void> initialise() async {
    await Provider.of<Database>(context, listen: false).getChartData();
    data = Provider.of<Database>(context, listen: false).chartData;
    data.forEach((key, value) {
      pieData.add(_PieData(key, value, "test"));
    });
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final db = Provider.of<Database>(context, listen: false);
    // List<charts.Series<LinearSales, int>> data = PieOutsideLabelChart._createSampleData();
    var maxWidth = MediaQuery.of(context).size.width;
    return Scaffold(
        backgroundColor: mainColor,
        body: SafeArea(
            child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              height: 10,
            ),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 20),
              child: Text("Expense stats",
                  style: TextStyle(
                    fontFamily: "Poppins",
                    fontSize: 30,
                    color: Colors.white,
                  )),
            ),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 20),
              child: Text(monthMap[int.parse(db.monthString).toString()].toString(),
                  style: TextStyle(
                    fontFamily: "Poppins",
                    fontSize: 20,
                    color: Colors.white,
                  )),
            ),
            Container(
              child: SfCircularChart(
                // onLegendTapped: (legendTapArgs) => print(legendTapArgs.pointIndex),
                // onLegendItemRender: (args) => args.legendIconType = LegendIconType.diamond,
                legend: Legend(
                    isVisible: true,
                    isResponsive: false,
                    position: LegendPosition.right,
                    legendItemBuilder: (String name, dynamic series, dynamic point, int index) {
                      return Container(
                          height: 30,
                          width: 80,
                          child: Row(children: <Widget>[
                            // Container(child: Image.asset('images/bike.png')),
                            Container(
                                child: Text(
                              name,
                              style: TextStyle(
                                fontFamily: "Poppins",
                                fontSize: 12,
                                color: palette[index],
                              ),
                            )),
                          ]));
                    }
                    // overflowMode: LegendItemOverflowMode.none,
                    ),
                // backgroundColor: Colors.white,
                margin: EdgeInsets.all(0),
                centerX: "50%",
                centerY: "50%",
                series: <DoughnutSeries<_PieData, String>>[
                  DoughnutSeries<_PieData, String>(
                    // explode: true,
                    // explodeIndex: 0,
                    dataSource: pieData,
                    xValueMapper: (_PieData data, _) => data.xData,
                    yValueMapper: (_PieData data, _) => data.yData,
                    // dataLabelMapper: (_PieData data, _) => data.text,
                    dataLabelSettings: DataLabelSettings(isVisible: false),
                    // radius: "100",
                    // innerRadius: "70",
                  ),
                ],
                palette: palette,
              ),
            ),
            if (data.length != 0)
              Expanded(
                child: ListView.builder(
                  physics: BouncingScrollPhysics(),
                  itemBuilder: ((context, index) {
                    return Container(
                      height: 50,
                      margin: EdgeInsets.symmetric(horizontal: 20, vertical: 7),
                      padding: EdgeInsets.symmetric(horizontal: 15),
                      decoration: BoxDecoration(
                        color: mainColor,
                        boxShadow: [
                          BoxShadow(
                            color: Color.fromRGBO(69, 69, 69, 1),
                            offset: Offset(-3.74, -3.74),
                            blurRadius: 5.21,
                          ),
                          BoxShadow(
                            color: Color.fromRGBO(9, 5, 5, 0.25),
                            offset: Offset(5.6, 5.6),
                            blurRadius: 5.21,
                          )
                        ],
                        borderRadius: BorderRadius.circular(15),
                      ),
                      child: Row(
                        children: [
                          Text(
                            pieData[index].xData,
                            style: TextStyle(
                              fontFamily: "Poppins",
                              color: Colors.white,
                            ),
                          ),
                          Spacer(),
                          Text(
                            "Rs " + pieData[index].yData.toString(),
                            style: TextStyle(
                              fontFamily: "Poppins",
                              color: Color.fromRGBO(255, 105, 105, 1),
                            ),
                          ),
                        ],
                      ),
                    );
                  }),
                  itemCount: pieData.length,
                ),
              ),
            if (data.length == 0)
              Center(
                child: Text(
                  "No expenses",
                  style: TextStyle(fontFamily: "Poppins", fontSize: 18, color: Colors.white),
                ),
              ),
          ],
        )));
  }
}

class _PieData {
  final String xData;
  final num yData;
  final String text;

  _PieData(this.xData, this.yData, this.text);
}
