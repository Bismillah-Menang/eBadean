import 'dart:typed_data';
import 'package:flutter/material.dart';

class DetailBerita extends StatelessWidget {
  final String judul;
  final String tgl;
  final String isi;
  final Uint8List
      foto; 

  DetailBerita(
      {required this.judul,
      required this.tgl,
      required this.isi,
      required this.foto});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.only(
            top: 10.0,
            bottom: 75.0,
            left: 25.0,
            right: 25.0,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 4.0),
              Text(
                judul,
                style: TextStyle(
                  fontSize: 20.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                tgl,
                style: TextStyle(
                  fontSize: 15.0,
                ),
              ),
              SizedBox(height: 15.0),
              Padding(
                padding: EdgeInsets.symmetric(vertical: 10.0),
                child: Image.memory(
                    foto), // Menampilkan gambar dari foto_berita yang telah di-decode menjadi Uint8List
              ),
              SizedBox(height: 15.0),
              Padding(
                padding: EdgeInsets.symmetric(vertical: 10.0),
                child: Text(
                  isi,
                  style: TextStyle(fontSize: 16.0),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
