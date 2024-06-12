import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:movison/widgets/mycart.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';

class RazorpayPayment extends StatefulWidget {
  // ignore: prefer_typing_uninitialized_variables
  final amount;
  RazorpayPayment(this.amount,{super.key});

  @override
  State createState() => RazorpayPaymentState();
}

class RazorpayPaymentState extends State {
  late Razorpay _razorpay;
  TextEditingController amtController = TextEditingController();

  void openCheckout(amount) async {
    amount = amount * 100;

    var options = {
      'key': 'rzp_test_10P5mm0lF565ag',
      'amount': amount,
      'name': 'movison',
      'prefill': {'contact': '1234567890', 'email': 'test@gamil.com'},
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

  void handlePaymentSuccess(PaymentSuccessResponse response) {
    Fluttertoast.showToast(
        msg: "Payment Succesful " + response.paymentId!,
        toastLength: Toast.LENGTH_SHORT);
  }

  void handlePaymentError(PaymentFailureResponse response) {
    Fluttertoast.showToast(
        msg: "Payment Fail " + response.message!,
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

  @override
  void initState() {
    super.initState();
    _razorpay = Razorpay();
    _razorpay.on(Razorpay.EVENT_PAYMENT_SUCCESS, handlePaymentSuccess);
    _razorpay.on(Razorpay.EVENT_PAYMENT_ERROR, handlePaymentError);
    _razorpay.on(Razorpay.EVENT_EXTERNAL_WALLET, handleExternalWallet);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[800],
      body: Center(
        child: Column(
                children: [
                  const SizedBox(
                    height: 40,
                  ),
        const Text(
          "Welcome to Razorpay",
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
          textAlign: TextAlign.center,
        ),
        const SizedBox(
          height: 30,
        ),
        Padding(
          padding: EdgeInsets.all(10),
          child: TextFormField(
            decoration: InputDecoration(
                labelText: "Amount to be paid",
                border: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.white, width: 1.0),
                ),
                enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.white, width: 1.0)),
                errorStyle: TextStyle(color: Colors.redAccent, fontSize: 15)),
            controller: amtController,
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'select a book';
              }
              return null;
            },
          ),
        ),
        SizedBox(
          height: 30,
        ),
        ElevatedButton(
            onPressed: () {
              if (amtController.text.toString().isNotEmpty) {
                setState(() {
                  int amount = ProductDetailScreenState().getAmount();
                  openCheckout(amount);
                });
              }
            },
            child: Padding(
              padding: EdgeInsets.all(10),
              child: Text("Make Payment"),
              ))
                ],
              ),
      ),
    );
  }
}
