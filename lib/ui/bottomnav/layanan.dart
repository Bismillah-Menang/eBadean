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
      body: SafeArea(
        child: RefreshIndicator(
          onRefresh: () async {
            setState(() {
              _layananListFuture = fetchData();
            });
          },
          child: FutureBuilder<LayananList>(
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
                      bottom: 85.0,
                      left: 20.0,
                      right: 20.0,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Center(
                          child: Text(
                            "Layanan",
                            style: TextStyle(
                              color: Colors.black,
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
                        SizedBox(height: 35.0),
                        ListView.builder(
                          shrinkWrap: true,
                          physics: NeverScrollableScrollPhysics(),
                          itemCount: layananList.data?.length,
                          itemBuilder: (context, index) {
                            final layanan = layananList.data![index];
                            return Padding(
                              padding: EdgeInsets.only(bottom: 20.0),
                              child: InkWell(
                                borderRadius: BorderRadius.circular(15.0),
                                child: Container(
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(15.0),
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.grey.withOpacity(0.5),
                                        spreadRadius: 1,
                                        blurRadius: 3,
                                        offset: Offset(0, 2),
                                      ),
                                    ],
                                  ),
                                  child: Material(
                                    borderRadius: BorderRadius.circular(15.0),
                                    color: Theme.of(context).backgroundColor,
                                    child: InkWell(
                                      borderRadius: BorderRadius.circular(15.0),
                                      onTap: () {
                                        if (layanan.id == 1) {
                                          Navigator.pushNamed(context,
                                              '/suratketerangantidakmampu');
                                        } else if (layanan.id == 2) {
                                          Navigator.pushNamed(
                                              context, '/suratizinusaha');
                                        } else {
                                          print(
                                              'No matching route for ${layanan.id}');
                                        }
                                      },
                                      child: Padding(
                                        padding: const EdgeInsets.all(15.0),
                                        child: Row(
                                          children: [
                                            CircleAvatar(
                                              radius: 25,
                                              backgroundColor:
                                                  Color(0xFFEBF0FF),
                                              child: Icon(
                                                Icons.insert_drive_file,
                                                color: Color(0xFF0046F8),
                                              ),
                                            ),
                                            SizedBox(width: 15.0),
                                            Expanded(
                                              child: Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  Text(
                                                    layanan.nama_layanan,
                                                    style: TextStyle(
                                                      fontFamily: 'Poppins',
                                                      fontSize: 14.0,
                                                      fontWeight:
                                                          FontWeight.bold,
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
        ),
      ),
    );
  }
}
