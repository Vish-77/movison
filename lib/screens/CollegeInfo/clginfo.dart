import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:movison/screens/MobileAuth/authprovider.dart'
    as MovisonAuthProvider; // Use an alias

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
    final ap = Provider.of<MovisonAuthProvider.AuthProvider>(context,
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
        Provider.of<MovisonAuthProvider.AuthProvider>(context, listen: false);
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
                'Indian Institute of Technology (IIT) Bombay',
                'University of Mumbai',
                'College of Engineering Pune (COEP)',
                'Veermata Jijabai Technological Institute (VJTI)',
                'National Institute of Technology (NIT) Nagpur',
                'Shivaji University',
                'Smt. Chandaben Homoeopathic Medical College',
                'LTM Medical College',
                'Sir JJ College of Architecture',
                'Homi Bhabha National Institute (HBNI)',
                'Symbiosis International University',
                'Institute of Chemical Technology (ICT)',
                'Government Law College Mumbai',
                'Mahatma Gandhi Mission (MGM) College',
                'Dr. Babasaheb Ambedkar Technological University (DBATU)',
                'K.J. Somaiya College of Engineering',
                'Ramnarain Ruia College',
                'St. Xavier’s College Mumbai',
                'Pune University',
                'Mody University of Science and Technology',
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
          Row(
            children: [
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
                height: 40,
                //width: 99,
                decoration: BoxDecoration(
                    border: Border.all(width: 2, color: Colors.black)),
                child: DropdownButton<String>(
                  hint: const Text("Select"),
                  alignment: AlignmentDirectional.center,
                  value: _branchValue,
                  onChanged: (String? newValue) {
                    setState(() {
                      _branchValue = newValue!;
                    });
                  },
                  items: <String>['Select', 'CS', 'IT', 'ENTC', 'Mec', 'Civil']
                      .map<DropdownMenuItem<String>>((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: SizedBox(
                        height: 80,
                        child: Text(
                          value,
                        //  textAlign: TextAlign.justify,
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
            ],
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
          backgroundColor: Color.fromARGB(255, 130, 98, 206),
          title: Text('College Information'),
        ),
        body: Center(
          child: Container(
              width: 300,
              height: 350,
              padding: const EdgeInsets.symmetric(horizontal: 20),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color: Color.fromARGB(255, 232, 222, 242),
                boxShadow: [
                  BoxShadow(
                    color: AppColor.shadowColor.withOpacity(0.1),
                    spreadRadius: 1,
                    blurRadius: 1,
                    offset: Offset(0, 1), // changes position of shadow
                  ),
                ],
              ),
              child: _buildSection1()),
        ));
  }

  Widget _buildBody() {
    return Padding(
      padding: const EdgeInsets.all(30),
      child: Column(
        children: [
          Row(
            children: [
              Text(
                "University : ",
                style: GoogleFonts.lato(
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                ),
              ),
              Text(
                u!.univercity,
                style: GoogleFonts.lato(
                  fontWeight: FontWeight.w500,
                  fontSize: 18,
                ),
              ),
            ],
          ),
          const SizedBox(
            height: 10,
          ),
          Row(
            children: [
              Text(
                "Branch : ",
                style: GoogleFonts.lato(
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                ),
              ),
              Text(
                u!.branch,
                style: GoogleFonts.lato(
                  fontWeight: FontWeight.w500,
                  fontSize: 18,
                ),
              ),
            ],
          ),
          const SizedBox(
            height: 10,
          ),
          Row(
            children: [
              Text(
                "Semester : ",
                style: GoogleFonts.lato(
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                ),
              ),
              Text(
                u!.sem,
                style: GoogleFonts.lato(
                  fontWeight: FontWeight.w500,
                  fontSize: 18,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
