import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:movison/screens/Home/HomeScreen.dart';
import 'package:movison/screens/MobileAuth/mobile_register.dart';
import 'package:movison/screens/MobileAuth/snackbar.dart';
import 'package:movison/size_config.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SplashScreen extends StatefulWidget {
  static String routeName = "/splash";

  const SplashScreen({Key? key}) : super(key: key);

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _circleAnimation;
  late Animation<double> _fadeInAnimation;

  @override
  void initState() {
    super.initState();

    // Initialize animation controller and animations
    _controller = AnimationController(
      duration: const Duration(seconds: 1),
      vsync: this,
    );

    _circleAnimation = CurvedAnimation(
      parent: _controller,
      curve: Curves.easeInOut,
    );

    _fadeInAnimation = CurvedAnimation(
      parent: _controller,
      curve: Interval(0.6, 1.0, curve: Curves.easeIn),
    );

    _controller.forward();

    // Navigation and network check
    _navigateToHome();
    checkNetworkStatus();
  }

  Future<void> checkNetworkStatus() async {
    var connectivityResult = await (Connectivity().checkConnectivity());
    if (connectivityResult == ConnectivityResult.mobile) {
      showSnackBar(context, "Warning: You are using mobile data.");
    } else if (connectivityResult == ConnectivityResult.none) {
      showSnackBar(context, "No internet connection");
    }
  }

  Future<void> _navigateToHome() async {
    await Future.delayed(Duration(milliseconds: 3000));
    SharedPreferences s = await SharedPreferences.getInstance();
    String data = s.getString("user_model") ?? '';
    print("-------------------------------------");
    print(data);

    if (data != '') {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => HomeScreen()),
      );
    } else {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => RegisterScreen()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);

    return Scaffold(
      body: GestureDetector(
        onTap: () {
          _navigateToHome();
        },
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Black Circle with Logo Inside
            Center(
              child: FadeTransition(
                opacity: _circleAnimation,
                child: ScaleTransition(
                  scale: _circleAnimation,
                  child: Container(
                    width: getProportionateScreenWidth(100),
                    height: getProportionateScreenWidth(100),
                    decoration: BoxDecoration(
                      color: Colors.black, // Black circle
                      shape: BoxShape.circle,
                    ),
                    child:FadeTransition(
                opacity: _circleAnimation,
                child: ScaleTransition(
                  scale: _circleAnimation,
                  child: Center(
                    child: ClipRRect(
                   borderRadius: BorderRadius.all(Radius.circular(40)),
                      child: Image.asset(
                        'assets/images/1024.png', // Ensure this image exists in your assets folder
                        width: getProportionateScreenWidth(80),
                        height: getProportionateScreenHeight(80),
                      ),
                    ),
                  ),
                ),
              ), 
                  ),
                ),
              ),
            ),
           // App Name Text
            Center(
              child: FadeTransition(
                opacity: _fadeInAnimation,
                child: Padding(
                  padding: EdgeInsets.only(top: getProportionateScreenHeight(30)),
                  child: Text(
                    'MoViSon',
                    style: TextStyle(
                      fontSize: getProportionateScreenWidth(30),
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                      shadows: [
                        Shadow(
                          offset: Offset(2.0, 2.0),
                          blurRadius: 3.0,
                          color: Colors.black26,
                        ),
                      ],
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

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}
