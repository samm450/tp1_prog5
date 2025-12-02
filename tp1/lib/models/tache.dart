

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:json_annotation/json_annotation.dart';


@JsonSerializable()
class Tache {
  Tache();

  String id = "";
  DateTime dateLimite = DateTime.now();
  String nom = "";
  int pourcentageTemps = 0;
  int pourcentageAvancement = 0;
  String PhotoURL = "";

  Timestamp creationtime = Timestamp.now();

  int pourcentageTempsRestant({DateTime? now}) {
    final DateTime start = creationtime.toDate();
    final DateTime deadline = dateLimite;
    final DateTime current = now ?? DateTime.now();

    final double totalHours = deadline.difference(start).inSeconds / 3600.0;
    final double remainingHours = deadline.difference(current).inSeconds / 3600.0;

    if (totalHours <= 0) return 0;
    double pct = (remainingHours / totalHours) * 100.0;
    if (pct.isNaN) pct = 0.0;
    if (pct < 0.0) pct = 0.0;
    if (pct > 100.0) pct = 100.0;

    pourcentageTemps = pct.round();
    return pct.round();
  }

  Map<String, dynamic> toFirestore() {
    return {
      "dateLimite" : Timestamp.fromDate(dateLimite),
      "nom" : nom,
      "photoId" : PhotoURL,
      "pourcentageTemps" : pourcentageTemps,
      "pourcentageAvancement" : pourcentageAvancement
    };
  }

  // La méthode pour récupérer un Pipo depuis le JSON de firestore
  factory Tache.fromFirestore(
      DocumentSnapshot<Map<String, dynamic>> snapshot,
      SnapshotOptions? options,
      ) {
    final data = snapshot.data();
    Tache resultat = Tache();
    resultat.id = snapshot.id;
    resultat.nom = data?["nom"];
    resultat.dateLimite = data?["dateLimite"].toDate();
    resultat.pourcentageAvancement = data?["pourcentageAvancement"];
    resultat.pourcentageTemps = data?["pourcentageTemps"];             // Timestamp dans le firestore, convertir
    resultat.PhotoURL = data?["photoId"];
    return resultat;
  }
}
