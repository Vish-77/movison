import 'dart:convert';
import 'package:googleapis/sheets/v4.dart' as sheets;
import 'package:googleapis_auth/googleapis_auth.dart' as auth;
import 'package:googleapis_auth/auth_io.dart' as aa;

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:url_launcher/url_launcher.dart';

class FirestoreToGoogleSheet extends StatefulWidget {
  @override
  _FirestoreToGoogleSheetState createState() => _FirestoreToGoogleSheetState();
}

class _FirestoreToGoogleSheetState extends State<FirestoreToGoogleSheet> {
  final String _spreadsheetId = '1UdxOY6Jq6esH2zNnNF8MUEHJ6gs2FfmI2uZJ_J0uZm8'; // Replace with your Google Sheet ID
  late sheets.SheetsApi _sheetsApi;
    final String _spreadsheetIdRent = '1xIPiBGZ2q02tTA_pzoLuVOAW_omjVLAQcFA4YBsOV28';

  List<List<dynamic>> _paymentData = [];
  List<List<dynamic>> _paymentDataRent = [];

  @override
  void initState() {
    super.initState();
    _authenticateGoogleAccount();
    _loadPaymentHistory();
    _loadPaymentHistoryRent();
  }

  // Authenticate with Google Sheets API
  Future<void> _authenticateGoogleAccount() async {
    final credentials = await rootBundle.loadString('assets/credentials.json');
    final jsonCredentials = jsonDecode(credentials);

    final clientId = auth.ServiceAccountCredentials.fromJson(jsonCredentials);
    final scopes = [sheets.SheetsApi.spreadsheetsScope];

    final authClient = await aa.clientViaServiceAccount(clientId, scopes);

    setState(() {
      _sheetsApi = sheets.SheetsApi(authClient);
    });
  }

  // Fetch payment history data from Firestore
Future<List<List<dynamic>>> _fetchPaymentHistoryData() async {
  final paymentsCollection = FirebaseFirestore.instance.collection('paymentHistory');
  
  // Add a query to filter documents where type == 'rent'
  final snapshot = await paymentsCollection.where('type', isEqualTo: 'buy').get();
  
  final paymentHistoryList = snapshot.docs.map((doc) {
    final data = doc.data() as Map<String, dynamic>;

    // Handle bookName as a comma-separated string
    final bookNames = (data['bookName'] as List<dynamic>?)?.join(', ') ?? '';

    return [
      data['userId'] ?? '',
      data['status'] ?? '',
      data['paymentId'] ?? '',
      data['amount'] ?? 0,
      bookNames, // Flattened bookName array
      data['date'] ?? '',
      data['time'] ?? '',
      data['address'] ?? ''
    ];
  }).toList();
  
  return paymentHistoryList;
}
Future<List<List<dynamic>>> _fetchPaymentHistoryDataRent() async {
  final paymentsCollection = FirebaseFirestore.instance.collection('paymentHistory');
  
  // Add a query to filter documents where type == 'rent'
  final snapshot = await paymentsCollection.where('type', isEqualTo: 'rent').get();
  
  final paymentHistoryList = snapshot.docs.map((doc) {
    final data = doc.data() as Map<String, dynamic>;

    // Handle bookName as a comma-separated string
    final bookNames = (data['bookName'] as List<dynamic>?)?.join(', ') ?? '';

    return [
      data['userId'] ?? '',
      data['status'] ?? '',
      data['paymentId'] ?? '',
      data['amount'] ?? 0,
      bookNames, // Flattened bookName array
      data['date'] ?? '',
      data['time'] ?? '',
      data['address'] ?? ''
    ];
  }).toList();
  
  return paymentHistoryList;
}


  // Load payment history into state
  Future<void> _loadPaymentHistory() async {
    setState(() {
    });
    final paymentData = await _fetchPaymentHistoryData();
    setState(() {
      _paymentData = paymentData;
    });
  }
   Future<void> _loadPaymentHistoryRent() async {
    setState(() {
    });
    final paymentData = await _fetchPaymentHistoryDataRent();
    setState(() {
      _paymentDataRent = paymentData;
    });
  }

  // Write data to Google Sheets
  Future<void> _writeToGoogleSheet() async {
    final range = 'Sheet1!A1:H${_paymentData.length + 1}'; // Adjust based on your sheet structure

    // Create a value range object
    final valueRange = sheets.ValueRange.fromJson({
      "values": [
        ['User ID', 'Status', 'Payment ID', 'Amount', 'Book Name', 'Date', 'Time', 'Address'], // Header row
        ..._paymentData,
      ]
    });

    // Update the sheet with the data
    await _sheetsApi.spreadsheets.values.update(valueRange, _spreadsheetId, range, valueInputOption: 'RAW');
    print('Data successfully written to Google Sheets!');
  }
  Future<void> _writeToGoogleSheetRent() async {
    final range = 'Sheet1!A1:H${_paymentData.length + 1}'; // Adjust based on your sheet structure

    // Create a value range object
    final valueRange = sheets.ValueRange.fromJson({
      "values": [
        ['User ID', 'Status', 'Payment ID', 'Amount', 'Book Name', 'Date', 'Time', 'Address'], // Header row
        ..._paymentDataRent,
      ]
    });

    // Update the sheet with the data
    await _sheetsApi.spreadsheets.values.update(valueRange, _spreadsheetIdRent, range, valueInputOption: 'RAW');
    print('Data successfully written to Google Sheets!');
  }
  // Open Google Sheet in browser
  Future<void> _openGoogleSheet() async {
    final url = 'https://docs.google.com/spreadsheets/d/$_spreadsheetId';
    if (await canLaunchUrl(Uri.parse(url))) {
      await launchUrl(Uri.parse(url),mode: LaunchMode.externalApplication);
    } else {
      throw 'Could not open the Google Sheet.';
    }
  }
 Future<void> _openGoogleSheetRent() async {
    final url = 'https://docs.google.com/spreadsheets/d/$_spreadsheetIdRent';
    if (await canLaunchUrl(Uri.parse(url))) {
      await launchUrl(Uri.parse(url),mode: LaunchMode.externalApplication);
    } else {
      throw 'Could not open the Google Sheet.';
    }
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Orders"),
      ),
      body: Center(
        child: Row( 
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [ 
            GestureDetector(
              onTap: ()async{
                await _writeToGoogleSheet();
                _openGoogleSheet();
              },
              child: Container( 
                height: 150,
                width: 150,
                alignment: Alignment.center,
                decoration: BoxDecoration( 
                  borderRadius: BorderRadius.all(Radius.circular(20)),
                  color: Colors.blue
                ),
                child: Text("Orders For Buy",style: TextStyle(color: Colors.white),),
              ),
            ),
             GestureDetector(
              onTap: ()async{
                await _writeToGoogleSheetRent();
                _openGoogleSheetRent();
              },
               child: Container( 
                height: 150,
                width: 150,
                alignment: Alignment.center,
                decoration: BoxDecoration( 
                  borderRadius: BorderRadius.all(Radius.circular(20)),
                  color: Colors.black
                ),
                child: Text("Orders For Rent",style: TextStyle(color: Colors.white),),
                           ),
             ),
          ],
        ),
      ),
     
    );
  }
}
