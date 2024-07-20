import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:movison/screens/Account/itprofile.dart';
import 'package:movison/screens/MobileAuth/authprovider.dart'
    as MovisonAuthProvider; // Use an alias
import 'package:movison/screens/MobileAuth/usermodel.dart';
import 'package:movison/theme/color.dart';
import 'package:provider/provider.dart';

class PersonalInfo extends StatefulWidget {
  const PersonalInfo({Key? key}) : super(key: key);

  @override
  _PersonalInfo createState() => _PersonalInfo();
}

class _PersonalInfo extends State<PersonalInfo> {
  UserModel? u;
  bool isUserLoaded = false;

  // Loading states for each image

  bool _isLoadingAadharFront = true;
  bool _isLoadingAadharBack = true;
  bool _isLoadingPan = true;
  bool _isLoadingCollegeIdFront = true;
  bool _isLoadingCollegeIdBack = true;

  @override
  void initState() {
    super.initState();
    getData();
  }

  Future<void> getData() async {
    final ap = Provider.of<MovisonAuthProvider.AuthProvider>(context,
        listen: false); // Use the alias

    await ap.getDataFromSP();
    setState(() {
      u = ap.userModel;
      isUserLoaded = true;
      // Set loading states to false once data is fetched
     
      _isLoadingAadharFront = false;
      _isLoadingAadharBack = false;
      _isLoadingPan = false;
      _isLoadingCollegeIdFront = false;
      _isLoadingCollegeIdBack = false;
    });
  }

  Future<String> getUserProfilePic() async {
    // Simulate a network call or fetch from a database
    await Future.delayed(const Duration(seconds: 1));
    return u!.profilePic; // Replace with actual URL fetching logic
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          "Profile",
          style: GoogleFonts.ubuntu(
            fontWeight: FontWeight.w700,
            fontSize: 20,
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.yellowAccent,
        onPressed: () {
          Navigator.push(context, MaterialPageRoute<void>(
            builder: (BuildContext context) => const EditProfileScreen(),
          ));
        },
        child: const Icon(Icons.edit),
      ),
      body: _buildBody(),
    );
  }

  Widget _buildBody() {
    return RefreshIndicator(
      onRefresh: getData,
      child: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(height: 10),
            FutureBuilder<String>(
              future: getUserProfilePic(), // Replace with your async function to fetch the profile picture URL
              builder: (BuildContext context, AsyncSnapshot<String> snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return CircleAvatar(
                    backgroundColor: Color.fromARGB(255, 124, 121, 121),
                    radius: 60,
                    child: const CircularProgressIndicator(),
                  );
                } else if (snapshot.hasError) {
                  return const Icon(Icons.error); // Show an error icon if there was an error
                } else if (!snapshot.hasData ||
                    snapshot.data == null ||
                    snapshot.data!.isEmpty) {
                  return CircleAvatar(
                    backgroundColor: Colors.white,
                    radius: 60,
                    child: const Icon(Icons.person, size: 60), // Default avatar if no data or empty URL
                  );
                } else {
                  return CircleAvatar(
                    backgroundColor: Colors.white,
                    backgroundImage: NetworkImage(snapshot.data!),
                    radius: 60,
                  );
                }
              },
            ),
            const SizedBox(height: 20),
            _buildSection1(),
            const SizedBox(height: 20),
            _buildDivider(),
            const SizedBox(height: 20),
            _buildSection2(),
          ],
        ),
      ),
    );
  }

  Widget _buildSection1() {
    return Container(
      padding: const EdgeInsets.only(left: 10),
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
          const SizedBox(height: 20),
          if (isUserLoaded && u != null) ...[
            Row(
              children: [
                Text(
                  "Name : ",
                  style: GoogleFonts.lato(
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                  ),
                ),
                Text(
                  u!.name,
                  style: GoogleFonts.lato(
                    fontWeight: FontWeight.w500,
                    fontSize: 18,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            Row(
              children: [
                Text(
                  "Email : ",
                  style: GoogleFonts.lato(
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                  ),
                ),
                SizedBox(
                  height: 60,
                  width: 200,
                  child: Text(
                    u!.email,
                    textAlign: TextAlign.justify,
                    style: GoogleFonts.lato(
                      fontWeight: FontWeight.w500,
                      color: Colors.blue,
                      fontSize: 18,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            Row(
              children: [
                Text(
                  "Phone No : ",
                  style: GoogleFonts.lato(
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                  ),
                ),
                Text(
                  u!.phoneNumber,
                  style: GoogleFonts.lato(
                    fontWeight: FontWeight.w500,
                    fontSize: 18,
                  ),
                ),
              ],
            ),
          ] else ...[
            // Handle the case when user data is loading or not available
            const Text("Loading user data..."),
          ],
          const SizedBox(height: 20),
        ],
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
          const SizedBox(height: 20),
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
            _buildImageSection("Aadhar Front : ", u!.aadharFront, _isLoadingAadharFront, () {
              setState(() {
                _isLoadingAadharFront = true;
              });
              // Simulate loading delay
              Future.delayed(const Duration(seconds: 1), () {
                setState(() {
                  _isLoadingAadharFront = false;
                });
              });
            }),
            _buildImageSection("Aadhar Back : ", u!.aadharBack, _isLoadingAadharBack, () {
              setState(() {
                _isLoadingAadharBack = true;
              });
              // Simulate loading delay
              Future.delayed(const Duration(seconds: 1), () {
                setState(() {
                  _isLoadingAadharBack = false;
                });
              });
            }),
            _buildImageSection("Pan : ", u!.panPic, _isLoadingPan, () {
              setState(() {
                _isLoadingPan = true;
              });
              // Simulate loading delay
              Future.delayed(const Duration(seconds: 1), () {
                setState(() {
                  _isLoadingPan = false;
                });
              });
            }),
            _buildImageSection("CollegeId Front : ", u!.collegeIdPicFront, _isLoadingCollegeIdFront, () {
              setState(() {
                _isLoadingCollegeIdFront = true;
              });
              // Simulate loading delay
              Future.delayed(const Duration(seconds: 1), () {
                setState(() {
                  _isLoadingCollegeIdFront = false;
                });
              });
            }),
            _buildImageSection("CollegeId Back : ", u!.collegeIdPicBack, _isLoadingCollegeIdBack, () {
              setState(() {
                _isLoadingCollegeIdBack = true;
              });
              // Simulate loading delay
              Future.delayed(const Duration(seconds: 1), () {
                setState(() {
                  _isLoadingCollegeIdBack = false;
                });
              });
            }),
            const SizedBox(height: 20),
          ] else ...[
            // Handle the case when user data is loading or not available
            const Text("Loading user data..."),
          ],
          const SizedBox(height: 20),
        ],
      ),
    );
  }
Widget _buildImageSection(String title, String? imageUrl, bool isLoading, VoidCallback onTap) {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Text(
        title,
        style: GoogleFonts.lato(
          fontWeight: FontWeight.bold,
          fontSize: 18,
        ),
      ),
      const SizedBox(height: 10),
      GestureDetector(
        onTap: onTap,
        child: Container(
          height: 200,
          width: 300,
          decoration: BoxDecoration(
            borderRadius: const BorderRadius.all(Radius.circular(20)),
            border: Border.all(width: 1.5),
          ),
          child: isLoading
              ? const Center(child: CircularProgressIndicator())
              : imageUrl == null || imageUrl.isEmpty
                  ? const Center(child: Text("No Image Available")) // Handle null or empty URL
                  : ClipRRect(
                      borderRadius: const BorderRadius.all(Radius.circular(20)),
                      child: Image.network(
                        imageUrl,
                        fit: BoxFit.fill,
                        errorBuilder: (context, error, stackTrace) {
                          return const Center(child: Text("Error Loading Image")); // Handle image loading errors
                        },
                      ),
                    ),
        ),
      ),
      const SizedBox(height: 20),
    ],
  );
}

  Widget _buildDivider() {
    return Padding(
      padding: const EdgeInsets.only(left: 45),
      child: Divider(
        height: 0,
        color: Colors.grey.withOpacity(0.8),
      ),
    );
  }
}
