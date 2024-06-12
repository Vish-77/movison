import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class BooksRent extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Books Rent'),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance.collection('BooksRent').limit(50).snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return CircularProgressIndicator(); // Show a loading indicator while fetching data.
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return Center(child: Text("No data available"));
          } else {
            return ListView.builder(
              itemCount: snapshot.data!.docs.length,
              itemBuilder: (context, index) {
                final data = snapshot.data!.docs[index].data() as Map<String, dynamic>;
                return buildMarketItem(data);
              },
            );
          }
        },
      ),
    );
  }
  Widget buildMarketItem(Map<String, dynamic> data) {
    return Table(
      border: TableBorder.all(
        color: Colors.black,
        width: 1.0,
        style: BorderStyle.solid,
        borderRadius: BorderRadius.all(Radius.circular(15)),
      ),
      children: [
        buildRow(['Publication', 'Price Rs/month', 'Location'], isHeader: true),
        buildRow([data['publication'], data['Price'], data['Location']]),
      ],
    );
  }

  TableRow buildRow(List<String> cells, {bool isHeader = false}) {
    final style = TextStyle(
      fontWeight: isHeader ? FontWeight.bold : FontWeight.normal,
      fontSize: isHeader ? 14 : 13,
      color: isHeader ? Colors.black : Colors.black,
    );

    return TableRow(
      children: cells.map((cell) {
        return Padding(
          padding: const EdgeInsets.all(12),
          child: Center(child: Text(cell, style: style)),
        );
      }).toList(),
    );
  }
}
