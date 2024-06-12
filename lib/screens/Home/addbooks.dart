import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:movison/screens/Home/productservice.dart';

class ProductEntryScreen extends StatefulWidget {
  const ProductEntryScreen({super.key});

  @override
  _ProductEntryScreenState createState() => _ProductEntryScreenState();
}

class _ProductEntryScreenState extends State<ProductEntryScreen> {
  TextEditingController imagePathController = TextEditingController();
  TextEditingController nameController = TextEditingController();
  TextEditingController priceController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();
  bool isAvailable = false;
  bool isLoading = false;
  // Default type
  final productService = ProductService();
  String userId = "";
  Future<void> _pickImage() async {
    final pickedFile =
        await ImagePicker().pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        imagePathController.text = pickedFile.path;
      });
    }
  }

  Future<String?> getCurrentUserId() async {
    FirebaseAuth auth = FirebaseAuth.instance;
    User? user = auth.currentUser;

    if (user != null) {
      String userId = user.uid;
      print(userId);
      return userId;
    } else {
      // No user is signed in
      print("null");
      return null;
    }
  }

  Future<void> _showSuccessDialog(BuildContext context) async {
    return showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Success'),
          content: const Text('Product added successfully!'),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('OK'),
            ),
          ],
        );
      },
    );
  }

  Future<void> _showLoadingDialog(BuildContext context) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return const AlertDialog(
          content: Row(
            children: [
              CircularProgressIndicator(),
              SizedBox(width: 16),
              Text("Adding product..."),
            ],
          ),
        );
      },
    );
  }

  Future<void> _hideLoadingDialog(BuildContext context) async {
    Navigator.of(context).pop();
  }

  String productType = 'Buy';
  @override
  Widget build(BuildContext context) {
    return Scaffold(

      appBar: AppBar( 
        centerTitle: true,
        title:  Text(
                  "Add New Books",
                  style: GoogleFonts.ubuntu(
                    fontWeight: FontWeight.w600,
                    fontSize: 20,
                  ),
                ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 35.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
             // Image picking section
            Center(
              child: CircleAvatar(
                backgroundColor: Colors.grey,
                radius: 40,
                child: GestureDetector(
                  onTap: _pickImage,
                  child: imagePathController.text.isNotEmpty
                      ? Center(
                          child: Image.file(
                            File(imagePathController.text),
                            height: 100,
                            width: 100,
                            fit: BoxFit.cover,
                          ),
                        )
                      : const Icon(Icons.photo),
                ),
              ),
            ),
            const SizedBox(height: 5),
            Center(
              child: Text(
                "Add Image",
                style: GoogleFonts.ubuntu(
                  fontWeight: FontWeight.w600,
                  fontSize: 18,
                ),
              ),
            ),

            const SizedBox(height: 12),

            Text(
              "Book Name",
              style: GoogleFonts.lato(
                fontWeight: FontWeight.w500,
                fontSize: 16,
              ),
            ),
            const SizedBox(height: 12),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 30),
              height: 30,
              //width: 280,
              decoration: BoxDecoration(
                  borderRadius: const BorderRadius.all(Radius.elliptical(2, 2)),
                  border: Border.all(width: 2.5)),
              child: TextField(
                controller: nameController,
                decoration: const InputDecoration(border: InputBorder.none),
              ),
            ),
            const SizedBox(height: 12),

            Row(
              children: [
                Text(
                  'Book Type ',
                  style: GoogleFonts.lato(
                    fontWeight: FontWeight.w500,
                    fontSize: 16,
                  ),
                ),
                Container(
                  height: 60,
                  width: 176,
                  decoration: BoxDecoration(
  
                      border: Border.all(color: Colors.black, width: 2)),
                  child: DropdownButtonFormField(
                    elevation: 0,
                    isDense: true,
                    isExpanded: true,
                    iconSize: 18,
                    value: productType,
                    padding: const EdgeInsets.all(0),
                    onChanged: (value) {
                      setState(() {
                        productType = value.toString();
                      });
                    },
                    items: [
                      DropdownMenuItem<String>(
                        value: 'None', // Add this line
                        child: Text(
                          'None',
                          style: GoogleFonts.lato(
                            fontWeight: FontWeight.w500,
                            fontSize: 14,
                          ),
                        ),
                      ),
                      DropdownMenuItem<String>(
                        value: 'Buy',
                        child: Text(
                          'Buy',
                          style: GoogleFonts.lato(
                            fontWeight: FontWeight.w500,
                            fontSize: 14,
                          ),
                        ),
                      ),
                      DropdownMenuItem<String>(
                        value: 'Rent',
                        child: Text(
                          'Rent',
                          style: GoogleFonts.lato(
                            fontWeight: FontWeight.w500,
                            fontSize: 14,
                          ),
                        ),
                      ),
                    ],
                    decoration: const InputDecoration(
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.all(Radius.zero))),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 12),
            // Product details section

            Text(
              "Price",
              style: GoogleFonts.lato(
                fontWeight: FontWeight.w500,
                fontSize: 16,
              ),
            ),

            Container(
              padding: const EdgeInsets.symmetric(horizontal: 30),
              height: 30,
              //width: 280,
              decoration: BoxDecoration(
                  borderRadius: const BorderRadius.all(Radius.elliptical(2, 2)),
                  border: Border.all(width: 2.5)),
              child: TextField(
                controller: priceController,
                keyboardType: TextInputType.number, // Adjust as needed
                decoration: const InputDecoration(border: InputBorder.none),
              ),
            ),
            const SizedBox(height: 12),

            Text(
              "Description",
              style: GoogleFonts.lato(
                fontWeight: FontWeight.w500,
                fontSize: 16,
              ),
            ),
            const SizedBox(height: 12),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 40),
              height: 50,
              // width: 280,
              decoration: BoxDecoration(
                  borderRadius: const BorderRadius.all(Radius.elliptical(2, 2)),
                  border: Border.all(width: 2.5)),
              child: TextField(
                controller: descriptionController,
                decoration: const InputDecoration(border: InputBorder.none),
              ),
            ),

            const SizedBox(height: 4),

            Center(
              child: GestureDetector(
                onTap: () async {
                  setState(() {
                    isLoading = true;
                  });

                  // Show loading dialog
                  //await _showLoadingDialog(context);
                  
                  try {
                     userId = await getCurrentUserId() ?? "";

        if (userId.isEmpty) {
          // Show error dialog if user ID is not retrieved
          print( "Failed to get user ID. Please try again.");
          return;
        }
                    File imageFile = File(imagePathController.text);
                
                    await ProductService().addProduct(
                      userId: userId,
                      name: nameController.text,
                      price: double.tryParse(priceController.text) ?? 0.0,
                      type: productType,
                      imageFile: imageFile,
                      description: descriptionController.text,
                    );

                    // Clear the form fields after submission
                    imagePathController.clear();
                    nameController.clear();
                    priceController.clear();
                    productType = 'Buy'; 
                    descriptionController.clear();// Reset to default type
                    
                    //Navigator.pop(context);
                    // Show success dialog
                    await _showSuccessDialog(context);
                  }
                  finally {
                    // Hide loading dialog
                    _hideLoadingDialog(context);

                    setState(() {
                      isLoading = false;
                    });
                  }
                },
                child: Container(
                  height: 30,
                  width: 160,
                  decoration: const BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.circular(20)),
                    color: Colors.orange,
                  ),
                  child: Center(
                      child: Text(
                    'Submit',
                    style: GoogleFonts.lato(
                      fontWeight: FontWeight.w500,
                      fontSize: 16,
                    ),
                  )),
                ),
              ),
            ),
            const SizedBox(height: 30),
          ],
        ),
      ),
    );
  }
}
