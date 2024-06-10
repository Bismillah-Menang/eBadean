import 'package:json_annotation/json_annotation.dart';

part 'riwayat.g.dart';

@JsonSerializable()
class Riwayat {
  final int id;
  final String namaLayanan;
  final String tanggal;
  final String status;
  final String? fileSuratPath;

  Riwayat({
    required this.id,
    required this.namaLayanan,
    required this.tanggal,
    required this.status,
    this.fileSuratPath,
  });

  factory Riwayat.fromJson(Map<String, dynamic> json) => _$RiwayatFromJson(json);

  Map<String, dynamic> toJson() => _$RiwayatToJson(this);
}


