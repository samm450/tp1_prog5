// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'utilisateur.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Utilisateur _$UtilisateurFromJson(Map<String, dynamic> json) => Utilisateur()
  ..id = (json['id'] as num).toInt()
  ..nom = json['nom'] as String
  ..motDePasse = json['motDePasse'] as String
  ..taches = (json['taches'] as List<dynamic>)
      .map((e) => Tache.fromJson(e as Map<String, dynamic>))
      .toList();

Map<String, dynamic> _$UtilisateurToJson(Utilisateur instance) =>
    <String, dynamic>{
      'id': instance.id,
      'nom': instance.nom,
      'motDePasse': instance.motDePasse,
      'taches': instance.taches,
    };

ReponseConnexion _$ReponseConnexionFromJson(Map<String, dynamic> json) =>
    ReponseConnexion()..nomUtilisateur = json['nomUtilisateur'] as String;

Map<String, dynamic> _$ReponseConnexionToJson(ReponseConnexion instance) =>
    <String, dynamic>{'nomUtilisateur': instance.nomUtilisateur};
