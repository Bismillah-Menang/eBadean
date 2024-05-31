// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'riwayat.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Riwayat _$RiwayatFromJson(Map<String, dynamic> json) => Riwayat(
      id: json['id'] as int,
      namaLayanan: json['namaLayanan'] as String,
      tanggal: json['tanggal'] as String,
      status: json['status'] as String,
    );

Map<String, dynamic> _$RiwayatToJson(Riwayat instance) => <String, dynamic>{
      'id': instance.id,
      'namaLayanan': instance.namaLayanan,
      'tanggal': instance.tanggal,
      'status': instance.status,
    };
