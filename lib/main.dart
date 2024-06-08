import 'package:e_badean/ui/bottomnav/home.dart';
import 'package:e_badean/ui/bottomnav/layanan.dart';
import 'package:e_badean/ui/bottomnav/bottomnav.dart';
import 'package:e_badean/ui/detail/surattidakmampu.dart';
import 'package:e_badean/ui/detail/suratizinusaha.dart'; 
import 'package:e_badean/ui/login/login.dart';
import 'package:e_badean/ui/login/lupas.dart';
import 'package:e_badean/ui/register/register.dart';
import 'package:e_badean/ui/splash.dart';
import 'package:flutter/material.dart';

void main() async {
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
      ),
      debugShowCheckedModeBanner: false,
      initialRoute: '/',
      routes: {
        '/': (context) => Splash(),
        '/daftar': (context) => Register(),
        '/lupas': (context) => Lupas(),
        '/login': (context) => Login(),
        '/layanan': (context) => Layanan(),
        '/home': (context) => Home(),
        '/suratketerangantidakmampu': (context) => SuratKeteranganTidakMampu(),
        '/suratizinusaha': (context) => SuratIzinUsaha(),
        '/bottomnav': (context) => BottomNavBar(),
      },
    );
  }
}
