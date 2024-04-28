import 'package:json_annotation/json_annotation.dart';

part 'layanan.g.dart';

@JsonSerializable()
class Layanan {
  late int id;
  late String kode_surat;
  late String nama_surat;
  late String jenis_surat;

  Layanan({
    required this.id,
    required this.kode_surat,
    required this.nama_surat,
    required this.jenis_surat,
  });

  factory Layanan.fromJson(Map<String, dynamic> json) => _$LayananFromJson(json);
  Map<String, dynamic> toJson() => _$LayananToJson(this);
}

@JsonSerializable()
class LayananList {
  late List<Layanan> data;

  LayananList({
    required this.data,
  });

  factory LayananList.fromJson(Map<String, dynamic> json) => _$LayananListFromJson(json);
  Map<String, dynamic> toJson() => _$LayananListToJson(this);
}
