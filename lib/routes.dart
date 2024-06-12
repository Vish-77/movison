import 'package:flutter/cupertino.dart';
import 'package:movison/screens/Home/AddStudentDetails.dart';
import 'package:movison/screens/Home/AllCategoryPage.dart';
import 'package:movison/screens/Home/BooksPurchasedDetails.dart';
import 'package:movison/screens/Home/BooksRent.dart';
import 'package:movison/screens/Home/TimeLeftOrOver.dart';
import 'package:movison/screens/splash/splash_screen.dart';


final Map<String, WidgetBuilder> routes = {
  SplashScreen.routeName: (context) => SplashScreen(),
  '/all_rent': (context) => BooksRent(),
  '/add_student_details':(context) => AddStudentdetails(),
  //'/time_left_over':(context)=>TimeLeftOrOver(productId: productId, index: index)
 
  '/book_purchase_details':(context)=>BookPurchasedetails(),
  //'/coding_category_page': (context) => CodingCategoryPage(),
  //Splash.routeName:(context)=>Splash(),
  // SignInScreen.routeName:(context)=>SignInScreen(),
  // LoginSuccessScreen.routeName: (context) => LoginSuccessScreen(),

  // SignUpScreen.routeName: (context) => SignUpScreen(),
  // HomeScreen.routeName: (context) => HomeScreen(),
  //ProfileScreen.routeName: (context) => ProfileScreen(),
  // DetailsScreen.routeName: (context) => DetailsScreen(),
  // ProfileScreen.routeName: (context) => ProfileScreen(),
  // 'mobile_login':(context)=>MobileLogin(),
  // 'mobile_otp':(context)=>MobileOTP(),
  // 'home':(context)=>HomeScreen(),
  // 'login_sucess':(context)=>LoginSuccessScreen(),


  //SplashScreen.routeName: (context) => SplashScreen(),
  //SignInScreen.routeName: (context) => SignInScreen(),
  //ForgotPasswordScreen.routeName: (context) => ForgotPasswordScreen(),
  //LoginSuccessScreen.routeName: (context) => LoginSuccessScreen(),
  //SignUpScreen.routeName: (context) => SignUpScreen(),
  //CompleteProfileScreen.routeName: (context) => CompleteProfileScreen(),
  // OtpScreen.routeName: (context) => OtpScreen(),
  //HomeScreen.routeName: (context) => HomeScreen(),
  //DetailsScreen.routeName: (context) => DetailsScreen(),
  //CartScreen.routeName: (context) => CartScreen(),
  //ProfileScreen.routeName: (context) => ProfileScreen(),
  //AddProduct.routeName:(context) =>AddProduct(txt: "",),
  //MainPage.routeName:(context) =>MainPage()
  //Notifications.routeName:(context)=>Notifications()
  //Chat.routeName: (context) => Chat(),
};
