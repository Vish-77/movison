import 'dart:io';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:movison/screens/Home/HomeScreen.dart';
import 'package:movison/screens/MobileAuth/authprovider.dart';
import 'package:movison/screens/MobileAuth/custom_button_in_mobile_auth.dart';
import 'package:movison/screens/MobileAuth/snackbar.dart';
import 'package:movison/screens/MobileAuth/usermodel.dart';
import 'package:movison/widgets/custom_surfix_icon.dart';

import 'package:provider/provider.dart';

class UserInfromationScreen extends StatefulWidget {
  const UserInfromationScreen({super.key});

  @override
  State<UserInfromationScreen> createState() => _UserInfromationScreenState();
}

class _UserInfromationScreenState extends State<UserInfromationScreen> {
  
  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final bioController = TextEditingController();

  @override
  void dispose() {
    super.dispose();
    nameController.dispose();
    emailController.dispose();
    bioController.dispose();
  }


  @override
  Widget build(BuildContext context) {
    final isLoading = Provider.of<AuthProvider>(context, listen: true).isLoading;
    return Scaffold(
      body: SafeArea(
        child: isLoading == true
            ? const Center(
                child: CircularProgressIndicator(
                  color: Colors.purple,
                ),
              )
            : SingleChildScrollView(
                padding:
                    const EdgeInsets.symmetric(vertical: 25.0, horizontal: 5.0),
                child: Center(
                  child: Column(
                    children: [
                      Container(
                        width: MediaQuery.of(context).size.width,
                        padding: const EdgeInsets.symmetric(
                            vertical: 5, horizontal: 15),
                        margin: const EdgeInsets.only(top: 20),
                        child: Column(
                          children: [
                            // name field
                            // textFeld(
                            //   hintText: "Siddhant Hole",
                            //   icon: Icons.account_circle,
                            //   inputType: TextInputType.name,
                            //   maxLines: 1,
                            //   controller: nameController,
                            // ),
                            nameTextField(),
                            SizedBox(height: 30),

                            // email
                            EmailTextField(),
                            

                          ],
                        ),
                      ),
                      const SizedBox(height: 20),
                      SizedBox(
                        height: 50,
                        width: MediaQuery.of(context).size.width * 0.90,
                        child: CustomButton(
                          text: "Continue",
                          onPressed: () => storeData(),
                        ),
                      )
                    ],
                  ),
                ),
              ),
      ),
    );
  }

Padding nameTextField() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: TextField(
        controller: nameController,
        decoration: InputDecoration(
          contentPadding: EdgeInsets.symmetric(horizontal: 15, vertical: 15),
          labelText: 'Enter Student name',
          labelStyle: TextStyle(fontSize: 17, color: Colors.grey.shade500),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: BorderSide(width: 2, color: Color(0xffC5C5C5)),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: BorderSide(width: 2, color: Colors.black),
          ),
          suffixIcon: CustomSurffixIcon(svgIcon: "assets/icons/profile2.svg"),
        ),
      ),
    );
  }


Padding EmailTextField() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: TextField(
        controller: emailController,
        decoration: InputDecoration(
          contentPadding: EdgeInsets.symmetric(horizontal: 20, vertical: 20),
          labelText: 'Enter Email',
          labelStyle: TextStyle(fontSize: 17, color: Colors.grey.shade500),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: BorderSide(width: 2, color: Color(0xffC5C5C5)),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: BorderSide(width: 2, color: Colors.black),
          ),
          suffixIcon: CustomSurffixIcon(svgIcon: "assets/icons/email_box1.svg"),
        ),
      ),
    );
  }
  

  // store user data to database
void storeData() async {
  final ap = Provider.of<AuthProvider>(context, listen: false);

  // Check if the name field is not empty
  if (nameController.text.trim().isNotEmpty) {
    final now = DateTime.now();
    final formattedDate = DateFormat("dd-MM-yyyy").format(now);
    UserModel userModel = UserModel(
      name: nameController.text.trim(),
      email: emailController.text.trim(),
      createdAt: formattedDate,
      phoneNumber: ap.uid,
      uid: ap.uid,
    );

    ap.saveUserDataToFirebase(
      context: context,
      userModel: userModel,
      onSuccess: () {
        ap.saveUserDataToSP().then(
          (value) => ap.setSignIn().then(
            (value) => Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(
                builder: (context) => HomeScreen(),
              ),
              (route) => false,
            ),
          ),
        );
      },
    );
  } else {
    showSnackBar(context, "Please Enter Your name");
  }
}
}