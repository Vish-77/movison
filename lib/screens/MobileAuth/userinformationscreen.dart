import 'dart:io';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
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
  File? image;
  File? aadhr;
  File? pan;
  File? collegeId;
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
void selectImage() async {
    image = await pickImage(context);
    setState(() {});
  }

  void selectAadharImage() async {
    aadhr = await pickImage(context);
    setState(() {});
  }
  void selectPanImage() async {
    pan = await pickImage(context);
    setState(() {});
  }
  void selectIdImage() async {
    collegeId = await pickImage(context);
    setState(() {});
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
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("Upload Profile Photo *",style: GoogleFonts.inter( 
                          fontSize: 15,
                          fontWeight: FontWeight.w600,
                      ),),
                      Center(
                        child: InkWell(
                          onTap: () => selectImage(),
                          child: image == null
                              ? Container( 
                                height: 100,
                                width: 250,
                                decoration: BoxDecoration( 
                                  borderRadius: BorderRadius.all(Radius.circular(20)),
                                  border: Border.all(width: .8),
                                ),
                                child: Icon(Icons.account_circle,size: 50,),
                              )
                              : CircleAvatar(
                                  backgroundImage: FileImage(image!),
                                  radius: 50,
                                ),
                        ),
                      ),
                      Text("Upload Aadhar Card Photo *",style: GoogleFonts.inter( 
                          fontSize: 15,
                          fontWeight: FontWeight.w600,
                      ),),
                       Center(
                         child: InkWell(
                          onTap: () => selectAadharImage(),
                          child: aadhr == null
                              ? Container( 
                                  height: 100,
                                  width: 250,
                                  decoration: BoxDecoration( 
                                    borderRadius: BorderRadius.all(Radius.circular(20)),
                                    border: Border.all(width: .8),
                                  ),
                                  child: Icon(Icons.file_copy,size: 50,),
                                )
                              : Container( 
                                  height: 100,
                                  width: 250,
                                  decoration: BoxDecoration( 
                                    borderRadius: BorderRadius.all(Radius.circular(20)),
                                    border: Border.all(width: .8),
                                  ),
                                  child: ClipRRect(
                        borderRadius: BorderRadius.all(Radius.circular(20)),
                        child: Image(
                          image: FileImage(aadhr!),
                          fit: BoxFit.fill,)
                      )
                                )
                                               ),
                       ),
                       Text("Upload Pan Card",style: GoogleFonts.inter( 
                          fontSize: 15,
                          fontWeight: FontWeight.w600,
                      ),),
                       Center(
                         child: InkWell(
                          onTap: () => selectPanImage(),
                          child: pan == null
                              ? Container( 
                                  height: 100,
                                  width: 250,
                                  decoration: BoxDecoration( 
                                    borderRadius: BorderRadius.all(Radius.circular(20)),
                                    border: Border.all(width: .8),
                                  ),
                                  child: Icon(Icons.file_copy,size: 50,),
                                )
                              : Container( 
                                  height: 100,
                                  width: 250,
                                  decoration: BoxDecoration( 
                                    borderRadius: BorderRadius.all(Radius.circular(20)),
                                    border: Border.all(width: .8),
                                  ),
                                  child: ClipRRect(
                        borderRadius: BorderRadius.all(Radius.circular(20)),
                        child: Image(
                          image: FileImage(pan!),
                          fit: BoxFit.fill,)
                      )
                                )
                                               ),
                       ),
                      Text("Upload CollegeId*",style: GoogleFonts.inter( 
                          fontSize: 15,
                          fontWeight: FontWeight.w600,
                      ),),
                       Center(
                         child: InkWell(
                          onTap: () => selectIdImage(),
                          child: collegeId == null
                              ? Container( 
                                  height: 100,
                                  width: 250,
                                  decoration: BoxDecoration( 
                                    borderRadius: BorderRadius.all(Radius.circular(20)),
                                    border: Border.all(width: .8),
                                  ),
                                  child: Icon(Icons.file_copy,size: 50,),
                                )
                              :Container( 
                                  height: 100,
                                  width: 250,
                                  decoration: BoxDecoration( 
                                    borderRadius: BorderRadius.all(Radius.circular(20)),
                                    border: Border.all(width: .8),
                                  ),
                                  child: ClipRRect(
                        borderRadius: BorderRadius.all(Radius.circular(20)),
                        child: Image(
                          image: FileImage(collegeId!),
                          fit: BoxFit.fill,)
                      )
                                )
                                               ),
                       ),
                       Text("Enter Student Name *",style: GoogleFonts.inter( 
                          fontSize: 15,
                          fontWeight: FontWeight.w600,
                      ),),
                      Container(
                        width: MediaQuery.of(context).size.width,
                        
                        margin: const EdgeInsets.only(top: 20),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
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
                            SizedBox(height: 10),
                  
                            // email
                            Text("Enter Student Email *",style: GoogleFonts.inter( 
                          fontSize: 15,
                          fontWeight: FontWeight.w600,
                      ),),
                      SizedBox(height: 10),
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
    UserModel userModel = UserModel(
      name: nameController.text.trim(),
      email: emailController.text.trim(),
      bio: bioController.text.trim(),
      profilePic: "",
      createdAt: "",
      phoneNumber: "",
      uid: "",
      univercity: '',
      branch: '',
      sem: '',
      aadharPic: '',
      panPic: '',
      collegeIdPic: '',

    );
    if (image != null && aadhr !=null && collegeId != null && nameController.text.isNotEmpty && emailController.text.isNotEmpty) {
      ap.saveUserDataToFirebase(
        context: context,
        userModel: userModel,
        profilePic: image!,
        aadharPic:aadhr!,
        panPic:pan!,
        collegeIdPic:collegeId!,
        onSuccess: () {
          ap.saveUserDataToSP().then(
                (value) => ap.setSignIn().then(
                      (value) => Navigator.pushAndRemoveUntil(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const HomeScreen(),
                          ),
                          (route) => false),
                    ),
              );
        },
      );
    } else {
      showSnackBar(context, "Please upload required (*) documents");
    }
  }
}