import 'package:flutter/material.dart';

class Home extends StatefulWidget {
  const Home({Key? key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        padding: EdgeInsets.symmetric(
          vertical: 40.0,
          horizontal: 20.0,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Container(
                margin: EdgeInsets.only(bottom: 10.0),
                child: Image.asset(
                  'assets/images/badean_splash.png',
                  width: 245.0,
                  height: 45.0,
                ),
              ),
            ),
            Center(
              child: Stack(
                children: [
                  Image.asset(
                    'assets/images/selamat_datang.png',
                    width: 460.0,
                    height: 190.0,
                  ),
                  Positioned(
                    left: (460.0 - 425.0) / 2,
                    right: (460.0 - 425.0) / 2,
                    top: 120.0,
                    child: Container(
                      height: 40.0,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(20.0),
                      ),
                      child: TextField(
                        decoration: InputDecoration(
                          hintText: 'Search',
                          border: InputBorder.none,
                          contentPadding: EdgeInsets.symmetric(
                              horizontal: 15.0, vertical: 11.0),
                          prefixIcon: Icon(Icons.search),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 20.0),
            Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(right: 15.0),
                        child: Text(
                          'Pelayanan',
                          style: TextStyle(
                            fontSize: 14.0,
                            fontFamily: 'Poppins',
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF000000),
                          ),
                        ),
                      ),
                      Expanded(
                        child: Divider(
                          thickness: 1.5,
                          color: Color(0xFF0046F8),
                        ),
                      ),
                    ],
                  ),
                  GridView.count(
                    crossAxisCount: 4,
                    mainAxisSpacing: 12.0,
                    crossAxisSpacing: 12.0,
                    shrinkWrap: true,
                    padding: EdgeInsets.only(top: 20.0, bottom: 20.0),
                    physics: NeverScrollableScrollPhysics(),
                    children: [
                      RoundedIconButton(
                        onPressed: () {},
                        icon: Icon(Icons.note,
                            size: 30.0, color: Color(0xFF0046F8)),
                        color: Color(0xFFEBF0FF),
                        label: 'Mampu',
                      ),
                      RoundedIconButton(
                        onPressed: () {},
                        icon: Icon(Icons.business,
                            size: 30.0, color: Color(0xFF0046F8)),
                        color: Color(0xFFEBF0FF),
                        label: 'Usaha',
                      ),
                      RoundedIconButton(
                        onPressed: () {},
                        icon: Icon(Icons.location_on,
                            size: 30.0, color: Color(0xFF0046F8)),
                        color: Color(0xFFEBF0FF),
                        label: 'Domisili',
                      ),
                      RoundedIconButton(
                        onPressed: () {},
                        icon: Icon(Icons.bedroom_baby_rounded,
                            size: 30.0, color: Color(0xFF0046F8)),
                        color: Color(0xFFEBF0FF),
                        label: 'Kelahiran',
                      ),
                      RoundedIconButton(
                        onPressed: () {},
                        icon: Icon(Icons.notifications,
                            size: 30.0, color: Color(0xFF0046F8)),
                        color: Color(0xFFEBF0FF),
                        label: 'Kematian',
                      ),
                      RoundedIconButton(
                        onPressed: () {},
                        icon: Icon(Icons.toggle_on,
                            size: 30.0, color: Color(0xFF0046F8)),
                        color: Color(0xFFEBF0FF),
                        label: 'Baik',
                      ),
                      RoundedIconButton(
                        onPressed: () {},
                        icon: Icon(Icons.heart_broken,
                            size: 30.0, color: Color(0xFF0046F8)),
                        color: Color(0xFFEBF0FF),
                        label: 'Cerai',
                      ),
                      RoundedIconButton(
                        onPressed: () {},
                        icon: Icon(Icons.price_change,
                            size: 30.0, color: Color(0xFF0046F8)),
                        color: Color(0xFFEBF0FF),
                        label: 'Tanah',
                      ),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(right: 15.0),
                        child: Text(
                          'Rekomendasi Berita',
                          style: TextStyle(
                            fontSize: 14.0,
                            fontFamily: 'Poppins',
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF000000),
                          ),
                        ),
                      ),
                      Expanded(
                        child:
                            Divider(thickness: 1.5, color: Color(0xFF0046F8)),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class RoundedIconButton extends StatelessWidget {
  final VoidCallback? onPressed;
  final Widget icon;
  final Color? color;
  final String? label;

  const RoundedIconButton({
    Key? key,
    required this.onPressed,
    required this.icon,
    this.color,
    this.label,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Material(
      color: color,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(35.0),
      ),
      child: InkWell(
        onTap: onPressed,
        borderRadius: BorderRadius.circular(35.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              child: icon,
            ),
            SizedBox(height: 8),
            Text(
              label ?? '',
              style: TextStyle(
                fontSize: 12.0,
                fontFamily: 'Poppins',
                fontWeight: FontWeight.bold,
                color: Color(0xFF0046F8),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
