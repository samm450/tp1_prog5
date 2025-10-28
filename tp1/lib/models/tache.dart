

import 'package:json_annotation/json_annotation.dart';

part 'tache.g.dart';

@JsonSerializable()
class Tache {
  Tache();

  int id = 0;
  DateTime dateLimite = DateTime.now();
  String nom = "";
  int pourcentageTemps = 0;
  int pourcentageAvancement = 0;
  int idPhoto = 0;

  factory Tache.fromJson(Map<String, dynamic> json) => _$TacheFromJson(json);

  Map<String, dynamic> toJson() => _$TacheToJson(this);
}
