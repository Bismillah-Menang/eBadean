import 'package:e_badean/bottom_nav/bottom_nav.dart';
import 'package:e_badean/login.dart';
import 'package:e_badean/splash.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Color(0xFF1548AD)),
        useMaterial3: true,
        // textTheme: TextTheme(
        //   bodyText1: TextStyle(fontFamily: 'Poppins'),
        // ),
      ),
      debugShowCheckedModeBanner: false,
      initialRoute: '/',
      routes: {
        '/': (context) => Splash(),
        '/login': (context) => Login(),
        '/bottomnav': (context) => BottomNavBar(),
      },
    );
  }
}
