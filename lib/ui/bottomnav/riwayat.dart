import 'dart:io';
import 'dart:convert';
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:e_badean/ip.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import 'package:path/path.dart' as path;
import 'package:dio/dio.dart';
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

  bool _isExpanded = false;
  bool _isDownloading = false;
  String _progress = "";

  @override
  void initState() {
    super.initState();
    _riwayatFuture = fetchRiwayat();
  }

  Future<List<Riwayat>> fetchRiwayat() async {
    try {
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      final String? token = prefs.getString('token');

      if (token == null) {
        return [];
      }

      final User? user = await DBHelper.getUserFromLocal(token);
      final int? idPenduduk = user?.penduduk?.id;

      final Uri uri = Uri.parse('${ApiConfig.baseUrl}/api/riwayat/$idPenduduk');
      print('Fetching data from: $uri');
      final response = await http.get(uri);

      print('Response body: ${response.body}');

      if (response.statusCode == 200) {
        final Map<String, dynamic>? responseData = json.decode(response.body);
        print('Response data: $responseData');
        if (responseData != null && responseData.containsKey('data')) {
          final List<dynamic> jsonData = responseData['data'] as List<dynamic>;
          return jsonData.map((data) => Riwayat.fromJson(data)).toList();
        } else {
          return [];
        }
      } else {
        return [];
      }
    } catch (error) {
      print('Error fetching riwayat: $error');
      return [];
    }
  }

  Future<void> _downloadFile(String url) async {
    setState(() {
      _isDownloading = true;
      _progress = "0%";
    });

    try {
      final fileName = path.basename(url);
      String directory = '/storage/emulated/0/Download/Ebadean';

      final String filePath = '$directory/$fileName';

      final dio = Dio();
      await dio.download(url, filePath, onReceiveProgress: (received, total) {
        if (total != -1) {
          setState(() {
            _progress = (received / total * 100).toStringAsFixed(0) + "%";
          });
        }
      });

      setState(() {
        _isDownloading = false;
        _progress = "Download completed!";
      });

      Fluttertoast.showToast(
          msg: "Download completed: ${filePath}",
          toastLength: Toast.LENGTH_LONG,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 5,
          backgroundColor: Colors.green,
          textColor: Colors.white,
          fontSize: 16.0);
    } catch (e) {
      setState(() {
        _isDownloading = false;
        _progress = "Download failed!";
      });

      Fluttertoast.showToast(
          msg: "Download failed!",
          toastLength: Toast.LENGTH_LONG,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.red,
          textColor: Colors.white,
          fontSize: 16.0);
    }
  }

  Future<void> _deletePengajuan(int id) async {
    try {
      final url = '${ApiConfig.baseUrl}/api/pengajuan/$id';
      print('Deleting pengajuan at URL: $url');

      final response = await http.delete(Uri.parse(url));

      if (response.statusCode == 200) {
        setState(() {
          _riwayatFuture = fetchRiwayat();
        });
        Fluttertoast.showToast(
            msg: "Pengajuan berhasil dihapus",
            toastLength: Toast.LENGTH_LONG,
            gravity: ToastGravity.BOTTOM,
            timeInSecForIosWeb: 1,
            backgroundColor: Colors.green,
            textColor: Colors.white,
            fontSize: 16.0);
      } else {
        print('Failed to delete pengajuan: ${response.body}');
        Fluttertoast.showToast(
            msg: "Gagal menghapus pengajuan",
            toastLength: Toast.LENGTH_LONG,
            gravity: ToastGravity.BOTTOM,
            timeInSecForIosWeb: 1,
            backgroundColor: Colors.red,
            textColor: Colors.white,
            fontSize: 16.0);
      }
    } catch (e) {
      print('Exception deleting pengajuan: $e');
      Fluttertoast.showToast(
          msg: "Gagal menghapus pengajuan: $e",
          toastLength: Toast.LENGTH_LONG,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.red,
          textColor: Colors.white,
          fontSize: 16.0);
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
              padding: const EdgeInsets.only(
                  top: 20.0, bottom: 85.0, left: 20.0, right: 20.0),
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
                          child: Text('Tidak ada riwayat',
                              style: TextStyle(
                                fontSize: 18.0,
                                fontFamily: 'Poppins',
                                fontWeight: FontWeight.w600,
                                color: Colors.grey[600],
                              )),
                        );
                      } else {
                        return ListView.builder(
                          shrinkWrap: true,
                          physics: NeverScrollableScrollPhysics(),
                          itemCount: snapshot.data!.length,
                          itemBuilder: (context, index) {
                            final riwayat = snapshot.data![index];
                            return RiwayatItem(
                              riwayat: riwayat,
                              onDownloadFile: _downloadFile,
                              onDelete: _deletePengajuan,
                              isDownloading: _isDownloading,
                              progress: _progress,
                            );
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
  final Future<void> Function(String) onDownloadFile;
  final Future<void> Function(int) onDelete;
  final bool isDownloading;
  final String progress;

  const RiwayatItem({
    Key? key,
    required this.riwayat,
    required this.onDownloadFile,
    required this.onDelete,
    required this.isDownloading,
    required this.progress,
  }) : super(key: key);

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
                                  width: 75.0,
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
                  if (_isExpanded) ...[
                    ProsesPengajuan(status: widget.riwayat.status),
                    if (widget.riwayat.fileSuratPath != null) ...[
                      SizedBox(height: 10.0),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          if (widget.riwayat.status == 'Diproses')
                            Center(
                              child: CircleAvatar(
                                radius: 20.0,
                                backgroundColor:
                                    Color.fromARGB(255, 255, 202, 197),
                                child: IconButton(
                                  icon: Icon(Icons.delete,
                                      color: Color.fromARGB(255, 255, 17, 0)),
                                  onPressed: () {
                                    AwesomeDialog(
                                      context: context,
                                      dialogType: DialogType.error,
                                      animType: AnimType.bottomSlide,
                                      titleTextStyle: TextStyle(
                                          fontFamily: 'Poppins',
                                          fontSize: 18,
                                          fontWeight: FontWeight.bold),
                                      title: 'Konfirmasi',
                                      desc:
                                          'Apakah Anda yakin yakin ingin membatalkan pengajuan ?',
                                      descTextStyle:
                                          TextStyle(fontFamily: 'Poppins'),
                                      btnOkText: 'Ya',
                                      btnCancelText: 'Tidak',
                                      btnOkOnPress: () {
                                        widget.onDelete(widget.riwayat.id);
                                      },
                                      btnCancelOnPress: () {},
                                      btnOkColor:
                                          Color.fromRGBO(29, 216, 163, 80),
                                      btnCancelColor: Color(0xFFF90606),
                                    )..show();
                                  },
                                ),
                              ),
                            ),
                          if (widget.riwayat.status == 'Disetujui' ||
                              widget.riwayat.status == 'Diproses')
                            if (widget.riwayat.status == 'Disetujui')
                              Center(
                                child: CircleAvatar(
                                  radius: 20.0,
                                  backgroundColor:
                                      Color.fromRGBO(29, 216, 163, 1),
                                  child: IconButton(
                                    icon: Icon(Icons.download,
                                        color: Colors.white),
                                    onPressed: () {
                                      widget.onDownloadFile(
                                        widget.riwayat.fileSuratPath!,
                                      );
                                    },
                                  ),
                                ),
                              ),
                        ],
                      ),
                      if (widget.isDownloading)
                        Text(
                          'Downloading... ${widget.progress}',
                          style: TextStyle(
                            fontFamily: 'Poppins',
                            fontSize: 14.0,
                            fontWeight: FontWeight.bold,
                            color: Colors.blue,
                          ),
                        ),
                    ],
                    if (widget.riwayat.fileSuratPath == null) ...[
                      SizedBox(height: 10.0),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          if (widget.riwayat.status == 'Diproses')
                            Center(
                              child: CircleAvatar(
                                radius: 20.0,
                                backgroundColor:
                                    Color.fromARGB(255, 255, 202, 197),
                                child: IconButton(
                                  icon: Icon(Icons.delete,
                                      color: Color.fromARGB(255, 255, 17, 0)),
                                  onPressed: () {
                                    AwesomeDialog(
                                      context: context,
                                      dialogType: DialogType.error,
                                      animType: AnimType.bottomSlide,
                                      titleTextStyle: TextStyle(
                                          fontFamily: 'Poppins',
                                          fontSize: 18,
                                          fontWeight: FontWeight.bold),
                                      title: 'Konfirmasi',
                                      desc:
                                          'Apakah Anda yakin yakin ingin membatalkan pengajuan ?',
                                      descTextStyle:
                                          TextStyle(fontFamily: 'Poppins'),
                                      btnOkText: 'Ya',
                                      btnCancelText: 'Tidak',
                                      btnOkOnPress: () {
                                        widget.onDelete(widget.riwayat.id);
                                      },
                                      btnCancelOnPress: () {},
                                      btnOkColor:
                                          Color.fromRGBO(29, 216, 163, 80),
                                      btnCancelColor: Color(0xFFF90606),
                                    )..show();
                                  },
                                ),
                              ),
                            ),
                          if (widget.riwayat.status == 'Disetujui' ||
                              widget.riwayat.status == 'Diproses')
                            if (widget.riwayat.status == 'Disetujui')
                              Center(
                                child: CircleAvatar(
                                  radius: 20.0,
                                  backgroundColor:
                                      Color.fromRGBO(29, 216, 163, 1),
                                  child: IconButton(
                                    icon: Icon(Icons.download,
                                        color: Colors.white),
                                    onPressed: () {
                                      widget.onDownloadFile(
                                        widget.riwayat.fileSuratPath!,
                                      );
                                    },
                                  ),
                                ),
                              ),
                        ],
                      ),
                    ],
                  ],
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
                'Proses  Pengajuan',
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
