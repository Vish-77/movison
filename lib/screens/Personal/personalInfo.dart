import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:movison/screens/MobileAuth/authprovider.dart'
    as MovisonAuthProvider; // Use an alias

import 'package:movison/screens/MobileAuth/usermodel.dart';
import 'package:movison/theme/color.dart';
import 'package:provider/provider.dart';

class PersonalInfo extends StatefulWidget {
  const PersonalInfo({Key? key}) : super(key: key);

  @override
  _PersonalInfo createState() => _PersonalInfo();
}

class _PersonalInfo extends State<PersonalInfo> {
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
        title: Text('Personal Information'),
      ),
      body: Center(child: _buildBody()),
    );
  }

  Widget _buildBody() {
    return SingleChildScrollView(
      padding: EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        children: [
          const SizedBox(
            height: 30,
          ),
          _buildSection1(),
          const SizedBox(
            height: 20,
          ),
        ],
      ),
    );
  }


  Widget _buildSection1() {
    return Container(
      padding: const EdgeInsets.only(left: 10),
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
      child: Column(
        children: [
          const SizedBox(
            height: 20,
          ),
          if (u != null) ...[
            if (u != null) ...[
              Row(
                children: [
                  Text(
                    "Name : ",
                    style: GoogleFonts.lato(
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                    ),
                  ),
                  Text(
                    u!.name,
                    style: GoogleFonts.lato(
                      fontWeight: FontWeight.w500,
                      fontSize: 18,
                    ),
                  ),
                ],
              ),
            ] else ...[
              // Handle the case when u or u.name is null
              Text("User name not available"),
            ],
            const SizedBox(
              height: 20,
            ),
            if (u != null) ...[
              Row(
                children: [
                  Text(
                    "Email : ",
                    style: GoogleFonts.lato(
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                    ),
                  ),
                  SizedBox(
                    height:60,
                    width:200,
                    child: Text(
                      u!.email,
                      textAlign: TextAlign.justify,
                      style: GoogleFonts.lato(
                        fontWeight: FontWeight.w500,
                        color: Colors.blue,
                        fontSize: 18,
                      ),
                    ),
                  ),
                ],
              ),
            ] else ...[
              // Handle the case when u or u.name is null
              Text("User email not available"),
            ],
            const SizedBox(
              height: 20,
            ),
            if (u != null) ...[
              Row(
                children: [
                  Text(
                    "Phone No : ",
                    style: GoogleFonts.lato(
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                    ),
                  ),
                  Text(
                    u!.phoneNumber,
                    style: GoogleFonts.lato(
                      fontWeight: FontWeight.w500,
                      fontSize: 18,
                    ),
                  ),
                ],
              ),
            ] else ...[
              // Handle the case when u or u.name is null
              Text("User pnone number not available"),
            ],
          ] else ...[
            // Handle the case when u is null
            Text("Loading user data..."),
          ],
          const SizedBox(
            height: 20,
          ),
          Row(
                children: [
                  Text(
                    "Bio : ",
                    style: GoogleFonts.lato(
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                    ),
                  ),
                  Text(
                    u!.bio,
                    style: GoogleFonts.lato(
                      fontWeight: FontWeight.w500,
                      fontSize: 18,
                    ),
                  ),
                ],
              ),
              const SizedBox(
                height: 20,
              )
        ],
      ),
    );
  }

  Widget _buildDivider() {
    return Padding(
      padding: const EdgeInsets.only(left: 45),
      child: Divider(
        height: 0,
        color: Colors.grey.withOpacity(0.8),
      ),
    );
  }
}
