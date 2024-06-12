import 'package:flutter/material.dart';

class PrivacyPolicyPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Privacy Policy'),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              children: [
                SizedBox(
                  height: 20,
                ),
                Container(
                  child: Text(
                    "Welcome to Movison. This Privacy Policy is designed to help you understand how we collect, use, and safeguard your personal information when you use our mobile application and services.",
                    textAlign: TextAlign.justify,
                  ),
                ),
                SizedBox(
                  height: 20,
                ),
                Text(
                  "Information We Collect",
                  style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
                ),
                SizedBox(
                  height: 20,
                ),
                Container(
                  child: Text(
                    "1. Personal Information:\n"
                    "   - Types of Data Collected:\n"
                    "     - Name\n"
                    "     - Address\n"
                    "     - Identification documents (for verification purposes)\n"
                    "     - Contact information, including email address and phone number\n"
                    "     - Payment information (credit card details, etc.)\n\n"
                    "2. Usage Data:\n"
                    "   - We may also collect information on how the application is accessed and used ('Usage Data'). This Usage Data may include information such as your device's Internet Protocol address (e.g., IP address), device type, browser type, the pages of our application that you visit, the time and date of your visit, the time spent on those pages, unique device identifiers, and other diagnostic data.",
                    textAlign: TextAlign.justify,
                  ),
                ),
                SizedBox(
                  height: 20,
                ),
                Text(
                  "Use of Data",
                  style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
                ),
                SizedBox(
                  height: 20,
                ),
                Container(
                  child: Text(
                    "We use the collected data for various purposes, including:\n"
                    "- To provide and maintain our application.\n"
                    "- To process payments and deliver products you have purchased.\n"
                    "- To notify you about changes to our application.\n"
                    "- To provide customer support.\n"
                    "- To monitor the usage of our application.\n"
                    "- To detect, prevent and address technical issues.",
                    textAlign: TextAlign.justify,
                  ),
                ),
                SizedBox(
                  height: 20,
                ),
                Text(
                  "Disclosure of Data",
                  style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
                ),
                SizedBox(
                  height: 20,
                ),
                Container(
                  child: Text(
                    "We may disclose your personal data:\n"
                    "- As required by law.\n"
                    "- To comply with legal obligations.\n"
                    "- To protect and defend our rights or property.",
                    textAlign: TextAlign.justify,
                  ),
                ),
                SizedBox(
                  height: 20,
                ),
                Text(
                  "Security",
                  style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
                ),
                SizedBox(
                  height: 20,
                ),
                Container(
                  child: Text(
                    "The security of your data is important to us, but remember that no method of transmission over the Internet, or method of electronic storage is 100% secure.",
                    textAlign: TextAlign.justify,
                  ),
                ),
                SizedBox(
                  height: 20,
                ),
                Text(
                  "Contact Us",
                  style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
                ),
                SizedBox(
                  height: 10,
                ),
                Container(
                  child: Text(
                    "By email: krishakfarma@gmail.com",
                    textAlign: TextAlign.justify,
                  ),
                ),
                SizedBox(
                  height: 5,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
