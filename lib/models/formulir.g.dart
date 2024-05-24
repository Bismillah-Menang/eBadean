// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'formulir.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Formulir _$FormulirFromJson(Map<String, dynamic> json) {
  return Formulir(
    id: json['id'] as int?,
    id_layanan: json['id_layanan'] as int?,
    data_formulir: json['data_formulir'] as Map<String, dynamic>?, 
  );
}

Map<String, dynamic> _$FormulirToJson(Formulir instance) => <String, dynamic>{
      'id': instance.id,
      'id_layanan': instance.id_layanan,
      'data_formulir': instance.data_formulir,
    };