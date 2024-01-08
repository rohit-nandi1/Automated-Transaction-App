import 'package:expense/palette.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:razorpay_flutter/razorpay_flutter.dart';

class DonateScreen extends StatefulWidget {
  static const routeName = "/donation";

  @override
  State<DonateScreen> createState() => _DonateScreenState();
}

class _DonateScreenState extends State<DonateScreen> {
  late Razorpay razorpay;
  final moneyController = new TextEditingController();
  @override
  void initState() {
    razorpay = new Razorpay();
    razorpay.on(Razorpay.EVENT_PAYMENT_SUCCESS, handlerPaymentSuccess);
    razorpay.on(Razorpay.EVENT_PAYMENT_SUCCESS, handlerErrorFailure);
    razorpay.on(Razorpay.EVENT_EXTERNAL_WALLET, handlerExternalWallet);
    super.initState();
  }

  @override
  void dispose() {
    razorpay.clear();
    super.dispose();
  }

  void openCheckout() {
    var options = {
      "key": "rzp_live_FW9vSyk5kKPwH7",
      "amount": num.parse(moneyController.text) * 100,
      "name": "Sayam",
      "description": "You are buying me a coffee!",
    };
    try {
      razorpay.open(options);
    } catch (err) {
      print(err);
    }
  }

  void handlerPaymentSuccess() {
    Navigator.of(context).pop();
  }

  void handlerErrorFailure() {
    print("Payment fail");
  }

  void handlerExternalWallet() {
    print("External wallet");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: mainColor,
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            margin: EdgeInsets.symmetric(horizontal: 20),
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(15),
                border: Border.all(
                  color: Colors.redAccent,
                  width: 3,
                )),
            padding: EdgeInsets.symmetric(horizontal: 20),
            child: TextField(
              style: TextStyle(
                color: Colors.white,
              ),
              keyboardType: TextInputType.phone,
              decoration: new InputDecoration(
                border: InputBorder.none,
                hintText: 'Enter amount here!',
              ),
              controller: moneyController,
            ),
          ),
          SizedBox(
            height: 20,
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              primary: Color.fromRGBO(74, 209, 120, 1),
            ),
            onPressed: () async {
              if (num.parse(moneyController.text) < 1) return;
              openCheckout();
            },
            child: Text(
              "Buy me a coffee!",
              style: TextStyle(
                fontFamily: "Poppins",
                fontSize: 16,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
