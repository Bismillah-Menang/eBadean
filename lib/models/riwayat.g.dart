// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'riwayat.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Riwayat _$RiwayatFromJson(Map<String, dynamic> json) => Riwayat(
      id: json['id'] as int,
      namaLayanan: json['nama_layanan'] as String,
      tanggal: json['tgl_pengajuan'] as String,
      status: json['status'] as String,
      fileSuratPath: json['file_surat'] as String?,
    );

Map<String, dynamic> _$RiwayatToJson(Riwayat instance) => <String, dynamic>{
      'id': instance.id,
      'nama_layanan': instance.namaLayanan,
      'tgl_pengajuan': instance.tanggal,
      'status': instance.status,
      'file_surat': instance.fileSuratPath,
    };
