import 'package:e_badean/ui/bottomnav/layanan.dart';
import 'package:e_badean/ui/bottomnav/bottomnav.dart';
import 'package:e_badean/ui/detail/detaillayanan.dart';
import 'package:e_badean/ui/login/login.dart';
import 'package:e_badean/ui/login/lupas.dart';
import 'package:e_badean/ui/register/register.dart';
import 'package:e_badean/ui/splash.dart';
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
        '/daftar': (context) => Register(),
        '/lupas': (context) => Lupas(),
        '/login': (context) => Login(),
        '/layanan': (context) => Layanan(),
        '/detaillayanan': (context) => DetailLayanan(),
        '/bottomnav': (context) => BottomNavBar(),
      },
    );
  }
}
