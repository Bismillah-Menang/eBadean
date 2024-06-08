import 'dart:convert';
import 'package:e_badean/ip.dart';
import 'package:e_badean/models/berita.dart';
import 'package:e_badean/ui/detail/detailberita.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class Berita extends StatefulWidget {
  const Berita({Key? key});

  @override
  State<Berita> createState() => _BeritaState();
}

class _BeritaState extends State<Berita> {
  late Future<BeritaList> _beritaListFuture;
  TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _beritaListFuture = fetchData();
  }

  Future<BeritaList> fetchData() async {
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
        child: RefreshIndicator(
          onRefresh: () async {
            setState(() {
              _beritaListFuture = fetchData();
            });
          },
          child: FutureBuilder<BeritaList>(
            future: _beritaListFuture,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Center(child: CircularProgressIndicator());
              } else if (snapshot.hasError) {
                return Center(child: Text('Error: ${snapshot.error}'));
              } else {
                final beritaList = snapshot.data!;
                final filteredBeritaList = beritaList.filterByJudul(_searchController.text);

                return SingleChildScrollView(
                  physics: AlwaysScrollableScrollPhysics(),
                  child: Padding(
                    padding: EdgeInsets.all(20.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Center(
                          child: Text(
                            "Berita",
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
                            controller: _searchController,
                            onChanged: (value) {
                              setState(() {});
                            },
                            decoration: InputDecoration(
                              hintText: 'Cari Berita',
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
                          itemCount: filteredBeritaList.length,
                          itemBuilder: (context, index) {
                            final berita = filteredBeritaList[index];
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
                                        sumber: berita.sumber,
                                        foto: berita.foto_berita,
                                      ),
                                    ),
                                  );
                                },
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
                                                  berita.tgl_berita,
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
