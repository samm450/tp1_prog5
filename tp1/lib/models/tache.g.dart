// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'tache.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Tache _$TacheFromJson(Map<String, dynamic> json) => Tache()
  ..id = (json['id'] as num).toInt()
  ..dateLimite = DateTime.parse(json['dateLimite'] as String)
  ..nom = json['nom'] as String
  ..pourcentageTemps = (json['pourcentageTemps'] as num).toInt()
  ..pourcentageAvancement = (json['pourcentageAvancement'] as num).toInt()
  ..idPhoto = ((json['idPhoto']??json['photoId']??0) as num).toInt();

Map<String, dynamic> _$TacheToJson(Tache instance) => <String, dynamic>{
  'id': instance.id,
  'dateLimite': instance.dateLimite.toIso8601String(),
  'nom': instance.nom,
  'pourcentageTemps': instance.pourcentageTemps,
  'pourcentageAvancement': instance.pourcentageAvancement,
  'idPhoto': instance.idPhoto,
};
