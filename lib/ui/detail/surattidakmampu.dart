import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:e_badean/ip.dart';
import 'package:e_badean/database/db_helper.dart';
import 'package:e_badean/models/user.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SuratKeteranganTidakMampu extends StatefulWidget {
  @override
  _SuratKeteranganTidakMampuState createState() =>
      _SuratKeteranganTidakMampuState();
}

class _SuratKeteranganTidakMampuState extends State<SuratKeteranganTidakMampu> {
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
          _keterangan = ''; // Atur keterangan ke nilai default jika diperlukan
          namaLengkapController.text = _name ?? '';
          emailController.text =
              _email ?? ''; // Ambil nilai email dan set pada emailController
        });
      }
    } else {
      print("Token not found in SharedPreferences");
    }
  }

  Future<void> kirimFormulirKeServer(
      String name, String email, String keterangan) async {
    final apiUrl = Uri.parse(
        'http://alamat_server/kirim-formulir'); // Ganti dengan alamat server yang sesuai
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
      appBar: AppBar(title: Text('Surat Keterangan Tidak Mampu')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: <Widget>[
              TextFormField(
                controller: namaLengkapController,
                decoration: InputDecoration(labelText: 'Nama'),
                validator: (value) =>
                    value!.isEmpty ? 'Nama tidak boleh kosong' : null,
                onSaved: (value) => _name = value,
              ),
              TextFormField(
                controller: emailController,
                decoration: InputDecoration(labelText: 'Email'),
                validator: (value) =>
                    value!.isEmpty ? 'Email tidak boleh kosong' : null,
                onSaved: (value) => _email = value,
              ),
              TextFormField(
                decoration:
                    InputDecoration(labelText: 'Keterangan Tidak Mampu'),
                validator: (value) =>
                    value!.isEmpty ? 'Keterangan tidak boleh kosong' : null,
                onSaved: (value) => _keterangan = value,
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  // Isi nilai name, email, dan keterangan sesuai dengan data formulir yang ingin dikirim
                  String name = namaLengkapController.text;
                  String email = emailController.text;
                  String keterangan = _keterangan ??
                      ''; // Isi dengan nilai _keterangan atau string kosong jika null

                  // Panggil fungsi kirimFormulirKeServer dengan data yang sesuai
                  kirimFormulirKeServer(name, email, keterangan);
                },
                child: Text('Kirim'),
              ),
              ElevatedButton(
                onPressed: () async {
                  await _loadUserData(); // Tambahkan pemanggilan _loadUserData() di sini
                  // Setelah data pengguna dimuat, nilai _email akan terisi
                  // Tetapkan nilai _email pada emailController
                  // Tetapkan nilai email pada emailController
                },
                child: Text('Tambahkan Data Diri'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
