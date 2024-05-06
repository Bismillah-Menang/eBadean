import 'package:e_badean/ip.dart';
import 'package:e_badean/models/layanan.dart';
import 'package:e_badean/models/berita.dart';
import 'package:e_badean/ui/detail/detailberita.dart';
import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

class Home extends StatefulWidget {
  const Home({Key? key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  Future<LayananList> fetchLayanan() async {
    final response =
        await http.get(Uri.parse('${ApiConfig.baseUrl}/api/layanan'));

    if (response.statusCode == 200) {
      Map<String, dynamic> jsonData = json.decode(response.body);
      LayananList layananList = LayananList.fromJson(jsonData);
      return layananList;
    } else {
      throw Exception('Failed to load data');
    }
  }

  Future<BeritaList> fetchBerita() async {
    final response =
        await http.get(Uri.parse('${ApiConfig.baseUrl}/api/berita'));

    if (response.statusCode == 200) {
      Map<String, dynamic> jsonData = json.decode(response.body);
      BeritaList beritaList = BeritaList.fromJson(jsonData);
      return beritaList;
    } else {
      throw Exception('Failed to load data');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.only(
              top: 20.0,
              bottom: 75.0,
              left: 20.0,
              right: 20.0,
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
                SizedBox(height: 5.0),
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
                          TextButton(
                            onPressed: () {
                              Navigator.pushNamed(context, '/layanan');
                            },
                            child: Text(
                              "Lihat Semua",
                              style: TextStyle(
                                  color: Colors.black,
                                  fontFamily: 'Poppins',
                                  fontSize: 12),
                            ),
                          ),
                        ],
                      ),
                      FutureBuilder<LayananList>(
                        future: fetchLayanan(),
                        builder: (context, snapshot) {
                          if (snapshot.connectionState ==
                              ConnectionState.waiting) {
                            return CircularProgressIndicator();
                          } else if (snapshot.hasError) {
                            return Text('Error: ${snapshot.error}');
                          } else {
                            final layananData =
                                snapshot.data?.data?.take(8).toList() ?? [];
                            return GridView.builder(
                              shrinkWrap: true,
                              padding: EdgeInsets.only(top: 5.0, bottom: 20.0),
                              gridDelegate:
                                  SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: 4,
                                mainAxisSpacing: 15.0,
                                crossAxisSpacing: 12.0,
                              ),
                              itemCount: layananData.length,
                              itemBuilder: (context, index) {
                                Layanan layanan = layananData[index];
                                return RoundedIconButton(
                                  onTap: () {
                                    Navigator.pushNamed(
                                        context, '/detaillayanan',
                                        arguments: layanan.nama_layanan);
                                  },
                                  icon: Icon(Icons.insert_drive_file,
                                      size: 30.0, color: Color(0xFF0046F8)),
                                  color: Color(0xFFEBF0FF),
                                  label: layanan.nama_layanan,
                                );
                              },
                            );
                          }
                        },
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
                FutureBuilder<BeritaList>(
                  future: fetchBerita(),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return Center(child: CircularProgressIndicator());
                    } else if (snapshot.hasError) {
                      return Center(child: Text('Error: ${snapshot.error}'));
                    } else {
                      final beritaList = snapshot.data!;
                      return SingleChildScrollView(
                        physics: NeverScrollableScrollPhysics(),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: beritaList.data!.map((berita) {
                            return Padding(
                              padding: EdgeInsets.only(bottom: 20.0),
                              child: InkWell(
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => DetailBerita(
                                        judul: berita.judul_berita,
                                        tgl: berita.tgl_berita,
                                        isi: berita.isi_berita,
                                        foto: berita.foto_berita,
                                      ),
                                    ),
                                  );
                                },
                                borderRadius: BorderRadius.circular(15.0),
                                child: Container(
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(15.0),
                                    border: Border.all(
                                      color: Colors.black.withOpacity(0.6),
                                    ),
                                  ),
                                  child: Padding(
                                    padding: const EdgeInsets.all(15.0),
                                    child: Row(
                                      children: [
                                        Container(
                                          width: 65.0,
                                          height: 60.0,
                                          decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(10.0),
                                          ),
                                          clipBehavior: Clip.antiAlias,
                                          child: Image.memory(
                                            berita.foto_berita,
                                            fit: BoxFit
                                                .cover, // Sesuaikan dengan kebutuhan Anda
                                          ),
                                        ),
                                        SizedBox(width: 15.0),
                                        Expanded(
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                berita.judul_berita,
                                                style: TextStyle(
                                                  fontFamily: 'Poppins',
                                                  fontSize: 14.0,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ),
                                              SizedBox(height: 5.0),
                                              Text(
                                                '${berita.tgl_berita}',
                                                style: TextStyle(
                                                  fontFamily: 'Poppins',
                                                  fontSize: 12.0,
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
                            );
                          }).toList(),
                        ),
                      );
                    }
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class RoundedIconButton extends StatelessWidget {
  final VoidCallback? onTap;
  final Widget icon;
  final Color? color;
  final String? label;

  const RoundedIconButton({
    Key? key,
    required this.onTap,
    required this.icon,
    this.color,
    this.label,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Material(
      color: color,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(40.0),
      ),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(40.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              child: icon,
            ),
            SizedBox(height: 7),
            Flexible(
              child: Text(
                label ?? '',
                textAlign: TextAlign.center,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  fontSize: 12.0,
                  fontFamily: 'Poppins',
                  color: Color(0xFF000000),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
