import 'package:e_badean/ip.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:e_badean/models/riwayat.dart';
import 'package:e_badean/models/user.dart';
import 'package:e_badean/database/db_helper.dart';
import 'package:shared_preferences/shared_preferences.dart';

class RiwayatPage extends StatefulWidget {
  @override
  _RiwayatPageState createState() => _RiwayatPageState();
}

class _RiwayatPageState extends State<RiwayatPage> {
  late Future<List<Riwayat>> _riwayatFuture;

  @override
  void initState() {
    super.initState();
    _riwayatFuture = fetchRiwayat();
  }

  Future<List<Riwayat>> fetchRiwayat() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final String? token = prefs.getString('token');
    if (token != null) {
      final User? user = await DBHelper.getUserFromLocal(token);
      final int? idPenduduk = user?.id;
      if (idPenduduk != null) {
        final Uri uri =
            Uri.parse('${ApiConfig.baseUrl}/api/riwayat/$idPenduduk');
        final response = await http.get(uri);

        if (response.statusCode == 200) {
          final Map<String, dynamic>? responseData = json.decode(response.body);
          if (responseData != null && responseData.containsKey('data')) {
            final List<dynamic> jsonData =
                responseData['data'] as List<dynamic>;
            return jsonData.map((data) => Riwayat.fromJson(data)).toList();
          } else {
            throw Exception('Invalid API response: data not found');
          }
        } else {
          throw Exception('Failed to load riwayat');
        }
      } else {
        throw Exception('ID Penduduk is null');
      }
    } else {
      throw Exception('Token is null');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: RefreshIndicator(
          onRefresh: () async {
            setState(() {
              _riwayatFuture = fetchRiwayat();
            });
          },
          child: SingleChildScrollView(
            physics: AlwaysScrollableScrollPhysics(),
            child: Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 20.0, vertical: 20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Center(
                    child: Text(
                      'Riwayat',
                      style: TextStyle(
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
                        hintText: 'Cari Riwayat Pengajuan',
                        hintStyle: TextStyle(
                          color: Colors.grey[700],
                          fontFamily: 'Poppins',
                          fontSize: 14,
                        ),
                        border: InputBorder.none,
                        contentPadding: EdgeInsets.symmetric(
                            horizontal: 15.0, vertical: 13.5),
                        prefixIcon: Icon(Icons.search),
                      ),
                    ),
                  ),
                  SizedBox(height: 35.0),
                  FutureBuilder<List<Riwayat>>(
                    future: _riwayatFuture,
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return Center(child: CircularProgressIndicator());
                      } else if (snapshot.hasError) {
                        return Center(child: Text('Error: ${snapshot.error}'));
                      } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                        return Center(
                          child: Text(
                            'Tidak ada riwayat',
                            style: TextStyle(
                              fontSize: 18.0,
                              fontFamily: 'Poppins',
                              fontWeight: FontWeight.w600,
                              color: Colors.grey[600],
                            ),
                          ),
                        );
                      } else {
                        return ListView.builder(
                          shrinkWrap: true,
                          physics: NeverScrollableScrollPhysics(),
                          itemCount: snapshot.data!.length,
                          itemBuilder: (context, index) {
                            final riwayat = snapshot.data![index];
                            return RiwayatItem(riwayat: riwayat);
                          },
                        );
                      }
                    },
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class RiwayatItem extends StatefulWidget {
  final Riwayat riwayat;

  const RiwayatItem({Key? key, required this.riwayat}) : super(key: key);

  @override
  _RiwayatItemState createState() => _RiwayatItemState();
}

class _RiwayatItemState extends State<RiwayatItem> {
  bool _isExpanded = false;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          margin: EdgeInsets.only(bottom: 20.0),
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
              padding: const EdgeInsets.only(
                  top: 15.0, bottom: 15.0, right: 20.0, left: 20.0),
              child: Column(
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              widget.riwayat.namaLayanan,
                              style: TextStyle(
                                fontFamily: 'Poppins',
                                fontSize: 14.0,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            SizedBox(height: 10.0),
                            Row(
                              children: [
                                Text(
                                  widget.riwayat.tanggal,
                                  style: TextStyle(
                                    fontFamily: 'Poppins',
                                    fontSize: 12.0,
                                    color: Colors.grey[600],
                                  ),
                                ),
                                Spacer(),
                                Text(
                                  widget.riwayat.status == 'Diproses'
                                      ? 'Diproses'
                                      : 'Selesai',
                                  style: TextStyle(
                                    fontFamily: 'Poppins',
                                    fontSize: 14.0,
                                    fontWeight: FontWeight.bold,
                                    color:
                                        _getStatusColor(widget.riwayat.status),
                                  ),
                                ),
                              ],
                            ),
                            Center(
                              child: InkWell(
                                borderRadius: BorderRadius.circular(10.0),
                                onTap: () {
                                  setState(() {
                                    _isExpanded = !_isExpanded;
                                  });
                                },
                                child: AnimatedContainer(
                                  duration: Duration(milliseconds: 300),
                                  width: _isExpanded ? 75.0 : 75.0,
                                  child: Icon(
                                    _isExpanded
                                        ? Icons.expand_less
                                        : Icons.expand_more,
                                    size: 24.0,
                                    color: Colors.grey,
                                  ),
                                ),
                              ),
                            )
                          ],
                        ),
                      ),
                    ],
                  ),
                  if (_isExpanded)
                    ProsesPengajuan(status: widget.riwayat.status),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  Color _getStatusColor(String status) {
    switch (status) {
      case 'Diproses':
        return Color(0xFF1548AD);
      case 'Disetujui':
        return Color.fromRGBO(29, 216, 163, 1);
      case 'Ditolak':
        return const Color.fromARGB(255, 255, 17, 0);
      default:
        return Colors.grey[600]!;
    }
  }
}

class ProsesPengajuan extends StatelessWidget {
  final String status;

  const ProsesPengajuan({Key? key, required this.status}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          margin: EdgeInsets.symmetric(vertical: 10.0),
          padding: EdgeInsets.all(10.0),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(15.0),
            color: Color(0xFFEEEDF3),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Proses Pengajuan',
                style: TextStyle(
                  fontSize: 14.0,
                  fontFamily: 'Poppins',
                ),
              ),
              SizedBox(height: 10.0),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _buildIndicator('Dibaca', status == 'Diproses'),
                  _buildLine(),
                  _buildIndicator('Disetujui', status == 'Disetujui'),
                  _buildLine(),
                  _buildIndicator('Ditolak', status == 'Ditolak'),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildLine() {
    return Container(
      width: 45.0,
      height: 2.0,
      color: Colors.grey[500],
    );
  }

  Widget _buildIndicator(String label, bool isActive) {
    Color? indicatorColor;
    switch (label) {
      case 'Dibaca':
        indicatorColor = Color(0xFF1548AD);
        break;
      case 'Ditolak':
        indicatorColor = const Color.fromARGB(255, 255, 17, 0);
        break;
      case 'Disetujui':
        indicatorColor = Color.fromRGBO(29, 216, 163, 1);
        break;
      default:
        indicatorColor = Colors.grey[500];
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Container(
          width: 20.0,
          height: 20.0,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: isActive ? indicatorColor : Colors.grey[500],
          ),
        ),
        SizedBox(height: 5.0),
        Text(
          label,
          style: TextStyle(
            fontFamily: 'Poppins',
            fontSize: 12.0,
            color: Colors.grey[600],
          ),
        ),
      ],
    );
  }
}
