// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

User _$UserFromJson(Map<String, dynamic> json) => User(
      id: json['id'] as int,
      nama_lengkap: json['nama_lengkap'] as String,
      username: json['username'] as String,
      email: json['email'] as String,
      no_hp: json['no_hp'] as String?,
      alamat: json['alamat'] as String?,
      jenis_kelamin: json['jenis_kelamin'] as String?,
      ttl: json['ttl'] as String?,
      kebangsaan: json['kebangsaan'] as String?,
      pekerjaan: json['pekerjaan'] as String?,
      status_nikah: json['status_nikah'] as String?,
      nik: json['nik'] as String?,
    )..token = json['token'] as String?;

Map<String, dynamic> _$UserToJson(User instance) => <String, dynamic>{
      'id': instance.id,
      'nama_lengkap': instance.nama_lengkap,
      'username': instance.username,
      'email': instance.email,
      'no_hp': instance.no_hp,
      'alamat': instance.alamat,
      'jenis_kelamin': instance.jenis_kelamin,
      'ttl': instance.ttl,
      'kebangsaan': instance.kebangsaan,
      'pekerjaan': instance.pekerjaan,
      'status_nikah': instance.status_nikah,
      'nik': instance.nik,
      'token': instance.token,
    };
