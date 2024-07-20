import 'dart:io';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:movison/screens/MobileAuth/authprovider.dart';
import 'package:movison/screens/MobileAuth/authprovider.dart' as movison_authProvider;
import 'package:movison/screens/MobileAuth/usermodel.dart';
import 'package:movison/theme/color.dart';
import 'package:provider/provider.dart';

class EditProfileScreen extends StatefulWidget {
  const EditProfileScreen({Key? key}) : super(key: key);

  @override
  _EditProfileScreenState createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  late TextEditingController _nameController;
  late TextEditingController? _emailController ;
  late TextEditingController? _mobileController;
 
  File? _image;
  File? _aadharFront;
  File? _aadharBack;
  File? _pan;
  File? _collegeIdFront;
  File? _collegeIdBack;
  UserModel? u;
  bool isUserLoaded = false;
  bool isSubmitting=false;
   Future<void> getData() async {
    final ap = Provider.of<movison_authProvider.AuthProvider>(context,
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
    AuthProvider authProvider =
        Provider.of<AuthProvider>(context, listen: false);
    _nameController = TextEditingController(text: authProvider.userModel.name);
    _emailController=TextEditingController(text: authProvider.userModel.email);
    _mobileController=TextEditingController(text: authProvider.userModel.phoneNumber);
  }

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  Future<void> _getImageFromGallery() async {
    final pickedFile =
        await ImagePicker().pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      setState(() {
        _image = File(pickedFile.path);
      });
    }
  }
  Future<void> _getAadharFrontImageFromGallery() async {
    final pickedFile =
        await ImagePicker().pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      setState(() {
        _aadharFront = File(pickedFile.path);
      });
    }
  }
   Future<void> _getAadharBackImageFromGallery() async {
    final pickedFile =
        await ImagePicker().pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      setState(() {
        _aadharBack = File(pickedFile.path);
      });
    }
  }
     Future<void> _getaPanImageFromGallery() async {
    final pickedFile =
        await ImagePicker().pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      setState(() {
        _pan = File(pickedFile.path);
      });
    }
  }
     Future<void> _getCollegeIdFrontImageFromGallery() async {
    final pickedFile =
        await ImagePicker().pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      setState(() {
        _collegeIdFront = File(pickedFile.path);
      });
    }
  }
     Future<void> _getCollegeIdBankImageFromGallery() async {
    final pickedFile =
        await ImagePicker().pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      setState(() {
        _collegeIdBack = File(pickedFile.path);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    AuthProvider authProvider = Provider.of<AuthProvider>(context);
    
    return Scaffold(
      resizeToAvoidBottomInset: true,
      appBar:AppBar(
              // backgroundColor: const Color.fromARGB(255, 84, 84, 84),

              centerTitle: true,
              title: Text(
                "Edit Profile",
                style: GoogleFonts.ubuntu(
                  fontWeight: FontWeight.w700,
                  fontSize: 20,
                ),
              ),
            ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 50),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 10),
            GestureDetector(
                onTap: () {
                  _getImageFromGallery();
                },
                child: Center(
                  child: Container(
                    height: 100,
                    width: 100,
                    decoration: BoxDecoration( 
                      borderRadius: BorderRadius.all(Radius.circular(100))
                    ),
                    
                    // backgroundColor: Colors.orange,
                    child: _image==null ?ClipRRect(
                      borderRadius:const BorderRadius.all(Radius.circular(100)),
                      child: Image.network(
                          authProvider.userModel.profilePic,
                          fit: BoxFit.fill,
                        ),
                    ):ClipRRect(
                      borderRadius:const BorderRadius.all(Radius.circular(100)),child:Image.file(_image!,fit: BoxFit.fill,)),
                  ),
                ),
              ),
            Text(
              "Name",
              style: GoogleFonts.lato(
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            ),
            const SizedBox(height: 7),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              height: 45,
              width: 300,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                border: Border.all(width: 1.5),
              ),
              child: TextFormField(
                controller: _nameController,
                decoration: const InputDecoration(border: InputBorder.none),
              ),
            ),
            const SizedBox(height: 15),
            Text(
              "Email",
              style: GoogleFonts.lato(
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            ),
            const SizedBox(height: 7),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              height: 45,
              width: 300,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                border: Border.all(width: 1.5),
              ),
              child: TextFormField(
                controller: _emailController,
                decoration: const InputDecoration(border: InputBorder.none),
              ),
            ),
            const SizedBox(
              height: 15,
            ),
            Text(
              "Mobile Number",
              style: GoogleFonts.lato(
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            ),
            const SizedBox(height: 7),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              height: 45,
              width: 300,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(width: 1.5)),
              child: TextFormField(
                controller: _mobileController,
                keyboardType: TextInputType.phone,
                decoration: const InputDecoration(border: InputBorder.none),
                onChanged: (value) {
    setState(() {
      _mobileController!.text = value;
      if (value.length == 13) {
        FocusScope.of(context).unfocus();
      }
    });
  },
              ),
            ),
            const SizedBox(height: 20),
            _buildSection2(),
            const SizedBox(height: 30,),
             Center(
              child: GestureDetector(
                onTap: () async {
                  setState(() {
                    isSubmitting = true; // Set loading to true
                  });

                  await authProvider.updateProfile(
                      context, _nameController.text, _emailController?.text, _image, _aadharBack, _aadharFront, _pan, _collegeIdBack, _collegeIdFront);
                 
                  setState(() {
                    isSubmitting = false; 
                    Navigator.pop(context);// Set loading to false
                  });

                  
                },
                child: Container(
                  height: 40,
                  width: 100,
                  decoration: const BoxDecoration(
                      color: Colors.orange,
                      borderRadius: BorderRadius.all(Radius.circular(20))),
                  child: Center(
                    child: isSubmitting
                        ? const CircularProgressIndicator(
                            color: Colors.white,
                          )
                        : Text(
                            "Submit",
                            style: GoogleFonts.aDLaMDisplay(
                              fontWeight: FontWeight.w500,
                              fontSize: 16,
                            ),
                          ),
                  ),
                ),
              ),
            ),

             const SizedBox(height: 30,),
          ],
        ),
      ),
    );
  }
Widget _buildSection2() {
    return Container(
      padding: const EdgeInsets.only(left: 2),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: const Color.fromARGB(255, 232, 222, 242),
        boxShadow: [
          BoxShadow(
            color: AppColor.shadowColor.withOpacity(0.1),
            spreadRadius: 1,
            blurRadius: 1,
            offset: const Offset(0, 1), // changes position of shadow
          ),
        ],
      ),
      child: Column(
        children: [
          const SizedBox(
            height: 20,
          ),
          if (isUserLoaded && u != null) ...[
            Center(
              child: Text(
                "Personal Details:",
                style: GoogleFonts.lato(
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                ),
              ),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Adhar Front : ",
                  style: GoogleFonts.lato(
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
                GestureDetector(
                onTap: () {
                  _getAadharFrontImageFromGallery();
                },
                child: _aadharFront==null? Container(
                  height: 200,
                  width: 300,
                  decoration: BoxDecoration(
                      borderRadius:
                          const BorderRadius.all(Radius.circular(20)),
                      border: Border.all(width: 1.5)),
                  child: ClipRRect(
                      borderRadius:
                          const BorderRadius.all(Radius.circular(20)),
                      child: Image.network(
                        u!.aadharFront,
                        fit: BoxFit.fill,
                      ))):Container(
                  height: 200,
                  width: 300,
                  decoration: BoxDecoration(
                      borderRadius:
                          const BorderRadius.all(Radius.circular(20)),
                      border: Border.all(width: 1.5)),
                  child: ClipRRect(
                      borderRadius:
                          const BorderRadius.all(Radius.circular(20)),
                      child: Image.file(
                        _aadharFront!,
                        fit: BoxFit.fill,
                      ))),
                ),
              
               
              ],
            ),
            const SizedBox(
              height: 20,
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Adhar Back : ",
                  style: GoogleFonts.lato(
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
                GestureDetector(
                onTap: () {
                  _getAadharBackImageFromGallery();
                },
                child: _aadharBack==null? Container(
                  height: 200,
                  width: 300,
                  decoration: BoxDecoration(
                      borderRadius:
                          const BorderRadius.all(Radius.circular(20)),
                      border: Border.all(width: 1.5)),
                  child: ClipRRect(
                      borderRadius:
                          const BorderRadius.all(Radius.circular(20)),
                      child: Image.network(
                        u!.aadharBack,
                        fit: BoxFit.fill,
                      ))):Container(
                  height: 200,
                  width: 300,
                  decoration: BoxDecoration(
                      borderRadius:
                          const BorderRadius.all(Radius.circular(20)),
                      border: Border.all(width: 1.5)),
                  child: ClipRRect(
                      borderRadius:
                          const BorderRadius.all(Radius.circular(20)),
                      child: Image.file(
                        _aadharBack!,
                        fit: BoxFit.fill,
                      ))),
                ),
              ],
            ),
            const SizedBox(
              height: 20,
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Pan : ",
                  style: GoogleFonts.lato(
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
                GestureDetector(
                onTap: () {
                  _getaPanImageFromGallery();
                },
                child: _pan==null? Container(
                  height: 200,
                  width: 300,
                  decoration: BoxDecoration(
                      borderRadius:
                          const BorderRadius.all(Radius.circular(20)),
                      border: Border.all(width: 1.5)),
                  child: ClipRRect(
                      borderRadius:
                          const BorderRadius.all(Radius.circular(20)),
                      child:  u!.panPic!.isNotEmpty
                            ? Image.network(
                                "${u!.panPic}",
                                fit: BoxFit.fill,
                              )
                            : const Center(
                                child: Text("Please Upload Pan"),
                              ))):Container(
                  height: 200,
                  width: 300,
                  decoration: BoxDecoration(
                      borderRadius:
                          const BorderRadius.all(Radius.circular(20)),
                      border: Border.all(width: 1.5)),
                  child: ClipRRect(
                      borderRadius:
                          const BorderRadius.all(Radius.circular(20)),
                      child: Image.file(
                        _pan!,
                        fit: BoxFit.fill,
                      ))),
                ),
              ],
            ),
            const SizedBox(
              height: 20,
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "CollegeId Front : ",
                  style: GoogleFonts.lato(
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
                GestureDetector(
                onTap: () {
                  _getCollegeIdFrontImageFromGallery();
                },
                child: _collegeIdFront==null? Container(
                  height: 200,
                  width: 300,
                  decoration: BoxDecoration(
                      borderRadius:
                          const BorderRadius.all(Radius.circular(20)),
                      border: Border.all(width: 1.5)),
                  child: ClipRRect(
                      borderRadius:
                          const BorderRadius.all(Radius.circular(20)),
                      child: Image.network(
                        u!.collegeIdPicFront,
                        fit: BoxFit.fill,
                      ))):Container(
                  height: 200,
                  width: 300,
                  decoration: BoxDecoration(
                      borderRadius:
                          const BorderRadius.all(Radius.circular(20)),
                      border: Border.all(width: 1.5)),
                  child: ClipRRect(
                      borderRadius:
                          const BorderRadius.all(Radius.circular(20)),
                      child: Image.file(
                        _collegeIdFront!,
                        fit: BoxFit.fill,
                      ))),
                ),
              ],
            ),
            const SizedBox(
              height: 20,
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "CollegeId Back : ",
                  style: GoogleFonts.lato(
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
               GestureDetector(
                onTap: () {
                  _getCollegeIdBankImageFromGallery();
                },
                child: _collegeIdBack==null? Container(
                  height: 200,
                  width: 300,
                  decoration: BoxDecoration(
                      borderRadius:
                          const BorderRadius.all(Radius.circular(20)),
                      border: Border.all(width: 1.5)),
                  child: ClipRRect(
                      borderRadius:
                          const BorderRadius.all(Radius.circular(20)),
                      child: Image.network(
                        u!.collegeIdPicBack,
                        fit: BoxFit.fill,
                      ))):Container(
                  height: 200,
                  width: 300,
                  decoration: BoxDecoration(
                      borderRadius:
                          const BorderRadius.all(Radius.circular(20)),
                      border: Border.all(width: 1.5)),
                  child: ClipRRect(
                      borderRadius:
                          const BorderRadius.all(Radius.circular(20)),
                      child: Image.file(
                        _collegeIdBack!,
                        fit: BoxFit.fill,
                      ))),
                ),
              ],
            ),
            const SizedBox(
              height: 20,
            ),
          ] else ...[
            // Handle the case when user data is loading or not available
            const Text("Loading user data..."),
          ],
          const SizedBox(
            height: 20,
          ),
        ],
      ),
    );
  }

}
