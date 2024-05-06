import 'package:flutter/material.dart';

class Syarken extends StatefulWidget {
  @override
  SyarkenPageState createState() => SyarkenPageState();
}

class SyarkenPageState extends State<Syarken> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        physics: ClampingScrollPhysics(),
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
            Padding(
              padding: EdgeInsets.only(bottom: 20.0),
              child: Text(
                'I. Definisi dan Lingkup',
                style: TextStyle(
                    fontSize: 14.0,
                    color: Colors.black,
                    fontFamily: 'Poppins',
                    fontWeight: FontWeight.bold),
                textAlign: TextAlign.justify,
              ),
            ),
            Padding(
              padding: EdgeInsets.only(bottom: 20.0),
              child: Text(
                'Aplikasi e-Badean adalah platform digital yang bertujuan untuk menyediakan layanan surat menyurat secara elektronik kepada masyarakat Kabupaten Bondowoso. Lingkup layanan termasuk, namun tidak terbatas pada, pengiriman surat, pendaftaran dokumen, dan transaksi administrasi lainnya yang berkaitan dengan kebutuhan surat menyurat di wilayah tersebut.',
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
                'II. Penggunaan Aplikasi',
                style: TextStyle(
                    fontSize: 14.0,
                    color: Colors.black,
                    fontFamily: 'Poppins',
                    fontWeight: FontWeight.bold),
                textAlign: TextAlign.justify,
              ),
            ),
            Padding(
              padding: EdgeInsets.only(bottom: 20.0),
              child: Text(
                'Pengguna wajib memiliki akses internet dan perangkat yang memadai untuk mengoperasikan aplikasi ini. Pendaftaran akun diperlukan untuk mengakses seluruh fitur dan layanan yang disediakan dalam aplikasi. Informasi yang diberikan oleh pengguna selama proses pendaftaran haruslah akurat, lengkap, dan mutakhir.',
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
                'III. Keamanan dan Privasi',
                style: TextStyle(
                    fontSize: 14.0,
                    color: Colors.black,
                    fontFamily: 'Poppins',
                    fontWeight: FontWeight.bold),
                textAlign: TextAlign.justify,
              ),
            ),
            Padding(
              padding: EdgeInsets.only(bottom: 20.0),
              child: Text(
                'Pengguna bertanggung jawab atas keamanan dan kerahasiaan akun mereka sendiri. Tidak diperkenankan untuk memberikan informasi akun kepada pihak lain yang tidak berwenang. Aplikasi e-Badean tidak bertanggung jawab atas kerugian atau pelanggaran privasi yang timbul akibat kelalaian atau tindakan tidak aman dari pengguna.',
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
                'IV. Pengiriman Surat dan Transaksi',
                style: TextStyle(
                    fontSize: 14.0,
                    color: Colors.black,
                    fontFamily: 'Poppins',
                    fontWeight: FontWeight.bold),
                textAlign: TextAlign.justify,
              ),
            ),
            Padding(
              padding: EdgeInsets.only(bottom: 20.0),
              child: Text(
                'Pengguna diwajibkan untuk mengisi formulir dengan informasi yang akurat untuk setiap surat atau transaksi yang akan dilakukan melalui aplikasi. Aplikasi e-Badean tidak bertanggung jawab atas kesalahan atau ketidakakuratan informasi yang disediakan oleh pengguna selama proses pengiriman surat atau transaksi.',
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
                'V. Ketentuan Umum',
                style: TextStyle(
                    fontSize: 14.0,
                    color: Colors.black,
                    fontFamily: 'Poppins',
                    fontWeight: FontWeight.bold),
                textAlign: TextAlign.justify,
              ),
            ),
            Padding(
              padding: EdgeInsets.only(bottom: 20.0),
              child: Text(
                'Aplikasi e-Badean berhak untuk mengubah atau memperbarui syarat dan ketentuan tanpa pemberitahuan sebelumnya. Pengguna dianggap menyetujui perubahan tersebut dengan melanjutkan penggunaan aplikasi setelah perubahan syarat dan ketentuan tersebut diberlakukan.',
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
                'VI. Penutup',
                style: TextStyle(
                    fontSize: 14.0,
                    color: Colors.black,
                    fontFamily: 'Poppins',
                    fontWeight: FontWeight.bold),
                textAlign: TextAlign.justify,
              ),
            ),
            Padding(
              padding: EdgeInsets.only(bottom: 20.0),
              child: Text(
                'Aplikasi e-Badean berhak untuk menutup akun pengguna yang melanggar syarat dan ketentuan yang telah ditetapkan. Aplikasi e-Badean juga berhak untuk menonaktifkan layanan jika terjadi pelanggaran atau kegiatan yang tidak sah yang dilakukan oleh pengguna.',
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
                'Kontak',
                style: TextStyle(
                    fontSize: 14.0,
                    color: Colors.black,
                    fontFamily: 'Poppins',
                    fontWeight: FontWeight.bold),
                textAlign: TextAlign.justify,
              ),
            ),
            Padding(
              padding: EdgeInsets.only(bottom: 20.0),
              child: Text(
                'Untuk informasi lebih lanjut atau pertanyaan terkait dengan syarat dan ketentuan, pengguna dapat menghubungi tim dukungan pelanggan melalui informasi yang disediakan dalam aplikasi.',
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
                  showDialog(
                    context: context,
                    builder: (context) => AlertDialog(
                      title: Text("Registrasi Berhasil"),
                      actions: <Widget>[
                        TextButton(
                          onPressed: () {
                            Navigator.pushNamed(context, '/bottomnav');
                          },
                          child: Text('OK'),
                        ),
                      ],
                    ),
                  );
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
