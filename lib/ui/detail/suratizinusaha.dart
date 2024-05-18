import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:e_badean/ip.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:e_badean/database/db_helper.dart';
import 'package:e_badean/models/user.dart';

class SuratIzinUsaha extends StatefulWidget {
  @override
  _SuratIzinUsahaState createState() => _SuratIzinUsahaState();
}

class _SuratIzinUsahaState extends State<SuratIzinUsaha> {
  final _formKey = GlobalKey<FormState>();
  String? _name, _email, _keterangan;
  final TextEditingController namaLengkapController = TextEditingController();
  final TextEditingController emailController = TextEditingController();

  Future<void> _loadUserData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('token');

    if (token != null) {
      User? user = await DBHelper.getUserFromLocal(token);

      if (user != null) {
        setState(() {
          _name = user.nama_lengkap;
          _email = user.email;
          _keterangan = '';
          namaLengkapController.text = _name ?? '';
          emailController.text = _email ?? '';
        });
      }
    } else {
      print("Token not found in SharedPreferences");
    }
  }

  void _submitForm() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      final response = await http.post(
        Uri.parse('${ApiConfig.baseUrl}/api/formulir'),
        body: json.encode({
          'name': _name,
          'email': _email,
          'keterangan': _keterangan,
        }),
        headers: {'Content-Type': 'application/json'},
      );

      if (response.statusCode == 200) {
        ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Form submitted successfully')));
      } else {
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text('Failed to submit form')));
      }
    }
  }

  Future<void> kirimFormulirKeServer(
      String name, String email, String keterangan) async {
    final apiUrl = Uri.parse('${ApiConfig.baseUrl}/api/formulir');
    final headers = {'Content-Type': 'application/json'};

    final body = jsonEncode({
      'nama_lengkap': name,
      'email': email,
      'keterangan': keterangan,
    });

    try {
      final response = await http.post(apiUrl, headers: headers, body: body);

      if (response.statusCode == 201) {
        print('Formulir berhasil dikirim ke server');
      } else {
        print('Gagal mengirim formulir ke server');
      }
    } catch (error) {
      print('Terjadi kesalahan: $error');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Surat Izin Usaha',
          style: TextStyle(
            fontFamily: 'Poppins',
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: <Widget>[
              SizedBox(height: 20),
              TextFormField(
                controller: namaLengkapController,
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
                onSaved: (value) => _name = value,
              ),
              SizedBox(height: 20),
              TextFormField(
                controller: emailController,
                keyboardType: TextInputType.emailAddress,
                decoration: InputDecoration(
                  labelText: 'Email',
                  labelStyle: TextStyle(fontSize: 14.0),
                  prefixIcon: Icon(Icons.mail),
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
                    value!.isEmpty ? 'Email tidak boleh kosong' : null,
                onSaved: (value) => _email = value,
              ),
              SizedBox(height: 20),
              TextFormField(
                keyboardType: TextInputType.emailAddress,
                decoration: InputDecoration(
                  labelText: 'Keterangan',
                  labelStyle: TextStyle(fontSize: 14.0),
                  prefixIcon: Icon(Icons.message),
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
                    value!.isEmpty ? 'Keterangan tidak boleh kosong' : null,
                onSaved: (value) => _keterangan = value,
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: () async {
                  await _loadUserData();
                },
                child: Text(
                  "TAMBAHKAN DATA DIRI",
                  style: TextStyle(
                      fontSize: 16,
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                      fontFamily: 'Poppins'),
                ),
                style: ElevatedButton.styleFrom(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                  padding: EdgeInsets.symmetric(vertical: 10),
                  backgroundColor: Color(0xFFFFF212),
                  minimumSize: Size(double.infinity, 0),
                ),
              ),
              SizedBox(height: 5),
              ElevatedButton(
                onPressed: () {
                  String name = namaLengkapController.text;
                  String email = emailController.text;
                  String keterangan = _keterangan ?? '';
                  kirimFormulirKeServer(name, email, keterangan);
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
        ),
      ),
    );
  }
}
