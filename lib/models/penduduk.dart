import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class Penduduk {
  final String namaLengkap;
  final String noHp;
  final String alamat;
  final String jenisKelamin;
  final String tanggalLahir;
  final String kebangsaan;
  final String pekerjaan;
  final String statusNikah;
  final String nik;

  Penduduk({
    required this.namaLengkap,
    required this.noHp,
    required this.alamat,
    required this.jenisKelamin,
    required this.tanggalLahir,
    required this.kebangsaan,
    required this.pekerjaan,
    required this.statusNikah,
    required this.nik,
  });

  factory Penduduk.fromJson(Map<String, dynamic> json) {
    return Penduduk(
      namaLengkap: json['nama_lengkap'],
      noHp: json['no_hp'],
      alamat: json['alamat'],
      jenisKelamin: json['jenis_kelamin'],
      tanggalLahir: json['tanggal_lahir'],
      kebangsaan: json['kebangsaan'],
      pekerjaan: json['pekerjaan'],
      statusNikah: json['status_nikah'],
      nik: json['nik'],
    );
  }
}