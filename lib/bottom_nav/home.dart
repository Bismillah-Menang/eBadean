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
        child: Padding(
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
                      left: 18,
                      right: 18,
                      top: 120.0,
                      child: Container(
                        height: 40.0,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(20.0),
                        ),
                        child: TextField(
                          decoration: InputDecoration(
                            hintText: 'Cari',
                            border: InputBorder.none,
                            contentPadding: EdgeInsets.symmetric(
                              horizontal: 15.0,
                              vertical: 11.0,
                            ),
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
                      mainAxisSpacing: 15.0,
                      crossAxisSpacing: 12.0,
                      shrinkWrap: true,
                      padding: EdgeInsets.only(top: 20.0, bottom: 20.0),
                      physics: NeverScrollableScrollPhysics(),
                      children: [
                        SingleChildScrollView(
                          physics: const NeverScrollableScrollPhysics(),
                          child: RoundedIconButton(
                            onPressed: () {},
                            icon: Icon(Icons.note,
                                size: 30.0, color: Color(0xFF0046F8)),
                            color: Color(0xFFEBF0FF),
                            label: 'Surat Tidak Mampu',
                          ),
                        ),
                        SingleChildScrollView(
                          physics: const NeverScrollableScrollPhysics(),
                          child: RoundedIconButton(
                            onPressed: () {},
                            icon: Icon(Icons.business,
                                size: 30.0, color: Color(0xFF0046F8)),
                            color: Color(0xFFEBF0FF),
                            label: 'Surat Usaha',
                          ),
                        ),
                        SingleChildScrollView(
                          physics: const NeverScrollableScrollPhysics(),
                          child: RoundedIconButton(
                            onPressed: () {},
                            icon: Icon(Icons.location_on,
                                size: 30.0, color: Color(0xFF0046F8)),
                            color: Color(0xFFEBF0FF),
                            label: 'Surat Domisili',
                          ),
                        ),
                        SingleChildScrollView(
                          physics: const NeverScrollableScrollPhysics(),
                          child: RoundedIconButton(
                            onPressed: () {},
                            icon: Icon(Icons.bedroom_baby_rounded,
                                size: 30.0, color: Color(0xFF0046F8)),
                            color: Color(0xFFEBF0FF),
                            label: 'Akta Kelahiran',
                          ),
                        ),
                        SingleChildScrollView(
                          physics: const NeverScrollableScrollPhysics(),
                          child: RoundedIconButton(
                            onPressed: () {},
                            icon: Icon(Icons.notifications,
                                size: 30.0, color: Color(0xFF0046F8)),
                            color: Color(0xFFEBF0FF),
                            label: 'Akta Kematian',
                          ),
                        ),
                        SingleChildScrollView(
                          physics: const NeverScrollableScrollPhysics(),
                          child: RoundedIconButton(
                            onPressed: () {},
                            icon: Icon(Icons.toggle_on,
                                size: 30.0, color: Color(0xFF0046F8)),
                            color: Color(0xFFEBF0FF),
                            label: 'Kelakuan Baik',
                          ),
                        ),
                        SingleChildScrollView(
                          physics: const NeverScrollableScrollPhysics(),
                          child: RoundedIconButton(
                            onPressed: () {},
                            icon: Icon(Icons.heart_broken,
                                size: 30.0, color: Color(0xFF0046F8)),
                            color: Color(0xFFEBF0FF),
                            label: 'Surat Perceraian',
                          ),
                        ),
                        SingleChildScrollView(
                          physics: const NeverScrollableScrollPhysics(),
                          child: RoundedIconButton(
                            onPressed: () {},
                            icon: Icon(Icons.price_change,
                                size: 30.0, color: Color(0xFF0046F8)),
                            color: Color(0xFFEBF0FF),
                            label: 'Harga Tanah',
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              SizedBox(height: 10.0),
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
                          child: Divider(
                            thickness: 1.5,
                            color: Color(0xFF0046F8),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              SizedBox(height: 20.0),
              GestureDetector(
                onTap: () {},
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(15.0),
                    border: Border.all(
                      color: Colors.black.withOpacity(0.6),
                    ),
                  ),
                  child: Material(
                    borderRadius: BorderRadius.circular(15.0),
                    color: Colors.white60,
                    child: InkWell(
                      borderRadius: BorderRadius.circular(15.0),
                      onTap: () {},
                      child: Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: Row(
                          children: [
                            Container(
                              width: 60.0,
                              height: 65.0,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10.0),
                              ),
                              child: Image.asset('assets/images/ijen.png'),
                            ),
                            SizedBox(width: 10.0),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Kawah Ijen kembali dibuka pada tanggal 01 April 2024',
                                    style: TextStyle(
                                      fontFamily: 'Poppins',
                                      fontSize: 14.0,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  Text(
                                    '01 April 2024 | 09.00 WIB',
                                    style: TextStyle(
                                      fontFamily: 'Poppins',
                                      fontSize: 12.0,
                                      color: Colors.grey[600],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              SizedBox(height: 20.0),
              GestureDetector(
                onTap: () {},
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(15.0),
                    border: Border.all(
                      color: Colors.black.withOpacity(0.6),
                    ),
                  ),
                  child: Material(
                    borderRadius: BorderRadius.circular(15.0),
                    color: Colors.white60,
                    child: InkWell(
                      borderRadius: BorderRadius.circular(15.0),
                      onTap: () {},
                      child: Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: Row(
                          children: [
                            Container(
                              width: 60.0,
                              height: 65.0,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10.0),
                              ),
                              child: Image.asset('assets/images/culture.png'),
                            ),
                            SizedBox(width: 10.0),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Bondowos culture Night Carnival, Memperkenalkan Seni dan Budaya',
                                    style: TextStyle(
                                      fontFamily: 'Poppins',
                                      fontSize: 14.0,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  Text(
                                    '02 April 2024 | 10.00 WIB',
                                    style: TextStyle(
                                      fontFamily: 'Poppins',
                                      fontSize: 12.0,
                                      color: Colors.grey[600],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              SizedBox(height: 20.0),
              GestureDetector(
                onTap: () {},
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(15.0),
                    border: Border.all(
                      color: Colors.black.withOpacity(0.6),
                    ),
                  ),
                  child: Material(
                    borderRadius: BorderRadius.circular(15.0),
                    color: Colors.white60,
                    child: InkWell(
                      borderRadius: BorderRadius.circular(15.0),
                      onTap: () {},
                      child: Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: Row(
                          children: [
                            Container(
                              width: 60.0,
                              height: 65.0,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10.0),
                              ),
                              child:
                                  Image.asset('assets/images/singoulung.png'),
                            ),
                            SizedBox(width: 10.0),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Mengulik legenda Singo Ulung Bondowoso hingga jadi Culturisite UNESCO',
                                    style: TextStyle(
                                      fontFamily: 'Poppins',
                                      fontSize: 14.0,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  Text(
                                    '02 April 2024 | 19.00 WIB',
                                    style: TextStyle(
                                      fontFamily: 'Poppins',
                                      fontSize: 12.0,
                                      color: Colors.grey[600],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
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
            SizedBox(height: 7),
            Text(
              label ?? '',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 12.0,
                fontFamily: 'Poppins',
                color: Color(0xFF000000),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
