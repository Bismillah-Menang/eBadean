import 'package:json_annotation/json_annotation.dart';

part 'layanan.g.dart';

@JsonSerializable()
class Layanan {
  int? id;
  late String nama_layanan;
  late String jenis_layanan;
  late String info_layanan;

  Layanan({
    required this.nama_layanan,
    required this.jenis_layanan,
    required this.info_layanan,
  });

  factory Layanan.fromJson(Map<String, dynamic> json) =>
      _$LayananFromJson(json);
  Map<String, dynamic> toJson() => _$LayananToJson(this);
}

@JsonSerializable()
class LayananList {
  late List<Layanan>? data;

  LayananList({
    required this.data,
  });

  factory LayananList.fromJson(Map<String, dynamic> json) =>
      _$LayananListFromJson(json);
  Map<String, dynamic> toJson() => _$LayananListToJson(this);
}
