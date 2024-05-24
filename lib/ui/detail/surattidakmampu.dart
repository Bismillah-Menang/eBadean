import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:e_badean/database/db_helper.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:intl/intl.dart';
import 'package:e_badean/ip.dart';
import 'package:e_badean/models/user.dart';
import 'package:e_badean/models/formulir.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SuratKeteranganTidakMampu extends StatefulWidget {
  @override
  _SuratKeteranganTidakMampuState createState() =>
      _SuratKeteranganTidakMampuState();
}

class _SuratKeteranganTidakMampuState extends State<SuratKeteranganTidakMampu> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController namaController = TextEditingController();
  final TextEditingController tempatLahirController = TextEditingController();
  final TextEditingController tanggalLahirController = TextEditingController();
  final TextEditingController sekolahController = TextEditingController();
  final TextEditingController alamatController = TextEditingController();
  final TextEditingController namaOrangTuaController = TextEditingController();
  final TextEditingController pekerjaanController = TextEditingController();
  final TextEditingController alamatortuController = TextEditingController();

  String _jenisKelamin = '';
  String _jenisKelaminOrangTua = '';
  DateTime? _pickedDate;

  late Future<Formulir?> _formulirFuture;

  @override
  void initState() {
    super.initState();
    _formulirFuture = fetchFormulirData();
    _populateUserData();
  }

  Future<Formulir?> fetchFormulirData() async {
    final response =
        await http.get(Uri.parse('${ApiConfig.baseUrl}/api/formulir/1'));

    if (response.statusCode == 200) {
      Map<String, dynamic> jsonData = json.decode(response.body);
      if (jsonData['data'] != null && jsonData['data'].isNotEmpty) {
        return Formulir.fromJson(jsonData['data'][0]);
      }
    } else {
      throw Exception('Failed to load data');
    }
    return null;
  }

  Future<void> _populateUserData() async {
    User? user = await _getUserFromLocal();
    if (user != null) {
      setState(() {
        namaController.text = user.nama_lengkap;
        alamatController.text = user.alamat ?? '';

        if (user.tanggal_lahir != null) {
          final dateParts = user.tanggal_lahir!.split('-');
          if (dateParts.length == 3) {
            _pickedDate = DateTime(
              int.parse(dateParts[2]),
              int.parse(dateParts[1]),
              int.parse(dateParts[0]),
            );
            tanggalLahirController.text =
                DateFormat('dd-MM-yyyy').format(_pickedDate!);
          }
        }

        if (user.jenis_kelamin != null) {
          _jenisKelamin = user.jenis_kelamin!;
        } else {
          _jenisKelamin = '';
        }
      });
    }
  }

  Future<User?> _getUserFromLocal() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('token');
    if (token != null) {
      return DBHelper.getUserFromLocal(token);
    } else {
      return null;
    }
  }

  Future<void> _kirimDataPengajuan(Map<String, dynamic> data) async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? token = prefs.getString('token');
      if (token != null) {
        User? user = await DBHelper.getUserFromLocal(token);
        if (user != null) {
          data['id_penduduk'] = user.id;
          final response = await http.post(
            Uri.parse('${ApiConfig.baseUrl}/api/pengajuan'),
            headers: {
              'Content-Type': 'application/json',
              'Accept': 'application/json',
            },
            body: json.encode(data),
          );

          if (response.statusCode == 201) {
            print('Data berhasil dikirim');
            AwesomeDialog(
              context: context,
              dialogType: DialogType.success,
              animType: AnimType.bottomSlide,
              title: 'Sukses',
              desc: 'Data formulir berhasil dikirim!',
              btnOkOnPress: () {
                Navigator.pop(context);
              },
            )..show();
          } else {
            AwesomeDialog(
              context: context,
              dialogType: DialogType.error,
              animType: AnimType.bottomSlide,
              title: 'Gagal',
              desc: 'Gagal mengirim formulir, silakan coba lagi.',
            )..show();
          }
        } else {
          print('Pengguna tidak ditemukan di database lokal');
        }
      } else {
        print('Token tidak tersedia');
      }
    } catch (error) {
      print('Error mengirim data pengajuan: $error');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Surat Tidak Mampu',
          style: TextStyle(
            fontSize: 18.0,
            fontFamily: 'Poppins',
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
        child: FutureBuilder<Formulir?>(
          future: _formulirFuture,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(child: CircularProgressIndicator());
            } else if (snapshot.hasError) {
              return Center(child: Text('Error: ${snapshot.error}'));
            } else if (!snapshot.hasData || snapshot.data == null) {
              return Center(child: Text('Data formulir kosong'));
            } else {
              return Form(
                key: _formKey,
                child: ListView(
                  children: <Widget>[
                    Center(
                      child: Text(
                        "Isikan semua data di bawah ini untuk melanjutkan pengajuan surat.",
                        style: TextStyle(
                          fontSize: 15,
                          fontFamily: 'Poppins',
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                    SizedBox(height: 20.0),
                    TextFormField(
                      controller: namaController,
                      decoration: InputDecoration(
                        labelText: 'Nama',
                        labelStyle: TextStyle(fontSize: 14.0),
                        prefixIcon: Icon(Icons.person),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(15),
                          borderSide: BorderSide(color: Colors.grey),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(15),
                          borderSide: BorderSide(
                            color: Color(0xFF1548AD),
                          ),
                        ),
                        contentPadding: EdgeInsets.symmetric(vertical: 10.0),
                      ),
                      validator: (value) =>
                          value!.isEmpty ? 'Nama tidak boleh kosong' : null,
                    ),
                    SizedBox(height: 20),
                    TextFormField(
                      controller: tempatLahirController,
                      decoration: InputDecoration(
                        labelText: 'Tempat Lahir',
                        labelStyle: TextStyle(fontSize: 14.0),
                        prefixIcon: Icon(Icons.location_city),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(15),
                          borderSide: BorderSide(color: Colors.grey),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(15),
                          borderSide: BorderSide(
                            color: Color(0xFF1548AD),
                          ),
                        ),
                        contentPadding: EdgeInsets.symmetric(vertical: 10.0),
                      ),
                      validator: (value) => value!.isEmpty
                          ? 'Tempat Lahir tidak boleh kosong'
                          : null,
                    ),
                    SizedBox(height: 20),
                    TextFormField(
                      controller: tanggalLahirController,
                      decoration: InputDecoration(
                        labelText: 'Tanggal Lahir',
                        labelStyle: TextStyle(fontSize: 14.0),
                        prefixIcon: Icon(Icons.calendar_today),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(15),
                          borderSide: BorderSide(color: Colors.grey),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(15),
                          borderSide: BorderSide(
                            color: Color(0xFF1548AD),
                          ),
                        ),
                        contentPadding: EdgeInsets.symmetric(vertical: 10.0),
                      ),
                      validator: (value) => value!.isEmpty
                          ? 'Tanggal Lahir tidak boleh kosong'
                          : null,
                    ),
                    SizedBox(height: 5),
                    Row(
                      children: <Widget>[
                        Expanded(
                          child: RadioListTile<String>(
                            contentPadding: EdgeInsets.zero,
                            title: Text(
                              'Laki-laki',
                              style: TextStyle(
                                fontSize: 14.0,
                                fontFamily: 'Poppins',
                              ),
                            ),
                            value: 'laki-laki',
                            groupValue: _jenisKelamin,
                            onChanged: (value) {
                              setState(() {
                                _jenisKelamin = value!;
                              });
                            },
                          ),
                        ),
                        Expanded(
                          child: RadioListTile<String>(
                            contentPadding: EdgeInsets.zero,
                            title: Text(
                              'Perempuan',
                              style: TextStyle(
                                fontSize: 14.0,
                                fontFamily: 'Poppins',
                              ),
                            ),
                            value: 'perempuan',
                            groupValue: _jenisKelamin,
                            onChanged: (value) {
                              setState(() {
                                _jenisKelamin = value!;
                              });
                            },
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 5),
                    TextFormField(
                      controller: sekolahController,
                      decoration: InputDecoration(
                        labelText: 'Sekolah',
                        labelStyle: TextStyle(fontSize: 14.0),
                        prefixIcon: Icon(Icons.school),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(15),
                          borderSide: BorderSide(color: Colors.grey),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(15),
                          borderSide: BorderSide(
                            color: Color(0xFF1548AD),
                          ),
                        ),
                        contentPadding: EdgeInsets.symmetric(vertical: 10.0),
                      ),
                      validator: (value) =>
                          value!.isEmpty ? 'Sekolah tidak boleh kosong' : null,
                    ),
                    SizedBox(height: 20),
                    TextFormField(
                      controller: alamatController,
                      decoration: InputDecoration(
                        labelText: 'Alamat',
                        labelStyle: TextStyle(fontSize: 14.0),
                        prefixIcon: Icon(Icons.home),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(15),
                          borderSide: BorderSide(color: Colors.grey),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(15),
                          borderSide: BorderSide(
                            color: Color(0xFF1548AD),
                          ),
                        ),
                        contentPadding: EdgeInsets.symmetric(vertical: 10.0),
                      ),
                      validator: (value) =>
                          value!.isEmpty ? 'Alamat tidak boleh kosong' : null,
                    ),
                    SizedBox(height: 40),
                    Text(
                      "Data Orang Tua: ",
                      style: TextStyle(
                          fontSize: 15,
                          fontFamily: 'Poppins',
                          fontWeight: FontWeight.w600,
                          color: Colors.black),
                      textAlign: TextAlign.start,
                    ),
                    SizedBox(height: 15),
                    TextFormField(
                      controller: namaOrangTuaController,
                      decoration: InputDecoration(
                        labelText: 'Nama Orang Tua',
                        labelStyle: TextStyle(fontSize: 14.0),
                        prefixIcon: Icon(Icons.people),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(15),
                          borderSide: BorderSide(color: Colors.grey),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(15),
                          borderSide: BorderSide(
                            color: Color(0xFF1548AD),
                          ),
                        ),
                        contentPadding: EdgeInsets.symmetric(vertical: 10.0),
                      ),
                      validator: (value) => value!.isEmpty
                          ? 'Nama Orang Tua tidak boleh kosong'
                          : null,
                    ),
                    Row(
                      children: <Widget>[
                        Expanded(
                          child: RadioListTile<String>(
                            contentPadding: EdgeInsets.zero,
                            title: Text(
                              'Laki-laki',
                              style: TextStyle(
                                fontSize: 14.0,
                                fontFamily: 'Poppins',
                              ),
                            ),
                            value: 'laki-laki',
                            groupValue: _jenisKelaminOrangTua,
                            onChanged: (value) {
                              setState(() {
                                _jenisKelaminOrangTua = value!;
                              });
                            },
                          ),
                        ),
                        Expanded(
                          child: RadioListTile<String>(
                            contentPadding: EdgeInsets.zero,
                            title: Text(
                              'Perempuan',
                              style: TextStyle(
                                fontSize: 14.0,
                                fontFamily: 'Poppins',
                              ),
                            ),
                            value: 'perempuan',
                            groupValue: _jenisKelaminOrangTua,
                            onChanged: (value) {
                              setState(() {
                                _jenisKelaminOrangTua = value!;
                              });
                            },
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 5),
                    TextFormField(
                      controller: pekerjaanController,
                      decoration: InputDecoration(
                        labelText: 'Pekerjaan',
                        labelStyle: TextStyle(fontSize: 14.0),
                        prefixIcon: Icon(Icons.work),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(15),
                          borderSide: BorderSide(color: Colors.grey),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(15),
                          borderSide: BorderSide(
                            color: Color(0xFF1548AD),
                          ),
                        ),
                        contentPadding: EdgeInsets.symmetric(vertical: 10.0),
                      ),
                      validator: (value) => value!.isEmpty
                          ? 'Pekerjaan tidak boleh kosong'
                          : null,
                    ),
                    SizedBox(height: 20),
                    TextFormField(
                      controller: alamatortuController,
                      decoration: InputDecoration(
                        labelText: 'Alamat',
                        labelStyle: TextStyle(fontSize: 14.0),
                        prefixIcon: Icon(Icons.home),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(15),
                          borderSide: BorderSide(color: Colors.grey),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(15),
                          borderSide: BorderSide(
                            color: Color(0xFF1548AD),
                          ),
                        ),
                        contentPadding: EdgeInsets.symmetric(vertical: 10.0),
                      ),
                      validator: (value) =>
                          value!.isEmpty ? 'Alamat tidak boleh kosong' : null,
                    ),
                    SizedBox(height: 20),
                    ElevatedButton(
                      onPressed: () {
                        if (_formKey.currentState!.validate()) {
                          String nama = namaController.text;
                          String tempatLahir = tempatLahirController.text;
                          String tanggalLahir = tanggalLahirController.text;
                          String sekolah = sekolahController.text;
                          String alamat = alamatController.text;
                          String namaOrangTua = namaOrangTuaController.text;
                          String pekerjaan = pekerjaanController.text;
                          String alamatOrtu = alamatortuController.text;

                          String jenisKelamin = _jenisKelamin;
                          String jenisKelaminOrtu = _jenisKelaminOrangTua;

                          Map<String, dynamic> data = {
                            'id_layanan': 1,
                            'tgl_pengajuan':
                                DateFormat('yyyy-MM-dd').format(DateTime.now()),
                            'status': 'Diproses',
                            'catatan': 'Menunggu verifikasi dokumen',
                            'id_rt': null,
                            'id_rw': null,
                            'id_admin': null,
                            'fields': [
                              {'nama_field': 'Nama', 'value': nama},
                              {
                                'nama_field': 'Tempat Lahir',
                                'value': tempatLahir
                              },
                              {
                                'nama_field': 'Tanggal Lahir',
                                'value': tanggalLahir
                              },
                              {
                                'nama_field': 'Jenis Kelamin',
                                'value': jenisKelamin
                              },
                              {'nama_field': 'Sekolah', 'value': sekolah},
                              {'nama_field': 'Alamat', 'value': alamat},
                              {
                                'nama_field': 'Nama Orang Tua',
                                'value': namaOrangTua
                              },
                              {
                                'nama_field': 'Jenis Kelamin Orang Tua',
                                'value': jenisKelaminOrtu
                              },
                              {'nama_field': 'Pekerjaan', 'value': pekerjaan},
                              {
                                'nama_field': 'Alamat Orang Tua',
                                'value': alamatOrtu
                              },
                            ],
                          };

                          _kirimDataPengajuan(data);
                        }
                      },
                      child: Text(
                        "KIRIM",
                        style: TextStyle(
                            fontSize: 16,
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontFamily: 'Poppins'),
                      ),
                      style: ElevatedButton.styleFrom(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15),
                        ),
                        padding: EdgeInsets.symmetric(vertical: 10),
                        backgroundColor: Color.fromRGBO(29, 216, 163, 80),
                        minimumSize: Size(double.infinity, 0),
                      ),
                    ),
                  ],
                ),
              );
            }
          },
        ),
      ),
    );
  }
}
