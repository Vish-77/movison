import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:movison/screens/MobileAuth/authprovider.dart';// Use an alias

import 'package:movison/screens/MobileAuth/usermodel.dart';
import 'package:movison/theme/color.dart';
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
    final ap = Provider.of<AuthProvider>(context,
        listen: false); // Use the alias

    await ap.getDataFromSP();
    setState(() {
      u = ap.userModel;
      if (u!.univercity.isNotEmpty &&
          u!.branch.isNotEmpty &&
          u!.sem.isNotEmpty) {
        _univercityValue = u!.univercity;
        _collegeValue = u!.college;
        _branchValue = u!.branch;
        _semesterValue = u!.sem;
      } else {
        _univercityValue = "Select";
        _branchValue = "Select";
        _semesterValue = "Select";
        _collegeValue = "Select";
      }

      isUserLoaded = true;
    });
  }

  @override
  void initState() {
    super.initState();
    getData();
    setState(() {});
  }

  String? _univercityValue;
  String? _branchValue;
  String? _semesterValue;
  String? _collegeValue;
  Widget _buildSection1() {
    final ap =
        Provider.of<AuthProvider>(context, listen: false);
    return Padding(
      padding: const EdgeInsets.all(5),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(
            height: 20,
          ),
          Row(
            children: [
              Text(
                "Select University : ",
                style: GoogleFonts.lato(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
              const SizedBox(
                width: 10,
              ),
              Container(
                height: 40,
                //width: 100,
                decoration: BoxDecoration(
                    border: Border.all(width: 2, color: Colors.black)),
                child: DropdownButton<String>(
                  hint: const Text("Select"),
                  alignment: AlignmentDirectional.center,
                  value: _univercityValue,
                  onChanged: (String? newValue) {
                    setState(() {
                      _univercityValue = newValue!;
                    });
                  },
                  items: <String>[
                    'Select',
                    'SPPU',
                  ].map<DropdownMenuItem<String>>((String value) {
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
          const SizedBox(
            height: 20,
          ),
          Text(
                "Select College : ",
                style: GoogleFonts.lato(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
          const SizedBox(
            width: 17,
          ),
          Container(
           
            //width: 100,
            alignment: Alignment.center,
            decoration: BoxDecoration(
                border: Border.all(width: 2, color: Colors.black)),
            child: DropdownButton<String>(
              
              hint: const Text("Select"),
            
              
              isExpanded: true,
              value: _collegeValue,
              onChanged: (String? newValue) {
                setState(() {
                  _collegeValue = newValue!;
                });
              },
              items: <String>[
                'Select',
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
          const SizedBox(
            height: 20,
          ),
          Text(
            "Select Branch : ",
            style: GoogleFonts.lato(
              fontWeight: FontWeight.bold,
              fontSize: 16,
            ),
          ),
          const SizedBox(
            width: 36,
          ),
          Container(
            height: 60,
            //width: 99,

            decoration: BoxDecoration(
                border: Border.all(width: 2, color: Colors.black)),
            child: DropdownButton<String>(
              hint: const Text("Select",textAlign: TextAlign.justify,),
              
              value: _branchValue,
              onChanged: (String? newValue) {
                setState(() {
                  _branchValue = newValue!;
                });
              },
              items: <String>[
                'Select',
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
                    width:220,
                  
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
          const SizedBox(
            height: 20,
          ),
          Row(
            children: [
              Text(
                "Select Semester : ",
                style: GoogleFonts.lato(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
              const SizedBox(
                width: 17,
              ),
              Container(
                height: 40,
               // width: 100,
                decoration: BoxDecoration(
                    border: Border.all(width: 2, color: Colors.black)),
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
                    'Select',
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
          const SizedBox(
            height: 20,
          ),
          Center(
            child: GestureDetector(
              onTap: () {
                if (_univercityValue!.isNotEmpty &&
                    _branchValue!.isNotEmpty &&
                    _semesterValue!.isNotEmpty && _collegeValue!.isNotEmpty) {
                  ap.updateCollegeInfo(context, _univercityValue!,
                      _branchValue!, _semesterValue!,_collegeValue!);
                }

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
          )
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: const Color.fromARGB(255, 130, 98, 206),
          title: const Text('College Information'),
        ),
        body: Center(
          child: Container(
              width: 300,
              height: 400,
              padding: const EdgeInsets.symmetric(horizontal: 20),
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
              child: _buildSection1()),
        ));
  }

}
