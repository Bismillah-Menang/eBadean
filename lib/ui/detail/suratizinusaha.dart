import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:e_badean/ip.dart';

class SuratIzinUsaha extends StatefulWidget {
  @override
  _SuratIzinUsahaState createState() => _SuratIzinUsahaState();
}

class _SuratIzinUsahaState extends State<SuratIzinUsaha> {
  final _formKey = GlobalKey<FormState>();
  String? _name, _email, _keterangan;

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
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Form submitted successfully')));
      } else {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Failed to submit form')));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Surat Izin Usaha')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: <Widget>[
              TextFormField(
                decoration: InputDecoration(labelText: 'Nama'),
                validator: (value) => value!.isEmpty ? 'Nama tidak boleh kosong' : null,
                onSaved: (value) => _name = value,
              ),
              TextFormField(
                decoration: InputDecoration(labelText: 'Email'),
                validator: (value) => value!.isEmpty ? 'Email tidak boleh kosong' : null,
                onSaved: (value) => _email = value,
              ),
              TextFormField(
                decoration: InputDecoration(labelText: 'Keterangan Usaha'),
                validator: (value) => value!.isEmpty ? 'Keterangan tidak boleh kosong' : null,
                onSaved: (value) => _keterangan = value,
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: _submitForm,
                child: Text('Kirim'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
