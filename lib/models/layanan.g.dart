// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'layanan.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Layanan _$LayananFromJson(Map<String, dynamic> json) => Layanan(
      nama_layanan: json['nama_layanan'] as String,
      jenis_layanan: json['jenis_layanan'] as String,
      info_layanan: json['info_layanan'] as String,
    )..id = json['id'] as int?;

Map<String, dynamic> _$LayananToJson(Layanan instance) => <String, dynamic>{
      'id': instance.id,
      'nama_layanan': instance.nama_layanan,
      'jenis_layanan': instance.jenis_layanan,
      'info_layanan': instance.info_layanan,
    };

LayananList _$LayananListFromJson(Map<String, dynamic> json) => LayananList(
      data: (json['data'] as List<dynamic>?)
          ?.map((e) => Layanan.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$LayananListToJson(LayananList instance) =>
    <String, dynamic>{
      'data': instance.data,
    };
