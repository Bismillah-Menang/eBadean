import 'dart:convert';

import 'package:json_annotation/json_annotation.dart';
import 'dart:typed_data';

part 'berita.g.dart';

@JsonSerializable()
class Berita {
  int? id;
  late String judul_berita;
  late Uint8List foto_berita;
  late String isi_berita;
  late String sumber;
  late String tgl_berita;

  Berita({
    required this.judul_berita,
    required this.foto_berita,
    required this.isi_berita,
    required this.sumber,
    required this.tgl_berita,
  });

  factory Berita.fromJson(Map<String, dynamic> json) => _$BeritaFromJson(json);
  Map<String, dynamic> toJson() => _$BeritaToJson(this);
}

@JsonSerializable()
class BeritaList {
  late List<Berita>? data;

  BeritaList({
    required this.data,
  });

  factory BeritaList.fromJson(Map<String, dynamic> json) =>
      _$BeritaListFromJson(json);
  Map<String, dynamic> toJson() => _$BeritaListToJson(this);

  List<Berita> filterByJudul(String query) {
    return data
            ?.where((berita) => berita.judul_berita
                .toLowerCase()
                .startsWith(query.toLowerCase()))
            ?.toList() ??
        [];
  }
}
