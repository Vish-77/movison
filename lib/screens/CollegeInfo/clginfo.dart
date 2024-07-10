import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:movison/screens/MobileAuth/authprovider.dart'
    as MovisonAuthProvider; // Use an alias

import 'package:movison/screens/MobileAuth/usermodel.dart';
import 'package:movison/theme/color.dart';
import 'package:provider/provider.dart';

class CollegeInfo extends StatefulWidget {
  const CollegeInfo({Key? key}) : super(key: key);

  @override
  State createState() => _CollegeInfo();
}

class _CollegeInfo extends State<CollegeInfo> {
  UserModel? u;
  bool isUserLoaded = false;

  void getData() async {
    final ap = Provider.of<MovisonAuthProvider.AuthProvider>(context,
        listen: false); // Use the alias

    await ap.getDataFromSP();
    setState(() {
      u = ap.userModel;
      isUserLoaded = true;
    });
  }

  @override
  void initState() {
    super.initState();
    getData();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Color.fromARGB(255, 130, 98, 206),
          title: Text('College Information'),
        ),
        body: Center(
          child: Container(
            width: 300,
            height: 200,
              padding: const EdgeInsets.symmetric(horizontal: 20),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color: Color.fromARGB(255, 232, 222, 242),
                boxShadow: [
                  BoxShadow(
                    color: AppColor.shadowColor.withOpacity(0.1),
                    spreadRadius: 1,
                    blurRadius: 1,
                    offset: Offset(0, 1), // changes position of shadow
                  ),
                ],
              ),
              child: _buildBody()),
        ));
  }

  Widget _buildBody() {
    return Padding(
      padding: const EdgeInsets.all(30),
      child: Column(
        children: [
          Row(
            children: [
              Text(
                "University : ",
                style: GoogleFonts.lato(
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                ),
              ),
              Text(
                u!.univercity,
                style: GoogleFonts.lato(
                  fontWeight: FontWeight.w500,
                  fontSize: 18,
                ),
              ),
            ],
          ),
          const SizedBox(
            height: 10,
          ),
          Row(
            children: [
              Text(
                "Branch : ",
                style: GoogleFonts.lato(
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                ),
              ),
              Text(
                u!.branch,
                style: GoogleFonts.lato(
                  fontWeight: FontWeight.w500,
                  fontSize: 18,
                ),
              ),
            ],
          ),
          const SizedBox(
            height: 10,
          ),
          Row(
            children: [
              Text(
                "Semester : ",
                style: GoogleFonts.lato(
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                ),
              ),
              Text(
                u!.sem,
                style: GoogleFonts.lato(
                  fontWeight: FontWeight.w500,
                  fontSize: 18,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
