import 'package:e_badean/models/layanan.dart';
import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:e_badean/ip.dart';

class Layanan extends StatefulWidget {
  const Layanan({Key? key}) : super(key: key);

  @override
  State<Layanan> createState() => _LayananPageState();
}

class _LayananPageState extends State<Layanan> {
  late Future<LayananList> _layananListFuture;

  @override
  void initState() {
    super.initState();
    _layananListFuture = fetchData();
  }

  Future<LayananList> fetchData() async {
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Container(
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/images/layanan3.png'),
                fit: BoxFit.cover,
              ),
            ),
          ),
          FutureBuilder<LayananList>(
            future: _layananListFuture,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Center(child: CircularProgressIndicator());
              } else if (snapshot.hasError) {
                return Center(child: Text('Error: ${snapshot.error}'));
              } else {
                final layananList = snapshot.data!;
                return SingleChildScrollView(
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
                        SizedBox(height: 20,),
                        Center(
                          child: Text(
                            "Layanan",
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 20,
                              fontFamily: 'Poppins',
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        SizedBox(height: 20.0),
                        Container(
                          height: 40.0,
                          decoration: BoxDecoration(
                            color: Color(0xFFEEEDF3),
                            borderRadius: BorderRadius.circular(20.0),
                          ),
                          child: TextField(
                            decoration: InputDecoration(
                              hintText: 'Cari Surat',
                              hintStyle: TextStyle(
                                color: Colors.grey[700],
                                fontFamily: 'Poppins',
                                fontSize: 14,
                              ),
                              border: InputBorder.none,
                              contentPadding: EdgeInsets.symmetric(
                                horizontal: 15.0,
                                vertical: 13.5,
                              ),
                              prefixIcon: Icon(Icons.search),
                            ),
                          ),
                        ),
                        SizedBox(height: 25.0),
                        ListView.builder(
                          shrinkWrap: true,
                          physics: NeverScrollableScrollPhysics(),
                          itemCount: layananList.data?.length,
                          itemBuilder: (context, index) {
                            final layanan = layananList.data![index];
                            return Padding(
                              padding: EdgeInsets.only(bottom: 20.0),
                              child: InkWell(
                                onTap: () {
                                  print('Tapped on: ${layanan.nama_layanan}'); // Debug statement
                                  // Navigate to different pages based on layanan.nama_layanan
                                  if (layanan.nama_layanan == 'Surat Tidak Mampu') {
                                    print('Navigating to /suratketerangantidakmampu'); // Debug statement
                                    Navigator.pushNamed(context, '/suratketerangantidakmampu');
                                    } else if (layanan.nama_layanan == 'Surat Izin Usaha') {
                                    Navigator.pushNamed(context, '/suratizinusaha');
                                  } else {
                                    print('No matching route for ${layanan.nama_layanan}'); // Debug statement
                                    // Handle other types or show a message
                                  }
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
                                        CircleAvatar(
                                          radius: 25,
                                          backgroundColor: Color(0xFFEBF0FF),
                                          child: Icon(
                                            Icons.insert_drive_file,
                                            color: Color(0xFF0046F8),
                                          ),
                                        ),
                                        SizedBox(width: 15.0),
                                        Expanded(
                                          child: Column(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                layanan.nama_layanan,
                                                style: TextStyle(
                                                  fontFamily: 'Poppins',
                                                  fontSize: 14.0,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ),
                                              Text(
                                                layanan.info_layanan,
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
                          },
                        ),
                      ],
                    ),
                  ),
                );
              }
            },
          ),
        ],
      ),
    );
  }
}
