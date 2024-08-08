import 'dart:io';

import 'package:firebase_app_check/firebase_app_check.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:movison/routes.dart';

import 'package:movison/screens/MobileAuth/authprovider.dart';
import 'package:movison/screens/splash/splash_screen.dart';
import 'package:provider/provider.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
     // Initialize Firebase App
  await Firebase.initializeApp(
    options: Platform.isAndroid
        ? const FirebaseOptions(
            apiKey: 'AIzaSyDI9W5yu6EvIrsSD0Fp4Qp86ECkSwnLghg',
            appId: '1:1007217420625:android:c75cf6a9c1b6ed78c98b70',
            messagingSenderId: '1007217420625',
            projectId: 'movisonapp-87387',
            storageBucket: 'movisonapp-87387.appspot.com',
          )
        : null,
  );

  // Activate Firebase App Check
  await FirebaseAppCheck.instance.activate(
    androidProvider: AndroidProvider.playIntegrity,
  );
    SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]).then((_) {
    runApp(const MyApp());
  });

  

}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // SizeConfig().init(context);
    

    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthProvider()),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        initialRoute: SplashScreen.routeName,
        routes: routes,
        //home: RootApp(),
      ),
    );
  }
}
