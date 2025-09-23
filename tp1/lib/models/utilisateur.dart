

import 'package:json_annotation/json_annotation.dart';
import 'package:tp1/models/tache.dart';

part 'utilisateur.g.dart';

@JsonSerializable()
class Utilisateur {
  Utilisateur();

  int id = 0;
  String nom = "";
  String motDePasse = "";
  List<Tache> taches = [];

  factory Utilisateur.fromJson(Map<String, dynamic> json) => _$UtilisateurFromJson(json);

  Map<String, dynamic> toJson() => _$UtilisateurToJson(this);
}

@JsonSerializable()
class ReponseConnexion {
  ReponseConnexion();

  String nomUtilisateur = "";

  factory ReponseConnexion.fromJson(Map<String, dynamic> json) => _$ReponseConnexionFromJson(json);

  Map<String, dynamic> toJson() => _$ReponseConnexionToJson(this);
}