import 'package:flutter/material.dart';
import 'package:e_badean/ui/bottomnav/home.dart';
import 'package:e_badean/ui/bottomnav/layanan.dart';
import 'package:e_badean/ui/bottomnav/berita.dart';
import 'package:e_badean/ui/bottomnav/profil.dart';
import 'package:e_badean/ui/bottomnav/riwayat.dart';

class BottomNavBar extends StatefulWidget {
  const BottomNavBar({Key? key});

  @override
  State<BottomNavBar> createState() => _BottomNavBarState();
}

class _BottomNavBarState extends State<BottomNavBar> {
  int _currentIndex = 0;
  final List<Widget> _pages = [
    Home(),
    Berita(),
    Layanan(),
    Riwayat(),
    Profil(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          IndexedStack(
            index: _currentIndex,
            children: _pages,
          ),
          Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            child: Container(
              height: 65,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(30),
                  topRight: Radius.circular(30),
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.6),
                    blurRadius: 25,
                    offset: const Offset(3, 18),
                  ),
                ],
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(30),
                child: BottomNavigationBar(
                  selectedItemColor: Color(0xFF1548AD),
                  unselectedItemColor: Colors.grey[700],
                  currentIndex: _currentIndex,
                  onTap: (index) {
                    setState(() {
                      _currentIndex = index;
                    });
                  },
                  items: [
                    BottomNavigationBarItem(
                      icon: Icon(Icons.home),
                      label: "Home",
                    ),
                    BottomNavigationBarItem(
                      icon: Icon(Icons.newspaper),
                      label: "Berita",
                    ),
                    BottomNavigationBarItem(
                      icon: Icon(Icons.sticky_note_2),
                      label: "Layanan",
                    ),
                    BottomNavigationBarItem(
                      icon: Icon(Icons.history),
                      label: "Riwayat",
                    ),
                    BottomNavigationBarItem(
                      icon: Icon(Icons.person),
                      label: "Profil",
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
