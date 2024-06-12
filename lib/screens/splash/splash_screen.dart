import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:movison/screens/Home/HomeScreen.dart';
import 'package:movison/screens/MobileAuth/mobile_register.dart';
import 'package:movison/size_config.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SplashScreen extends StatefulWidget {
  static String routeName = "/splash";

  const SplashScreen({Key? key}) : super(key: key);

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  @override
  void initState() {
    super.initState();
    _navigateToHome();
  }

  Future<void> _navigateToHome() async {
    await Future.delayed(Duration(milliseconds: 2000));
    SharedPreferences s = await SharedPreferences.getInstance();
    String data = s.getString("user_model") ?? '';
    print("-------------------------------------");
    print(data);

    // Check if the user is already signed in
    User? user = _auth.currentUser;
    if (data != '') {
      // User is signed in, navigate to HomeScreen
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
            builder: (context) =>
                HomeScreen()), // Replace HomeScreen with the actual home screen
      );
    } else {
      // User is not signed in, navigate to RegisterScreen
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => RegisterScreen()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);

    return Material(
      color: Colors.white, // Set the background color here
      child: GestureDetector(
        onTap: () {
          // Handle tap by navigating to the appropriate screen
          _navigateToHome();
        },
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              GestureDetector(
                child: Text(
                  'MoViSon',
                  style: TextStyle(
                    fontSize: getProportionateScreenWidth(36),
                    color: Color.fromARGB(255, 47, 86, 231),
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
