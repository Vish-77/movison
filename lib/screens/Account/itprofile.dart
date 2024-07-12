import 'dart:io';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:movison/screens/MobileAuth/authprovider.dart';
import 'package:provider/provider.dart';

class EditProfileScreen extends StatefulWidget {
  const EditProfileScreen({Key? key}) : super(key: key);

  @override
  _EditProfileScreenState createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  late TextEditingController _nameController;
  TextEditingController? _emailController ;
  late TextEditingController _bioController;
  File? _image;

  @override
  void initState() {
    super.initState();
    AuthProvider authProvider =
        Provider.of<AuthProvider>(context, listen: false);
    _nameController = TextEditingController(text: authProvider.userModel.name);
    _bioController = TextEditingController(text: authProvider.userModel.bio);
    _emailController=TextEditingController(text: authProvider.userModel.email);
  }

  @override
  void dispose() {
    _nameController.dispose();
    _bioController.dispose();
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

  @override
  Widget build(BuildContext context) {
    AuthProvider authProvider = Provider.of<AuthProvider>(context);
    AuthProvider ap = Provider.of<AuthProvider>(context, listen: false);
    return Scaffold(
      resizeToAvoidBottomInset: true,
      appBar: PreferredSize(
        preferredSize:
            const Size.fromHeight(50.0), // Set your desired app bar height
        child: Stack(
          alignment: Alignment.center,
          clipBehavior: Clip.none,
          children: [
            AppBar(
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
            Positioned(
              top: 80,
              child: GestureDetector(
                onTap: () {
                  _getImageFromGallery();
                },
                child: CircleAvatar(
                  radius: 70,
                  backgroundImage: NetworkImage(
                      authProvider.userModel.profilePic.toString()),
                  // backgroundColor: Colors.orange,
                  child: _image == null
                      ? const Icon(
                          Icons.camera_alt,
                          size: 40,
                        )
                      : null,
                ),
              ),
            ),
          ],
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 50),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 140),
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
              "Bio",
              style: GoogleFonts.lato(
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            ),
            const SizedBox(height: 7),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              height: 80,
              width: 300,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(width: 1.5)),
              child: TextFormField(
                controller: _bioController,
                maxLines: 4,
                decoration: const InputDecoration(border: InputBorder.none),
              ),
            ),
            const SizedBox(height: 20),
            _buildBody(),
            const SizedBox(height: 30,),
            Center(
              child: GestureDetector(
                onTap: () {
                  authProvider.updateProfile(
                      context, _nameController.text,_emailController?.text, _bioController.text,_image,_univercityValue,_branchValue,_semesterValue );
                  Navigator.pop(context);
                  setState(() {});
                },
                child: Container(
                  height: 40,
                  width: 100,
                  decoration: const BoxDecoration(
                      color: Colors.orange,
                      borderRadius: BorderRadius.all(Radius.circular(20))),
                  child: Center(
                    child: Text(
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
          ],
        ),
      ),
    );
  }

  String? _univercityValue;
  String? _branchValue;
  String? _semesterValue;
  Widget _buildBody() {
    return Padding(
      padding: const EdgeInsets.all(0),
      child: Column(
        children: [
          Row(
            children: [
              Text(
                "Select University : ",
                style: GoogleFonts.lato(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
              const SizedBox(width: 10,),
              Container(height: 40,
              width: 100,
                decoration: BoxDecoration( 
                  border: Border.all(width: 2,color: Colors.black)
                ),
                child: DropdownButton<String>(
                  hint: const Text("Select"),
                  alignment: AlignmentDirectional.center,
                  value: _univercityValue,
                  onChanged: (String? newValue) {
                    setState(() {
                      _univercityValue = newValue!;
                    });
                  },
                  items: <String>['SPPU',]
                      .map<DropdownMenuItem<String>>((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(
                        value,
                        style: GoogleFonts.lato(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                    );
                  }).toList(),
                ),
              ),
            ],
          ),
          const SizedBox(height: 10,),
          Row(
            children: [
              Text(
                "Select Branch : ",
                style: GoogleFonts.lato(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
              const SizedBox(width: 36,),
              Container(height: 40,
              width: 100,
                decoration: BoxDecoration( 
                  border: Border.all(width: 2,color: Colors.black)
                ),
                child: DropdownButton<String>(
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
                      child: Text(
                        value,
                        style: GoogleFonts.lato(
                          fontWeight: FontWeight.w500,
                          fontSize: 16,
                        ),
                      ),
                    );
                  }).toList(),
                ),
              ),
            ],
          ),
          const SizedBox(height: 10,),
          Row(
            children: [
              Text(
                "Select Semester : ",
                style: GoogleFonts.lato(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
              const SizedBox(width: 17,),
              Container(
                height: 40,
              width: 100,
                decoration: BoxDecoration( 
                  border: Border.all(width: 2,color: Colors.black)
                ),
                child: DropdownButton<String>(
                  hint: const Text("Select"),
                  alignment: AlignmentDirectional.center,
                  value: _semesterValue,
                  onChanged: (String? newValue) {
                    setState(() {
                      _semesterValue = newValue!;
                    });
                  },
                  items: <String>[
                    'I',
                    'II',
                    'III',
                    'IV',
                    'V',
                    'VI',
                    'VII',
                    'VIII'
                  ].map<DropdownMenuItem<String>>((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(
                        value,
                        style: GoogleFonts.lato(
                          fontWeight: FontWeight.w500,
                          fontSize: 16,
                        ),
                      ),
                    );
                  }).toList(),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
