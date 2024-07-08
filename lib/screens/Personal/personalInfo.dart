import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:movison/screens/MobileAuth/authprovider.dart'
    as MovisonAuthProvider; // Use an alias

import 'package:movison/screens/MobileAuth/mobile_register.dart';
import 'package:movison/screens/MobileAuth/usermodel.dart';
import 'package:movison/screens/Privacy/privacypolicy.dart';
import 'package:movison/theme/color.dart';
import 'package:movison/utils/data.dart';
import 'package:movison/widgets/custom_image.dart';
import 'package:movison/widgets/profile_pic.dart';
import 'package:movison/widgets/setting_box.dart';
import 'package:movison/widgets/setting_item.dart';
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
      print(u!.email);
      print(u!.name);
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
        title: Text('Personal Information'),
      ),
      body: _buildBody(),
    );
  }

  Widget _buildBody() {
    return SingleChildScrollView(
      padding: EdgeInsets.symmetric(horizontal: 15),
      child: Column(
        children: [
          const SizedBox(
            height: 30,
          ),
          _buildSection1(),
          const SizedBox(
            height: 20,
          ),
          _buildProfile(),
        ],
      ),
    );
  }

  Widget _buildProfile() {
    return Column(
      children: [
        CircleAvatar(
          child: Image.network(u!.profilePic),
          radius: 60
        ),
        const SizedBox(
          height: 10,
        ),
      ],
    );
  }

  Widget _buildSection1() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 15),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(5),
        color: AppColor.cardColor,
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
          if (u != null) ...[
            if (u != null && u!.name != null) ...[
              Text(
                u!.name!,
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w400,
                ),
              ),
            ] else ...[
              // Handle the case when u or u.name is null
              Text("User name not available"),
            ],
            _buildDivider(),
            if (u != null && u!.name != null) ...[
              Text(
                u!.email,
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w400,
                ),
              ),
            ] else ...[
              // Handle the case when u or u.name is null
              Text("User email not available"),
            ],
            _buildDivider(),
            if (u != null && u!.name != null) ...[
              Text(
                u!.phoneNumber,
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w400,
                ),
              ),
            ] else ...[
              // Handle the case when u or u.name is null
              Text("User pnone number not available"),
            ],
          ] else ...[
            // Handle the case when u is null
            Text("Loading user data..."),
          ],
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