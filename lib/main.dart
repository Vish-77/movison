import 'dart:io';

import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

import 'package:movison/routes.dart';

import 'package:movison/screens/MobileAuth/authprovider.dart';
import 'package:movison/screens/splash/splash_screen.dart';
import 'package:provider/provider.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  Platform.isAndroid
      ? await Firebase.initializeApp(
          options: const FirebaseOptions(
              apiKey: 'AIzaSyB4NMyJx4D7SUvx6FStoKhGK0BB7R2Ipu8',
              appId: '1:1083683176319:android:f6d52f5cbbae9d8552244a',
              messagingSenderId: '1083683176319',
              projectId: 'movison',
              storageBucket: 'movison.appspot.com'),
        )
      : await Firebase.initializeApp();
  //Hive.registerAdapter(AdddataAdapter());
  //await Hive.openBox<Add_data>('data');

  runApp(MyApp());
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
