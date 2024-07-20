import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:movison/screens/CollegeInfo/clginfo.dart';
import 'package:movison/screens/History/history.dart';
import 'package:movison/screens/MobileAuth/authprovider.dart'
    as MovisonAuthProvider; // Use an alias

import 'package:movison/screens/MobileAuth/mobile_register.dart';
import 'package:movison/screens/MobileAuth/usermodel.dart';
import 'package:movison/screens/Payment/paymenthist.dart';
import 'package:movison/screens/Personal/personalInfo.dart';
import 'package:movison/screens/Privacy/privacypolicy.dart';
import 'package:movison/theme/color.dart';
import 'package:movison/widgets/profile_pic.dart';
import 'package:movison/widgets/setting_box.dart';
import 'package:movison/widgets/setting_item.dart';
import 'package:provider/provider.dart';

class AccountPage extends StatefulWidget {
  const AccountPage({Key? key}) : super(key: key);

  @override
  _AccountPageState createState() => _AccountPageState();
}

class _AccountPageState extends State<AccountPage> {
  UserModel? u;
  bool isUserLoaded = false;

  Future<void> getData() async {
    final ap = Provider.of<MovisonAuthProvider.AuthProvider>(context,
        listen: false); // Use the alias

    await ap.getDataFromSP();
    setState(() {
      u = ap.userModel;
      isUserLoaded = true;
      print(u!.profilePic);
      print(u!.name);
    });
  }

  @override
  void initState() {
    super.initState();
    getData();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text('Profile',style: TextStyle(
            color: AppColor.textColor,
            fontSize: 24,
            fontWeight: FontWeight.w600,
          ),),
        
      ),
      body: _buildBody(),
    );
  }

  _buildHeader() {
    return const Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          "Profile",
          style: TextStyle(
            color: AppColor.textColor,
            fontSize: 24,
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }

  Widget _buildBody() {
    return RefreshIndicator(
      onRefresh:getData,
      child: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 15),
        child: Column(
          children: [
            _buildProfile(),
            
            const SizedBox(
              height: 20,
            ),
            _buildSection1(),
            const SizedBox(
              height: 20,
            ),
            _buildSection2(),
            const SizedBox(
              height: 20,
            ),
            _buildSection3(),
          ],
        ),
      ),
    );
  }

  Widget _buildProfile() {
    return RefreshIndicator(
      onRefresh:getData,
      child: Column(
        children: [
          const ProfilePic(),
          const SizedBox(
            height: 10,
          ),
          if (u != null) ...[
            Text(
              u!.name,
              style:const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w500,
              ),
            ),
          ] else ...[
            // Handle the case when u or u.name is null
            const Text("User name not available"),
          ],
        ],
      ),
    );
  }

  Widget _buildRecord() {
    return const Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(
          child: SettingBox(
            title: "12 courses",
            icon: "assets/icons/work.svg",
          ),
        ),
        SizedBox(
          width: 10,
        ),
        Expanded(
          child: SettingBox(
            title: "55 hours",
            icon: "assets/icons/time.svg",
          ),
        ),
        SizedBox(
          width: 10,
        ),
        Expanded(
          child: SettingBox(
            title: "4.8",
            icon: "assets/icons/star.svg",
          ),
        ),
      ],
    );
  }

  Widget _buildSection1() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 15),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(5),
        color: AppColor.cardColor,
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
          if (u != null) ...[
            SettingItem(
                title: "Personal Info",
                leadingIcon: "assets/icons/contact_phone.svg",
                bgIconColor: AppColor.blue,
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const PersonalInfo()),
                  );
                }),
            _buildDivider(),
            SettingItem(
                title: "College Info",
                leadingIcon: "assets/icons/contact_phone.svg",
                bgIconColor: AppColor.blue,
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const CollegeInfo()),
                  );
                }),
            _buildDivider(),
            SettingItem(
              title: "History",
              leadingIcon: "assets/icons/wallet.svg",
              bgIconColor: AppColor.green,
              onTap: () async {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                     builder: (context) => HistoryScreen(currentUserId: u!.userId,),
                  ),
                );
              },
            ),
            _buildDivider(),
            SettingItem(
              title: "Payment",
              leadingIcon: "assets/icons/wallet.svg",
              bgIconColor: AppColor.green,
              onTap: () async {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                     builder: (context) => PaymentHistoryScreen(currentUserId: u!.userId,),
                  ),
                );
              },
            ),
            _buildDivider(),
          ] else ...[
            // Handle the case when u is null
            const Text("Loading user data..."),
          ],
        ],
      ),
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

  Widget _buildSection2() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 15),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(5),
        color: AppColor.cardColor,
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
          const SettingItem(
            title: "Terms & Conditions",
            leadingIcon: "assets/icons/bell1.svg",
            bgIconColor: AppColor.purple,
          ),
          Padding(
            padding: const EdgeInsets.only(left: 45),
            child: Divider(
              height: 0,
              color: Colors.grey.withOpacity(0.8),
            ),
          ),
          SettingItem(
            title: "Privacy",
            leadingIcon: "assets/icons/shield.svg",
            bgIconColor: AppColor.orange,
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => PrivacyPolicyPage()),
              );
            },
          ),
          _buildDivider(),
          const SettingItem(
            title: "Help Center",
            leadingIcon: "assets/icons/bell1.svg",
            bgIconColor: AppColor.purple,
          ),
          Padding(
            padding: const EdgeInsets.only(left: 45),
            child: Divider(
              height: 0,
              color: Colors.grey.withOpacity(0.8),
            ),
          ),
        ],
      ),
    );
  }

 Widget _buildSection3() {
  return Container(
    padding: const EdgeInsets.symmetric(horizontal: 15),
    decoration: BoxDecoration(
      borderRadius: BorderRadius.circular(5),
      color: AppColor.cardColor,
      boxShadow: [
        BoxShadow(
          color: AppColor.shadowColor.withOpacity(0.1),
          spreadRadius: 1,
          blurRadius: 1,
          offset: const Offset(0, 1), // changes position of shadow
        ),
      ],
    ),
    child: SettingItem(
      title: "Log Out",
      leadingIcon: "assets/icons/logout.svg",
      bgIconColor: AppColor.darker,
      onTap: () async {
        await _showLogoutConfirmationDialog(context);
      },
    ),
  );
}

Future<void> _showLogoutConfirmationDialog(BuildContext context) async {
  return showDialog<void>(
    context: context,
    barrierDismissible: false, // user must tap a button
    builder: (BuildContext context) {
      return AlertDialog(
        title: const Text('Confirm Logout'),
        content: SingleChildScrollView(
          child: ListBody(
            children: const <Widget>[
              Text('Are you sure you want to log out?'),
            ],
          ),
        ),
        actions: <Widget>[
          TextButton(
            child: const Text('Cancel'),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
          TextButton(
            child: const Text('Logout'),
            onPressed: () async {
              await FirebaseAuth.instance.signOut();
              Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(builder: (context) => const RegisterScreen()),
                (route) => false,
              );
            },
          ),
        ],
      );
    },
  );
}

}
