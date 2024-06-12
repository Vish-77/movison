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
  TextEditingController addressController = TextEditingController();
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
      return userId;
    } else {
      // No user is signed in
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

  String productType = 'Seed';
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 240, 204, 248),
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(30),
        child: AppBar(
          leading: const SizedBox(),
          shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.vertical(bottom: Radius.circular(20))),
          backgroundColor: Colors.orange,
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 35.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                IconButton(
                  onPressed: () {
                    Navigator.pop(context);
                    setState(() {});
                  },
                  icon: SizedBox(
                    height: 30,
                    width: 30,
                    child: Icon(Icons.arrow_back_ios_new),
                  ),
                ),
                const SizedBox(
                  width: 40,
                ),
                Text(
                  "Add New Product",
                  style: GoogleFonts.ubuntu(
                    fontWeight: FontWeight.w600,
                    fontSize: 20,
                  ),
                )
              ],
            ),
            // Image picking section
            Center(
              child: CircleAvatar(
                backgroundColor: Colors.blue,
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
              "Product Name",
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
                  'Product Type ',
                  style: GoogleFonts.lato(
                    fontWeight: FontWeight.w500,
                    fontSize: 16,
                  ),
                ),
                Container(
                  height: 60,
                  width: 176,
                  decoration: BoxDecoration(
                      color: const Color.fromARGB(255, 244, 162, 252),
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
                        value: 'Seed',
                        child: Text(
                          'Seed',
                          style: GoogleFonts.lato(
                            fontWeight: FontWeight.w500,
                            fontSize: 14,
                          ),
                        ),
                      ),
                      DropdownMenuItem<String>(
                        value: 'Fresh From Farm',
                        child: Text(
                          'Fresh From Farm',
                          style: GoogleFonts.lato(
                            fontWeight: FontWeight.w500,
                            fontSize: 14,
                          ),
                        ),
                      ),
                      DropdownMenuItem<String>(
                        value: 'Fertilizer',
                        child: Text(
                          'Fertilizer',
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
            Row(
              children: [
                Text(
                  'Available:',
                  style: GoogleFonts.lato(
                    fontWeight: FontWeight.w500,
                    fontSize: 16,
                  ),
                ),
                const SizedBox(width: 8),
                Checkbox(
                  value: isAvailable,
                  shape: const CircleBorder(),
                  checkColor: Colors.green,
                  onChanged: (value) {
                    setState(() {
                      isAvailable = value ?? false;
                    });
                  },
                )
              ],
            ),
            const SizedBox(height: 8),
            Text(
              "Address",
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
                controller: addressController,
                decoration: const InputDecoration(border: InputBorder.none),
              ),
            ),
            const SizedBox(height: 8),
            Center(
              child: Container(
                height: 30,
                width: 160,
                decoration: const BoxDecoration(
                  borderRadius: BorderRadius.all(Radius.circular(20)),
                  color: Colors.orange,
                ),
                child: GestureDetector(
                  onTap: () async {
                    setState(() {
                      isLoading = true;
                    });

                    // Show loading dialog
                    await _showLoadingDialog(context);

                    try {
                      File imageFile = File(imagePathController.text);

                      await ProductService().addProduct(
                          userId: userId,
                          name: nameController.text,
                          price: double.tryParse(priceController.text) ?? 0.0,
                          availability: isAvailable,
                          type: productType,
                          imageFile: imageFile,
                          description: descriptionController.text,
                          address: addressController.text);

                      // Clear the form fields after submission
                      imagePathController.clear();
                      nameController.clear();
                      priceController.clear();
                      isAvailable = false;
                      productType = 'Seed'; // Reset to default type

                      // Show success dialog
                      _showSuccessDialog(context);
                    } finally {
                      // Hide loading dialog
                      _hideLoadingDialog(context);

                      setState(() {
                        isLoading = false;
                      });
                    }
                  },
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
