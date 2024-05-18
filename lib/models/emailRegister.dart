import 'package:json_annotation/json_annotation.dart';

part 'emailRegister.g.dart';

class User {
  final String email;
  final String nama_akun;

  User({
    required this.email,
    required this.nama_akun,
  });
}