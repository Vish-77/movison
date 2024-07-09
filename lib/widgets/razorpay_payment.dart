import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:movison/screens/Payment/paymenthist.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

class RazorpayPayment extends StatefulWidget {
  final double amount;
  final String bookName;

  const RazorpayPayment({Key? key, required this.amount, required this.bookName})
      : super(key: key);

  @override
  State createState() => RazorpayPaymentState();
}

class RazorpayPaymentState extends State<RazorpayPayment> {
  late DateTime _currentDateTime;
  late Razorpay _razorpay;

  @override
  void initState() {
    super.initState();
    _razorpay = Razorpay();
    _razorpay.on(Razorpay.EVENT_PAYMENT_SUCCESS, handlePaymentSuccess);
    _razorpay.on(Razorpay.EVENT_PAYMENT_ERROR, handlePaymentError);
    _razorpay.on(Razorpay.EVENT_EXTERNAL_WALLET, handleExternalWallet);
    _currentDateTime = DateTime.now();
  }

  void openCheckout() async {
    var options = {
      'key': '',
      'amount': widget.amount * 100,
      'name': 'Vishal Vijay Deshpande',
      'prefill': {'contact': '84216 70509', 'email': 'movison0320@gmail.com'},
      'external': {
        'wallets': ['paytm']
      }
    };

    try {
      _razorpay.open(options);
    } catch (e) {
      debugPrint('Error : e');
    }
  }

  Future<void> savePaymentHistory(String status, String paymentId) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    String date = DateFormat('dd-MM-yyyy').format(_currentDateTime);
    String time = DateFormat('kk:mm').format(_currentDateTime);
    
    Map<String, dynamic> paymentData = {
      'status': status,
      'paymentId': paymentId,
      'amount': widget.amount,
      'bookName': widget.bookName,
      'date': date,
      'time': time
    };

    String paymentHistory = prefs.getString('paymentHistory') ?? '[]';
    List<dynamic> paymentHistoryList = jsonDecode(paymentHistory);
    paymentHistoryList.add(paymentData);

    prefs.setString('paymentHistory', jsonEncode(paymentHistoryList));
  }

  void handlePaymentSuccess(PaymentSuccessResponse response) {
    savePaymentHistory('Success', response.paymentId!);
    Fluttertoast.showToast(
        msg: "Payment Successful " + response.paymentId!,
        toastLength: Toast.LENGTH_SHORT);
  }

  void handlePaymentError(PaymentFailureResponse response) {
    savePaymentHistory('Failure', response.code.toString());
    Fluttertoast.showToast(
        msg: "Payment Failed " + response.message!,
        toastLength: Toast.LENGTH_SHORT);
  }

  void handleExternalWallet(ExternalWalletResponse response) {
    Fluttertoast.showToast(
        msg: "External Wallet " + response.walletName!,
        toastLength: Toast.LENGTH_SHORT);
  }

  @override
  void dispose() {
    super.dispose();
    _razorpay.clear();
  }

  Future<List<Map<String, dynamic>>> getPaymentHistory() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    String paymentHistory = prefs.getString('paymentHistory') ?? '[]';
    List<dynamic> paymentHistoryList = jsonDecode(paymentHistory);
    return paymentHistoryList.map((item) => item as Map<String, dynamic>).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Razorpay Payment'),
        actions: [
          IconButton(
            icon: Icon(Icons.history),
            onPressed: () async {
              List<Map<String, dynamic>> paymentHistory = await getPaymentHistory();
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => PaymentHistoryScreen(paymentHistory: paymentHistory),
                ),
              );
            },
          ),
        ],
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(vertical: 80, horizontal: 30),
        child: Column(
          children: [
            Container(
              height: 250,
              width: 400,
              decoration: BoxDecoration(
                  color: Color.fromARGB(255, 232, 222, 242),
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                        color: Color.fromARGB(255, 143, 143, 143),
                        offset: Offset(0, 7),
                        blurRadius: 5)
                  ]),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const SizedBox(
                    height: 30,
                  ),
                  Row(
                    children: [
                      SizedBox(width: 30),
                      Text(
                        'Book Name : ',
                        style: TextStyle(fontSize: 20),
                      ),
                      SizedBox(height: 10),
                      Text(
                        "${widget.bookName}",
                        style: TextStyle(
                            fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  Row(
                    children: [
                      SizedBox(width: 30),
                      Text(
                        'Date : ',
                        style: TextStyle(fontSize: 20),
                      ),
                      SizedBox(height: 10),
                      Text(
                        DateFormat('dd-MM-yyyy').format(_currentDateTime),
                        style: TextStyle(
                            fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  Row(
                    children: [
                      SizedBox(width: 30),
                      Text(
                        'Time :',
                        style: TextStyle(fontSize: 20),
                      ),
                      SizedBox(height: 10),
                      Text(
                        DateFormat('kk:mm').format(_currentDateTime),
                        style: TextStyle(
                            fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  Row(
                    children: [
                      SizedBox(width: 30),
                      Text(
                        'Total amount :',
                        style: TextStyle(fontSize: 20),
                      ),
                      SizedBox(height: 10),
                      Text(
                        "₹${widget.amount}",
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 18),
                      )
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(
              height: 260,
            ),
            SizedBox(
              width: 300,
              child: ElevatedButton(
                onPressed: openCheckout,
                style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all(
                        Color.fromARGB(255, 130, 98, 206))),
                child: Padding(
                  padding: EdgeInsets.all(10),
                  child: Text(
                    "Pay ₹${widget.amount}",
                    style: TextStyle(fontSize: 20, color: Colors.white),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
