import 'package:json_annotation/json_annotation.dart';

part 'formulir.g.dart';

@JsonSerializable()
class Formulir {
  int? id;
  int? id_layanan;
  Map<String, dynamic>? data_formulir;

  Formulir({
    required this.id,
    required this.id_layanan,
    required this.data_formulir,
  });

  factory Formulir.fromJson(Map<String, dynamic> json) =>
      _$FormulirFromJson(json);
  Map<String, dynamic> toJson() => _$FormulirToJson(this);
}
