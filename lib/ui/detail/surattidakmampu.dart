import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:e_badean/database/db_helper.dart';
import 'package:e_badean/ui/detail/pengajuanoranglain.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:intl/intl.dart';
import 'package:e_badean/ip.dart';
import 'package:e_badean/models/user.dart';
import 'package:e_badean/models/formulir.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:file_picker/file_picker.dart';

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
  final TextEditingController pekerjaanortuController = TextEditingController();
  final TextEditingController alamatortuController = TextEditingController();

  String _jenisKelamin = '';
  String _jenisKelaminOrangTua = '';
  DateTime? _pickedDate;
  String? _fotoKKUrl;
  String? _fotoKTPUrl;
  String? _filePathSPRT;

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
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('token');

    if (token != null) {
      try {
        User? user = await getUserFromToken(token);

        if (user != null) {
          setState(() {
            namaController.text = user.penduduk?.namaLengkap ?? '';
            alamatController.text = user.penduduk?.alamat ?? '';
            tempatLahirController.text = user.penduduk?.tempatLahir ?? '';
            tanggalLahirController.text = user.penduduk?.tanggalLahir ?? '';
            _jenisKelamin = user.penduduk?.jenisKelamin ?? '';
            _fotoKKUrl = user.penduduk?.fotoKk;
            _fotoKTPUrl = user.penduduk?.fotoKtp;
          });
        }
      } catch (error) {
        print("Error retrieving user data: $error");
      }
    } else {
      print("Token not found");
    }
  }

  Future<User?> getUserFromToken(String token) async {
    try {
      String url = "${ApiConfig.baseUrl}/api/get_user";

      final response = await http.get(
        Uri.parse(url),
        headers: <String, String>{
          'Authorization': 'Bearer $token',
        },
      );

      print("Response getUserFromToken: ${response.body}");

      if (response.statusCode == 200) {
        final responseData = json.decode(response.body);
        if (responseData['status'] == true) {
          final userData = responseData['user'];
          if (userData != null) {
            return User.fromJson(userData);
          }
        } else {
          print("Failed to get user data: ${responseData['message']}");
          return null;
        }
      } else {
        print("Failed to get user data: ${response.statusCode}");
        return null;
      }
    } catch (error) {
      print("Error getting user data: $error");
      return null;
    }
  }

  Future<String?> _uploadPhotoSPRT() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('token');

    if (token != null && _filePathSPRT != null) {
      String url = "${ApiConfig.baseUrl}/api/upload_sprt";

      var request = http.MultipartRequest('POST', Uri.parse(url))
        ..headers['Authorization'] = 'Bearer $token'
        ..files.add(await http.MultipartFile.fromPath('value', _filePathSPRT!));

      var response = await request.send();

      if (response.statusCode == 200) {
        var responseBody = await response.stream.bytesToString();
        var responseData = jsonDecode(responseBody);

        print("Response from server: $responseBody");

        if (responseData.containsKey('value')) {
          return responseData['value'];
        } else {
          print("Response does not contain 'path' key");
          return null;
        }
      } else {
        print("Failed to upload file: ${response.statusCode}");
        return null;
      }
    } else {
      print("No file selected");
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
          data['id_penduduk'] = user.penduduk?.id;

          final response = await http.post(
            Uri.parse('${ApiConfig.baseUrl}/api/pengajuan'),
            headers: {
              'Content-Type': 'application/json',
              'Accept': 'application/json',
            },
            body: json.encode(data),
          );

          if (response.statusCode == 201) {
            print('Data berhasil dikirim: ${response.body}');
            AwesomeDialog(
              context: context,
              dialogType: DialogType.success,
              animType: AnimType.bottomSlide,
              titleTextStyle: TextStyle(
                  fontFamily: 'Poppins',
                  fontSize: 18,
                  fontWeight: FontWeight.bold),
              title: 'Sukses',
              desc: 'Data formulir berhasil dikirim!',
              descTextStyle: TextStyle(fontFamily: 'Poppins'),
              btnOkOnPress: () {
                Navigator.pop(context);
              },
            )..show();
          } else {
            print('Error response: ${response.body}');
            AwesomeDialog(
              context: context,
              dialogType: DialogType.error,
              animType: AnimType.bottomSlide,
              titleTextStyle: TextStyle(
                  fontFamily: 'Poppins',
                  fontSize: 18,
                  fontWeight: FontWeight.bold),
              title: 'Gagal',
              desc: 'Gagal mengirim formulir, anda masih memiliki pengajuan yang masih Diproses.',
              descTextStyle: TextStyle(fontFamily: 'Poppins'),
              btnOkOnPress: () {},
              btnOkColor: Colors.red,
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

  Future<void> _pickFile() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles();

    if (result != null) {
      setState(() {
        _filePathSPRT = result.files.single.path;
      });
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
              return Center(
                child: Text(
                  'Data formulir kosong',
                  style: TextStyle(fontFamily: 'Poppins', fontSize: 14),
                ),
              );
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
                        labelText: 'Nama Lengkap',
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
                              'Laki-Laki',
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
                        labelText: 'Asal Sekolah',
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
                    SizedBox(height: 5),
                    Row(
                      children: <Widget>[
                        Expanded(
                          child: RadioListTile<String>(
                            contentPadding: EdgeInsets.zero,
                            title: Text(
                              'Laki-Laki',
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
                      controller: pekerjaanortuController,
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
                    SizedBox(height: 40),
                    Text(
                      "Surat Pengantar RT: ",
                      style: TextStyle(
                          fontSize: 15,
                          fontFamily: 'Poppins',
                          fontWeight: FontWeight.w600,
                          color: Colors.black),
                      textAlign: TextAlign.start,
                    ),
                    SizedBox(height: 15),
                    GestureDetector(
                      onTap: _pickFile,
                      child: Container(
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.grey),
                          borderRadius: BorderRadius.circular(15),
                        ),
                        child: Column(
                          children: [
                            ListTile(
                              leading: Icon(Icons.upload_file),
                              title: Text(
                                _filePathSPRT == null
                                    ? 'Bukti verifikasi'
                                    : 'File terpilih: ${_filePathSPRT!.split('/').last}',
                                style: TextStyle(fontSize: 14.0),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    SizedBox(height: 20),
                    ElevatedButton(
                      onPressed: () async {
                        if (_formKey.currentState!.validate()) {
                          final uploadedFilePath = await _uploadPhotoSPRT();
                          if (uploadedFilePath != null) {
                            String nama = namaController.text;
                            String tempatLahir = tempatLahirController.text;
                            String tanggalLahir = tanggalLahirController.text;
                            String sekolah = sekolahController.text;
                            String alamat = alamatController.text;
                            String namaOrangTua = namaOrangTuaController.text;
                            String alamatOrtu = alamatortuController.text;
                            String pekerjaanortu = pekerjaanortuController.text;

                            String jenisKelamin = _jenisKelamin;
                            String jenisKelaminOrtu = _jenisKelaminOrangTua;

                            String fullPath = "${ApiConfig.baseUrl}/storage/" +
                                uploadedFilePath;

                            Map<String, dynamic> data = {
                              'id_layanan': 1,
                              'tgl_pengajuan': DateFormat('yyyy-MM-dd')
                                  .format(DateTime.now()),
                              'status': 'Diproses',
                              'catatan': 'Menunggu verifikasi dokumen',
                              'id_rt': null,
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
                                  'value': namaOrangTua,
                                },
                                {
                                  'nama_field': 'Jenis Kelamin Orang Tua',
                                  'value': jenisKelaminOrtu,
                                },
                                {
                                  'nama_field': 'Pekerjaan Orang Tua',
                                  'value': pekerjaanortu
                                },
                                {
                                  'nama_field': 'Alamat Orang Tua',
                                  'value': alamatOrtu
                                },
                                {'nama_field': 'Foto KK', 'value': _fotoKKUrl},
                                {
                                  'nama_field': 'Foto KTP',
                                  'value': _fotoKTPUrl
                                },
                                {
                                  'nama_field': 'Bukti verifikasi RT',
                                  'value': fullPath
                                },
                              ],
                            };

                            _kirimDataPengajuan(data);
                          } else {
                            print('Gagal mendapatkan path file SPRT');
                          }
                        }
                      },
                      child: Text(
                        "KIRIM",
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontFamily: 'Poppins',
                        ),
                      ),
                      style: ElevatedButton.styleFrom(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
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
