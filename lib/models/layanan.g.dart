// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'layanan.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Layanan _$LayananFromJson(Map<String, dynamic> json) => Layanan(
      id: json['id'] as int,
      kode_surat: json['kode_surat'] as String,
      nama_surat: json['nama_surat'] as String,
      jenis_surat: json['jenis_surat'] as String,
    );

Map<String, dynamic> _$LayananToJson(Layanan instance) => <String, dynamic>{
      'id': instance.id,
      'kode_surat': instance.kode_surat,
      'nama_surat': instance.nama_surat,
      'jenis_surat': instance.jenis_surat,
    };

LayananList _$LayananListFromJson(Map<String, dynamic> json) => LayananList(
      data: (json['data'] as List<dynamic>)
          .map((e) => Layanan.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$LayananListToJson(LayananList instance) =>
    <String, dynamic>{
      'data': instance.data,
    };
