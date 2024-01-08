import 'dart:convert';

import 'package:expense/db.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Database extends ChangeNotifier {
  //currentTable = key value from sp
  //currentTableName = table name from sql

  //messages table to store messages

  List smsTerms = [
    "Cr",
    "Credit",
    "credited",
    "Credited",
    "Debit",
    "debited",
    "Debited",
  ];

  List incomeTypeDecider = [
    "Cr",
    "Credit",
    "credited",
    "Credited",
    "Deposited",
    "deposited",
  ];

  List expenseTypeDecider = [
    "Debit",
    "debit",
    "debited",
    "Debited",
    "Withdraw",
    "withdraw",
    "Withdrawn",
    "withdrawn",
  ];

  List compulsorySmsTerms = [
    "A/c",
    "A/C",
    "a/c",
    "Acct",
    "acct",
  ];

  List dataFromDB = [];
  String currentTable = "";
  String currentTableName = "";
  String monthString = "";
  String yearString = "";

  List<String> dbNames = [];

  Map<String, List> monthData = {};
  Map<String, double> chartData = {};
  double totalExpenditure = 0;
  double totalIncome = 0;
  double netIncome = 0;

  //initialise data
  Future<void> setData(String month, String year) async {
    final db = await DB.database();
    final pref = await SharedPreferences.getInstance();

    monthString = month;
    yearString = year;

    List tempList = [];
    tempList = pref.getKeys().toList();

    if (tempList.length == 0) {
      pref.setString("Default", "defaultTable");
      currentTable = "Default";
      currentTableName = "defaultTable";
      print("DEFAULT DATABASE CREATED");
    } else {
      for (int i = 0; i < tempList.length; i++) {
        dbNames.add(tempList[i]);
      }
      currentTable = dbNames[0];
      currentTableName = pref.getString(currentTable).toString();

      // print(dbNames);
    }
    await sms();
    await getRecordsOfAMonth();
    // print(dataFromDB);
    getTotalExpenditure();
  }

  Future<void> sms() async {
    bool isValid = false;
    bool decided = false;
    String amount = "";
    String type = "";
    bool validAmount = false;

    // print("starting sms");
    final db = await DB.database();
    List<Map> allSms = await db.query("messages");
    //decoding body
    if (allSms.length != 0) {
      for (int i = 0; i < allSms.length; i++) {
        String mssg = allSms[i]["body"];
        for (int j = 0; j < compulsorySmsTerms.length; j++) {
          if (mssg.contains(compulsorySmsTerms[j])) {
            String body = mssg;
            int index;
            if (body.contains("INR"))
              index = body.indexOf("INR");
            else if (body.contains("Rs"))
              index = body.indexOf("Rs");
            else
              break;
            while (true) {
              try {
                double.parse(body[index]);
                break;
              } catch (e) {
                index++;
              }
            }
            int spaceIndex = 0;
            spaceIndex = body.substring(index).indexOf('.') + 2;
            spaceIndex += index;
            // for (int k = index; k < body.length; k++) if (body[k] == '.') spaceIndex = k + 2;

            amount = body.substring(index, spaceIndex);
            amount = amount.replaceAll(",", "");
            isValid = true;
            //deciding whether credit or debit
            try {
              double.parse(amount);
              validAmount = true;
            } catch (err) {
              validAmount = false;
            }
          }
        }
        if (isValid && validAmount) {
          for (int j = 0; j < expenseTypeDecider.length; j++) {
            if (mssg.contains(expenseTypeDecider[j])) {
              type = "Expense";
              decided = true;
            }
          }
          for (int j = 0; j < incomeTypeDecider.length; j++) {
            if (mssg.contains(incomeTypeDecider[j])) {
              type = "Income";
              decided = true;
            }
          }
          if (decided) {
            Map<String, Object> data = {
              "id": allSms[i]["id"].toString(),
              "note": "",
              "amount": amount.toString().replaceAll(",", ""),
              "type": type,
              "category": "Unspecified",
              "date": DateTime.parse(allSms[i]["id"]).toString().substring(0, 10),
              "takenFrom": "sms",
            };
            await addToTable(data);
            DB.insertIntoTable("insertedMessages", {
              "id": allSms[i]["id"].toString(),
              "body": mssg,
              "date": DateTime.now().toString().substring(0, 10),
            });
          }

          // List newData = await db.query("insertedMessages");
          // print("!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!" + newData.toString());

        }

        // db.delete("messages", where: ("id = \'${allSms[i]['id']}\'"));
        // await db.execute('DELETE FROM messages');
        // await db.delete("messages");
        // await db.rawDelete("DELETE FROM messages");
      }
      // await db.delete("DELETE FROM messages");
      await db.delete("messages");
      // await db.rawDelete("DELETE FROM messages");
      print(allSms);
    }
    // await getAllRecordsFromTable();
    // getTotalExpenditure();
    // getRecordsOfAMonth();
    // // getDailyTx(data)
    // notifyListeners();
  }

  //creating a new account
  Future<void> addNewAccount(String name) async {
    final db = await DB.database();
    final pref = await SharedPreferences.getInstance();
    await pref.setString(name, name + "Table");
    await DB.createTable(name + "Table");
  }

  //adding data to table
  Future<void> addToTable(Map<String, Object> data) async {
    final db = await DB.insertIntoTable(currentTableName, data);
    await getAllRecordsFromTable();
    getTotalExpenditure();
    getRecordsOfAMonth();
    // getDailyTx(data)
    notifyListeners();
  }

  //get all records from table
  Future<void> getAllRecordsFromTable() async {
    final db = await DB.database();
    dataFromDB = await db.query(currentTableName);
  }

  Future<void> getRecordsOfAMonth() async {
    dataFromDB = await DB.monthData(monthString, yearString, currentTableName);
    // dataFromDB.sort((b, a) => b);
    getTotalExpenditure();
    monthData = {};
    for (int i = dataFromDB.length - 1; i >= 0; i--) {
      // print(monthData.containsKey(dataFromDB[i]["date"]));
      if (monthData.containsKey(dataFromDB[i]["date"]))
        monthData[dataFromDB[i]["date"]]!.add(dataFromDB[i]);
      else
        monthData.putIfAbsent(dataFromDB[i]["date"], () => [dataFromDB[i]]);
    }
    // print(monthData);
    notifyListeners();
  }

  //find sum of expenditure
  void getTotalExpenditure() {
    double expense = 0;
    double income = 0;
    for (int i = 0; i < dataFromDB.length; i++) {
      if (dataFromDB[i]["type"] == "Expense")
        expense += double.parse(dataFromDB[i]["amount"]);
      else
        income += double.parse(dataFromDB[i]["amount"]);
    }
    totalExpenditure = expense;
    totalIncome = income;
    netIncome = totalExpenditure - totalIncome;
  }

  List getDailyTx(List? data) {
    // ...monthData.keys.map((e) {
    //   return ;
    // });
    print("daily tx running");
    List result = [];
    double expense = 0;
    double income = 0;
    for (int i = 0; i < data!.length; i++) {
      if (data[i]["type"] == "Expense")
        expense += double.parse(data[i]["amount"]);
      else
        income += double.parse(data[i]["amount"]);
    }
    result.add(expense);
    result.add(income);

    return result;
  }

  Future<void> updateData(Map<String, Object> data, String id) async {
    final db = await DB.database();
    db.update(currentTableName, data, where: ("id = '${id}'"));
    await getRecordsOfAMonth();
    getTotalExpenditure();
    getRecordsOfAMonth();
    // getDailyTx(data)
    notifyListeners();
  }

  Future<void> getChartData() async {
    chartData = {};
    for (int i = 0; i < dataFromDB.length; i++) {
      Map data = dataFromDB[i];
      if (data["type"] == "Expense") {
        if (!chartData.containsKey(data["category"])) {
          chartData[data["category"]] = double.parse(data["amount"]);
        } else {
          chartData[data["category"]] = chartData[data["category"]]! + double.parse(data["amount"]);
        }
      }
    }
  }

  Future<void> deleteTx(String id) async {
    await DB.deleteTx(id, currentTableName);
    getRecordsOfAMonth();
  }
}
