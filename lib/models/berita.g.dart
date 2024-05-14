// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'berita.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Berita _$BeritaFromJson(Map<String, dynamic> json) => Berita(
      judul_berita: json['judul_berita'] as String,
      foto_berita: base64Decode(
          json['foto_berita'] as String), // Decode base64 menjadi Uint8List
      isi_berita: json['isi_berita'] as String,
      tgl_berita: json['tgl_berita'] as String,
    )..id = json['id'] as int?;

Map<String, dynamic> _$BeritaToJson(Berita instance) => <String, dynamic>{
      'id': instance.id,
      'judul_berita': instance.judul_berita,
      'foto_berita':
          base64Encode(instance.foto_berita), // Encode Uint8List menjadi base64
      'isi_berita': instance.isi_berita,
      'tgl_berita': instance.tgl_berita,
    };

BeritaList _$BeritaListFromJson(Map<String, dynamic> json) => BeritaList(
      data: (json['data'] as List<dynamic>?)
          ?.map((e) => Berita.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$BeritaListToJson(BeritaList instance) =>
    <String, dynamic>{
      'data': instance.data,
    };