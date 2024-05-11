// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'emailRegister.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

User _$UserFromJson(Map<String, dynamic> json) {
  return User(
    email: json['email'] as String,
    nama_akun: json['nama_akun'] as String,
  );
}

Map<String, dynamic> _$UserToJson(User instance) => <String, dynamic>{
      'email': instance.email,
      'nama_akun': instance.nama_akun,
    };
