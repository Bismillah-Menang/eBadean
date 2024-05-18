
import 'package:json_annotation/json_annotation.dart';

part 'user.g.dart';

@JsonSerializable()
class User {
  late int id;
  late String nama_lengkap;
  late String username;
  late String email;
  late String? no_hp;
  late String? alamat;
  late String? jenis_kelamin;
  late String? tanggal_lahir;
  late String? kebangsaan;
  late String? pekerjaan;
  late String? status_nikah;
  late String? nik;

  User({
    required this.id,
    required this.nama_lengkap,
    required this.username,
    required this.email,
    required this.no_hp,
    required this.alamat,
    required this.jenis_kelamin,
    required this.tanggal_lahir,
    required this.kebangsaan,
    required this.pekerjaan,
    required this.status_nikah,
    required this.nik,
  });

  factory User.fromJson(Map<String, dynamic> json) => _$UserFromJson(json);
  Map<String, dynamic> toJson() => _$UserToJson(this);

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'nama_lengkap': nama_lengkap,
      'username': username,
      'email': email,
      'no_hp': no_hp,
      'alamat': alamat,
      'jenis_kelamin': jenis_kelamin,
      'tanggal_lahir': tanggal_lahir,
      'kebangsaan': kebangsaan,
      'pekerjaan': pekerjaan,
      'status_nikah': status_nikah,
      'nik': nik,
    };
  }
}
