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
        title: Text('College Information'),
      ),
      body: _buildBody(),
    );
  }
  String? _univercityValue = null;
  String? _branchValue = null;
  String? _semesterValue = null;

  Widget _buildBody() {
    return Padding(
      padding: const EdgeInsets.all(30),
      child: Column(
        children: [
          Row(
            children: [
              const Text("Select University : ",
                style: TextStyle(
                  fontWeight: FontWeight.w400,
                  fontSize: 20
                ),
              ),
              DropdownButton<String>(
               hint: const Text("Select"),
               alignment: AlignmentDirectional.center,
               value: _univercityValue,
               onChanged: (String? newValue) {
                 setState(() {
                   _univercityValue = newValue!;
                 });
               },
               items: <String>['SPPU', 'Mumbai', 'BATU', 'Other']
                   .map<DropdownMenuItem<String>>((String value) {
                 return DropdownMenuItem<String>(
                   value: value,
                   child: Text(value),
                 );
               }).toList(),
             ),
            ],
          ),

          Row(
            children: [
              const Text("Select Branch : ",
                style: TextStyle(
                  fontWeight: FontWeight.w400,
                  fontSize: 20
                ),
              ),
              DropdownButton<String>(
               hint: const Text("Select"),
               alignment: AlignmentDirectional.center,
               value: _branchValue,
               onChanged: (String? newValue) {
                 setState(() {
                   _branchValue = newValue!;
                 });
               },
               items: <String>['CS', 'IT', 'ENTC', 'Mec', 'Civil']
                   .map<DropdownMenuItem<String>>((String value) {
                 return DropdownMenuItem<String>(
                   value: value,
                   child: Text(value),
                 );
               }).toList(),
             ),
            ],
          ),
          Row(
            children: [
              const Text("Select Semester : ",
                style: TextStyle(
                  fontWeight: FontWeight.w400,
                  fontSize: 20
                ),
              ),
              DropdownButton<String>(
               hint: const Text("Select"),
               alignment: AlignmentDirectional.center,
               value: _semesterValue,
               onChanged: (String? newValue) {
                 setState(() {
                   _semesterValue = newValue!;
                 });
               },
               items: <String>['I', 'II', 'III', 'IV', 'V', 'VI', 'VII', 'VIII']
                   .map<DropdownMenuItem<String>>((String value) {
                 return DropdownMenuItem<String>(
                   value: value,
                   child: Text(value),
                 );
               }).toList(),
             ),
            ],
          ),
          
        ],
      ),
    );
  }
}