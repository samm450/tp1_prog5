

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:json_annotation/json_annotation.dart';

part 'tache.g.dart';

@JsonSerializable()
class Tache {
  Tache();

  String id = "";
  DateTime dateLimite = DateTime.now();
  String nom = "";
  int pourcentageTemps = 0;
  int pourcentageAvancement = 0;
  String idPhoto = "";

  factory Tache.fromJson(Map<String, dynamic> json) => _$TacheFromJson(json);

  Map<String, dynamic> toJson() => _$TacheToJson(this);

  Map<String, dynamic> toFirestore() {
    return {
    };
  }

  // La méthode pour récupérer un Pipo depuis le JSON de firestore
  factory Tache.fromFirestore(
      DocumentSnapshot<Map<String, dynamic>> snapshot,
      SnapshotOptions? options,) {
    final data = snapshot.data();
    Tache resultat = Tache();
    resultat.id = snapshot.id;                          // l'id n'est pas dans les données
    resultat.dateLimite = data?["popi"];
    resultat.dateLimite = data?[""]// les autres champs sont dans data
    resultat.pourcentageAvancement = data?["pipi"];                      // les autres champs sont dans data
    resultat.pourcentageTemps = data?["popo"].toDate();             // Timestamp dans le firestore, convertir
    resultat.idPhoto = data?["creationtime"];
    return resultat;
  }
}
