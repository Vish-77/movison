import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_cashfree_pg_sdk/api/cferrorresponse/cferrorresponse.dart';
import 'package:flutter_cashfree_pg_sdk/api/cfpayment/cfdropcheckoutpayment.dart';
import 'package:flutter_cashfree_pg_sdk/api/cfpaymentcomponents/cfpaymentcomponent.dart';
import 'package:flutter_cashfree_pg_sdk/api/cftheme/cftheme.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:movison/screens/Payment/paymenthist.dart';

import 'package:flutter_cashfree_pg_sdk/api/cfpaymentgateway/cfpaymentgatewayservice.dart';
import 'package:flutter_cashfree_pg_sdk/api/cfsession/cfsession.dart';
import 'package:flutter_cashfree_pg_sdk/utils/cfenums.dart';
import 'package:flutter_cashfree_pg_sdk/utils/cfexceptions.dart';

class CashfreePaymentRent extends StatefulWidget {
  final double amount;
  final List<String> bookName;

  const CashfreePaymentRent({super.key, required this.amount, required this.bookName});

  @override
  State createState() => CashfreePaymentState();
}

class CashfreePaymentState extends State<CashfreePaymentRent> {
  late DateTime _currentDateTime;
  late CFPaymentGatewayService _cfPaymentGatewayService;
  User? user = FirebaseAuth.instance.currentUser;
  String currentUid = '';
  final addressController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _cfPaymentGatewayService = CFPaymentGatewayService();
    _cfPaymentGatewayService.setCallback(handleCFPaymentSuccess, handleCFPaymentError);
    _currentDateTime = DateTime.now();
    currentUid = user!.uid;
  }
String generateOrderId() {
  return 'ORDER_${DateTime.now().millisecondsSinceEpoch}';
}

createSessionID(String orderID) async { 

var headers = { 
	'Content-Type': 'application/json', 
	'x-client-id': dotenv.env['CASHFREE_API_KEY'] ?? "", 
	'x-client-secret': dotenv.env['CASHFREE_API_SECRET'] ?? "", 
	'x-api-version': '2022-09-01',// This is latest version for API 
	'x-request-id': 'fluterwings'
}; 
print(headers); 
var request = 
	http.Request('POST', Uri.parse('https://api.cashfree.com/pg/orders')); 
request.body = json.encode({ 
	"order_amount": widget.amount+40+(widget.bookName.length*100),// Order Amount in Rupees 
	"order_id": orderID, // OrderiD created by you it must be unique 
	"order_currency": "INR", // Currency of order like INR,USD 
	"customer_details": { 
	"customer_id": currentUid, 
  "customer_phone": "7057702200"// Customer id  // Phone Number of customer 
	}, 
	"order_meta": {"notify_url": "https://test.cashfree.com"}, 
	"order_note": "Thanks For Order" // If you want to store something extra 
}); 
request.headers.addAll(headers); 

http.StreamedResponse response = await request.send(); 

if (response.statusCode == 200) { 
	// If All the details is correct it will return the 
	// response and you can get sessionid for checkout 
	return jsonDecode(await response.stream.bytesToString()); 
} else { 
	print(await response.stream.bytesToString()); 
	print(response.reasonPhrase); 
} 
} 

  void openCashfreeCheckout() async {
    try {
      String orderId=generateOrderId();
      final mySessionIDData = await createSessionID( 
          orderId); 
      var session = CFSessionBuilder()
          .setEnvironment(CFEnvironment.PRODUCTION)
          .setOrderId(orderId) // Replace with your Order ID
          .setPaymentSessionId(mySessionIDData["payment_session_id"]) // Replace with your Payment Session ID
          .build();

      var theme = CFThemeBuilder()
          .setNavigationBarBackgroundColorColor("#FF0000")
          .setPrimaryFont("Menlo")
          .setSecondaryFont("Futura")
          .build();

      var paymentComponent = CFPaymentComponentBuilder().setComponents(<CFPaymentModes>[
        CFPaymentModes.UPI, CFPaymentModes.CARD, CFPaymentModes.NETBANKING
      ]).build();

      var cfDropCheckoutPayment = CFDropCheckoutPaymentBuilder()
          .setSession(session)
          .setPaymentComponent(paymentComponent)
          .setTheme(theme)
          .build();

      _cfPaymentGatewayService.doPayment(cfDropCheckoutPayment);
    } on CFException catch (e) {
      print(e.message);
    }
  }

  Future<void> savePaymentHistory(String status, String paymentId) async {
    String date = DateFormat('dd-MM-yyyy').format(DateTime.now());
    String time = DateFormat('kk:mm').format(DateTime.now());

    CollectionReference paymentHistoryCollection =
        FirebaseFirestore.instance.collection('paymentHistory');
 Map<String, dynamic> paymentData = {
      'userId': currentUid,
      'status': status,
      'paymentId': paymentId,
      'amount': widget.amount+40+(widget.bookName.length*100),
      'bookName': widget.bookName,
      'date': date,
      'time': time,
      'type':"rent",
      'address':addressController.text.trim()
    };

    try {
      await paymentHistoryCollection.add(paymentData);
    } catch (e) {
      // Handle errors here
    }
  }

  void handleCFPaymentSuccess(String orderId) {
    savePaymentHistory('Success', orderId);
    Fluttertoast.showToast(
        msg: "Cashfree Payment Successful for Order ID: $orderId",
        toastLength: Toast.LENGTH_SHORT);
  }

  void handleCFPaymentError(CFErrorResponse errorResponse, String orderId) {
    savePaymentHistory('Failure', orderId);
    Fluttertoast.showToast(
        msg: "Cashfree Payment Failed for Order ID: $orderId",
        toastLength: Toast.LENGTH_SHORT);
  }

  @override
  void dispose() {
    super.dispose();
  
  }

 Future<List<Map<String, dynamic>>> getPaymentHistory() async {
  try {
    // Access the 'paymentHistory' collection in Firestore
    CollectionReference payments = FirebaseFirestore.instance.collection('paymentHistory');
    
    // Fetch all documents from the collection
    QuerySnapshot snapshot = await payments.get();
    
    // Convert the snapshot data to a List<Map<String, dynamic>>
    List<Map<String, dynamic>> paymentHistoryList = snapshot.docs.map((doc) {
      return doc.data() as Map<String, dynamic>; // Convert each document's data to Map
    }).toList();

    return paymentHistoryList;
  } catch (e) {
    print('Error fetching payment history: $e');
    return [];
  }
}

 
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('CashFree Payment Rent'),
        actions: [
          IconButton(
            icon: const Icon(Icons.history),
            onPressed: () async {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => PaymentHistoryScreen(
                    currentUserId: currentUid,
                  ),
                ),
              );
            },
          ),
        ],
      ),
      floatingActionButtonLocation:
          FloatingActionButtonLocation.miniCenterFloat,
      floatingActionButton: GestureDetector(
          onTap: openCashfreeCheckout,
          child: Container(
            width: 200,
            height: 40,
            alignment: Alignment.center,
            decoration: const BoxDecoration(
                borderRadius: BorderRadius.all(Radius.circular(20)),
                color: Color.fromARGB(255, 185, 27, 233)),
            child: Text(
              "Pay ₹${widget.amount+40+(widget.bookName.length*100)}",
              style: const TextStyle(fontSize: 20, color: Colors.white),
            ),
          )),
      body: Padding(
        padding: const EdgeInsets.symmetric(vertical: 60, horizontal: 10),
        child: SingleChildScrollView(
          child: Column(
            children: [
              Container(
                //height: 250,
                width: 400,
                decoration: BoxDecoration(
                    color: const Color.fromARGB(255, 232, 222, 242),
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: const [
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
                        const SizedBox(width: 30),
                        const Text(
                          'Book Name : ',
                          style: TextStyle(fontSize: 20),
                        ),
                        const SizedBox(height: 10),
                        SizedBox(
                          // height:60,
                          width: 150,
                          child: Text(
                            widget.bookName.join(','),
                            textAlign: TextAlign.justify,
                            style: const TextStyle(
                                fontSize: 18, fontWeight: FontWeight.bold),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),
                    Row(
                      children: [
                        const SizedBox(width: 30),
                        const Text(
                          'Date : ',
                          style: TextStyle(fontSize: 20),
                        ),
                        const SizedBox(height: 10),
                        Text(
                          DateFormat('dd-MM-yyyy').format(_currentDateTime),
                          style: const TextStyle(
                              fontSize: 18, fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),
                    Row(
                      children: [
                        const SizedBox(width: 30),
                        const Text(
                          'Time :',
                          style: TextStyle(fontSize: 20),
                        ),
                        const SizedBox(height: 10),
                        Text(
                          DateFormat('kk:mm').format(_currentDateTime),
                          style: const TextStyle(
                              fontSize: 18, fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),
                    const Row(
                      children: [
                        SizedBox(width: 30),
                        Text(
                          'Delivery Charges :',
                          style: TextStyle(fontSize: 20),
                        ),
                        SizedBox(height: 10),
                        Text(
                          "₹40",
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 18),
                        )
                      ],
                    ),
                    const SizedBox(height: 20),
                    Row(
                      children: [
                        const SizedBox(width: 30),
                        const Text(
                          'Deposite (₹100 per book) :',
                          style: TextStyle(fontSize: 20),
                        ),
                        const SizedBox(height: 10),
                        Text(
                          "₹${widget.bookName.length*100}",
                          style: const TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 18),
                        )
                      ],
                    ),
                    const SizedBox(height: 20),
                    Row(
                      children: [
                        const SizedBox(width: 30),
                        const Text(
                          'Total amount :',
                          style: TextStyle(fontSize: 20),
                        ),
                        const SizedBox(height: 10),
                        Text(
                          "₹${widget.amount+40+(widget.bookName.length*100)}",
                          style: const TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 18),
                        )
                      ],
                    ),
                    const SizedBox(height: 10),
                     const Padding(
                      padding: EdgeInsets.only(left: 30.0),
                      child:  Text(
                            'Enter Address :',
                            style: TextStyle(fontSize: 20),
                          ),
                    ),
                        const SizedBox(height: 10),
                    addressTextField(),
                     const SizedBox(height: 10),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
   Padding addressTextField() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: TextField(
        controller: addressController,
        decoration: InputDecoration(
          contentPadding: EdgeInsets.symmetric(horizontal: 20, vertical: 20),
          labelText: 'Enter Address',
          labelStyle: TextStyle(fontSize: 17, color: Colors.grey.shade500),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: BorderSide(width: 2, color: Colors.black),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: BorderSide(width: 2, color: Colors.black),
          ),
          
        ),
      ),
    );
  }
}


