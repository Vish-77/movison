import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:movison/screens/Home/productservice.dart';

class ProductEntryScreen extends StatefulWidget {
  const ProductEntryScreen({super.key});

  @override
  State createState() => _ProductEntryScreenState();
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
     
      return userId;
    } else {
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
_buildBody(),
            const SizedBox(height: 30,),
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
                      univercity: _univercityValue,
                      branch:_branchValue,
                      sem: _semesterValue
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
  
  String? _univercityValue;
  String? _branchValue;
  String? _semesterValue;
  Widget _buildBody() {
    return Padding(
      padding: const EdgeInsets.all(0),
      child: Column(
        children: [
          Text(
            "College : ",
            style: GoogleFonts.lato(
              fontWeight: FontWeight.bold,
              fontSize: 16,
            ),
          ),
          const SizedBox(width: 30,),
          Container(height: 60,
           alignment: AlignmentDirectional.topStart,
            decoration: BoxDecoration( 
              border: Border.all(width: 2,color: Colors.black)
            ),
            child: DropdownButton<String>(
              hint: const Text("Select"),
             
              value: _univercityValue,
              onChanged: (String? newValue) {
                setState(() {
                  _univercityValue = newValue!;
                });
              },
              items: <String>[
            'College of Engineering, Pune (COEP)',
            'MIT World Peace University (MIT WPU)',
            'Vishwakarma Institute of Technology (VIT)',
            'Pune Institute of Computer Technology (PICT)',
            'Cummins College of Engineering for Women',
            'Bharati Vidyapeeth College of Engineering',
            'Maharashtra Institute of Technology (MIT)',
            'Sinhgad College of Engineering',
            'Dr. D.Y. Patil Institute of Technology',
            'AISSMS College of Engineering',
            'Pimpri Chinchwad College of Engineering (PCCOE)',
            'MIT Academy of Engineering (MITAOE)',
            'Indira College of Engineering and Management',
            'Vishwakarma Institute of Information Technology (VIIT)',
            'JSPM\'s Rajarshi Shahu College of Engineering',
            'Modern Education Society\'s College of Engineering',
            'MKSSS Cummins College of Engineering for Women',
            'SKN Sinhgad College of Engineering',
            'Marathwada Mitra Mandal\'s College of Engineering (MMCOE)',
            'Zeal College of Engineering & Research',
            'Trinity College of Engineering and Research',
            'RMD Sinhgad School of Engineering',
            'Dhole Patil College of Engineering',
            'Rajgad Dnyanpeeth\'s Technical Campus',
            'MIT School of Engineering',
            'Army Institute of Technology (AIT)',
            'DY Patil College of Engineering, Akurdi',
            'Genba Sopanrao Moze College of Engineering',
            'JSPM Narhe Technical Campus',
            'KJ\'s Educational Institute\'s Trinity College of Engineering & Research',
            'NBN Sinhgad School of Engineering',
            'Padmabhooshan Vasantdada Patil Institute of Technology',
            'Shree Ramchandra College of Engineering',
            'Pune Vidyarthi Griha\'s College of Engineering',
            'Smt. Kashibai Navale College of Engineering',
            'AISSMS Institute of Information Technology',
            'Alard College of Engineering & Management',
            'MESCOE College of Engineering',
            'Pimpri Chinchwad College of Engineering and Research (PCCOER)',
            'Jayawantrao Sawant College of Engineering (JSCOE)',
            'Sinhgad Institute of Technology and Science',
            'Rajarshi Shahu College of Engineering',
            'Imperial College of Engineering & Research',
            'TSSM\'s Bhivarabai Sawant College of Engineering and Research',
            'G.H. Raisoni Institute of Engineering & Technology',
            'Siddhant College of Engineering',
            'Indira College of Engineering and Management',
            'All India Shri Shivaji Memorial Society\'s College of Engineering',
            'Anantrao Pawar College of Engineering & Research',
            'Institute of Knowledge College of Engineering',
          ]
                  .map<DropdownMenuItem<String>>((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: SizedBox(
                    width: MediaQuery.of(context).size.width-100,
                    child: Text(
                      value,
                      textAlign: TextAlign.justify,
                      style: GoogleFonts.lato(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                  ),
                );
              }).toList(),
            ),
          ),
          const SizedBox(height: 10,),
          Text(
            "Select Branch : ",
            style: GoogleFonts.lato(
              fontWeight: FontWeight.bold,
              fontSize: 16,
            ),
          ),
          const SizedBox(width: 56,),
          Container(height: 60,
          
          alignment: AlignmentDirectional.center,
            decoration: BoxDecoration( 
              border: Border.all(width: 2,color: Colors.black)
            ),
            child: DropdownButton<String>(
              hint: const Text("Select"),
              
              value: _branchValue,
              onChanged: (String? newValue) {
                setState(() {
                  _branchValue = newValue!;
                });
              },
              items: <String>[
            'Mechanical Engineering',
            'Civil Engineering',
            'Electrical Engineering',
            'Electronics and Communication Engineering',
            'Computer Engineering',
            'Information Technology',
            'Artificial Intelligence and Data Science',
            'Automobile Engineering',
            'Aerospace Engineering',
            'Chemical Engineering',
            'Petroleum Engineering',
            'Biomedical Engineering',
            'Biotechnology Engineering',
            'Environmental Engineering',
            'Materials Science and Engineering',
            'Industrial Engineering',
            'Production Engineering',
            'Manufacturing Engineering',
            'Mechatronics Engineering',
            'Robotics Engineering',
            'Nanotechnology Engineering',
            'Agricultural Engineering',
            'Marine Engineering',
            'Mining Engineering',
            'Textile Engineering',
            'Polymer Engineering',
            'Instrumentation Engineering',
            'Control Engineering',
            'Metallurgical Engineering',
            'Geotechnical Engineering',
            'Structural Engineering',
            'Transportation Engineering',
            'Construction Engineering',
            'Power Engineering',
            'Telecommunications Engineering',
            'Software Engineering',
            'Network Engineering',
            'Data Engineering',
            'Bioinformatics Engineering',
            'Nuclear Engineering',
            'Renewable Energy Engineering',
            'Systems Engineering',
            'Aeronautical Engineering',
            'Automated and Autonomous Systems Engineering',
            'Optical Engineering',
            'Photonics Engineering',
            'Thermal Engineering',
            'Acoustical Engineering',
            'Safety Engineering',
            'Fire Engineering',
            'Ocean Engineering',
            'Urban Engineering',
            'Railway Engineering',
            'Aerospace Avionics',
            'Petrochemical Engineering',
            'Food Technology Engineering',
            'Pharmaceutical Engineering',
            'Ceramic Engineering',
            'Paper Engineering',
            'Plastics Engineering',
            'Printing Technology Engineering',
            'Packaging Engineering',
            'Leather Technology',
            'Water Resources Engineering',
            'Geomatics Engineering',
            'Renewable and Sustainable Energy Engineering',
            'Energy Systems Engineering',
            'Transportation Systems Engineering',
            'Chemical and Bioprocess Engineering',
          ]
                  .map<DropdownMenuItem<String>>((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: SizedBox(
                    width:MediaQuery.of(context).size.width-100,
                    child: Text(
                      value,
                      textAlign: TextAlign.justify,
                      style: GoogleFonts.lato(
                        fontWeight: FontWeight.w500,
                        fontSize: 16,
                      ),
                    ),
                  ),
                );
              }).toList(),
            ),
          ),
          const SizedBox(height: 10,),
          Text(
            "Select Semester : ",
            style: GoogleFonts.lato(
              fontWeight: FontWeight.bold,
              fontSize: 16,
            ),
          ),
          const SizedBox(width: 37,),
          Container(
            height: 60,
          width: MediaQuery.of(context).size.width,
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
    );
  }
}
