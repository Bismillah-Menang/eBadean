
import 'package:json_annotation/json_annotation.dart';

part 'user.g.dart';

@JsonSerializable()
class User {
  final int id;
  final String email;
  final Map<String, dynamic> penduduk;

  User({required this.id, required this.email, required this.penduduk});

  factory User.fromJson(Map<String, dynamic> json) => _$UserFromJson(json);
  Map<String, dynamic> toJson() => _$UserToJson(this);

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'email': email,
      'penduduk': penduduk,
    };
  }
}
