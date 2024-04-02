import 'package:flutter/material.dart';

class Syarken extends StatefulWidget {
  @override
  SyarkenPageState createState() => SyarkenPageState();
}

class SyarkenPageState extends State<Syarken> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            Text(
              'Syarat dan Ketentuan',
              style: TextStyle(
                  fontSize: 16.0,
                  fontWeight: FontWeight.bold,
                  fontFamily: 'Poppins'),
            ),
            SizedBox(height: 20.0),
            Padding(
              padding: EdgeInsets.only(bottom: 20.0),
              child: Text(
                'Syarat & ketentuan yang ditetapkan di bawah ini mengatur Pengguna layanan yang yang disediakan oleh E-badean, baik berupa informasi, teks, grafik, atau data lain, unduhan, unggahan, atau menggunakan layanan (secara garis besar disebut sebagai data atau konten). Pengguna disarankan membaca dengan seksama karena dapat berdampak kepada hak dan kewajiban Pengguna di bawah hukum.',
                style: TextStyle(
                    fontSize: 12.0,
                    color: Color(0xFF6A6A6B),
                    fontFamily: 'Poppins'),
                    textAlign: TextAlign.justify,
              ),
            ),
            SizedBox(height: 10.0),
            Padding(
              padding: EdgeInsets.only(bottom: 20.0),
              child: Text(
                'Dengan mendaftar dan/atau menggunakan aplikasi E-Badean, maka Pengguna dianggap telah membaca, mengerti, memahami, dan menyetujui semua isi dalamSyarat & Ketentuan. Syarat & Ketentuan ini merupakan bentuk kesepakatan yang dituangkan dalam sebuah perjanjian yang sah antara Pengguna dengan aplikasi E-Badean. Jika Pengguna tidak menyetujui salah satu, sebagian, atau seluruh isi Syarat & Ketentuan, maka Pengguna tidak diperkenankan menggunakan layanan.',
                style: TextStyle(
                    fontSize: 12.0,
                    color: Color(0xFF6A6A6B),
                    fontFamily: 'Poppins'),
                    textAlign: TextAlign.justify,
              ),
            ),
            SizedBox(height: 10.0),
            Center(
              child: ElevatedButton(
                onPressed: () {
                  // Navigator.push(
                  //   context,
                  //   MaterialPageRoute(builder: (context) => Fullname()),
                  // );
                },
                child: Text(
                  "Register",
                  style: TextStyle(
                      fontSize: 16,
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontFamily: 'Poppins'),
                ),
                style: ElevatedButton.styleFrom(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  padding: EdgeInsets.symmetric(vertical: 10),
                  backgroundColor: Color(0xFF1548AD),
                  minimumSize: Size(double.infinity, 0),
                ),
              ),
            ),
            SizedBox(height: 402.0),
          ],
        ),
      ),
    );
  }
}
