import 'dart:io';

import 'package:cookie_jar/cookie_jar.dart';
import 'package:dio/dio.dart';
import 'package:dio_cookie_manager/dio_cookie_manager.dart';
import 'models/SessionManager.dart';
import 'models/utilisateur.dart';
import 'models/tache.dart';
import 'package:http/http.dart' as http;
import 'package:firebase_messaging/firebase_messaging.dart';

class SingletonDio {
  static var cookieManager = CookieManager(CookieJar());

  static Dio getDio() {
    Dio dio = Dio();
    dio.interceptors.add(cookieManager);
    dio.options.connectTimeout = Duration(seconds: 5);
    dio.options.receiveTimeout = Duration(seconds: 5);
    dio.options.sendTimeout = Duration(seconds: 5);

    return dio;
  }
}
class UserService {
  static const String baseUrl = 'http://10.0.2.2:8080';

  static Future<ReponseConnexion> inscription(String nom, String motDePasse, String confirmationMotDePasse) async {
    final response = await SingletonDio.getDio().post('$baseUrl/id/inscription', data: {'nom': nom, 'motDePasse': motDePasse, 'confirmationMotDePasse': confirmationMotDePasse});

    SessionManager.nomUtilisateur = nom;
    return ReponseConnexion.fromJson(response.data);
  }

  static Future<ReponseConnexion> connexion(String nom, String motDePasse) async {
    final response = await SingletonDio.getDio().post('$baseUrl/id/connexion', data: {'nom': nom, 'motDePasse': motDePasse});

    SessionManager.nomUtilisateur = nom;
    return ReponseConnexion.fromJson(response.data);
  }

  static Future<void> deconnexion() async {
    await SingletonDio.getDio().post('$baseUrl/id/deconnexion');
    SessionManager.nomUtilisateur = null;
  }
}


class TacheService {
  static const String baseUrl = 'http://10.0.2.2:8080';

  static Future<List<Tache>> getTaches() async {
    final response = await SingletonDio.getDio().get('$baseUrl/api/accueil/photo');
    List tachesjson = response.data;

    List<Tache> taches = tachesjson
        .map((json) => Tache.fromJson(json))
        .toList();

    return taches;
  }

  static Future<void> UpdateProgress(int tacheId, int valeur) async {
    await SingletonDio.getDio().get('$baseUrl/tache/progres/$tacheId/$valeur');
  }

  static Future<Tache> TacheDetail(int id) async {
    final response = await SingletonDio.getDio().get(
        '$baseUrl/api/detail/photo/$id');
    return Tache.fromJson(response.data);
  }

  static Future<void> AjoutTache(String nom, DateTime dateEcheance) async {
    final nomUtilisateur = SessionManager.nomUtilisateur;
    await SingletonDio.getDio().post('$baseUrl/tache/ajout',
        data: {
          'nom': nom,
          'dateEcheance': dateEcheance.toIso8601String(),
          'nomUtilisateur': nomUtilisateur
        });

    //return Tache.fromJson(response.data);
  }
}
  class PhotoService {
  static const String baseUrl = 'http://10.0.2.2:8080';

  static Future<void> AjouterImageBD(File imagePath, int tacheId) async {
    String Nom = 'image';
    int compteur = 0;
    String NomImage = Nom + compteur.toString();
    FormData formData = FormData.fromMap({
      "taskID": tacheId.toString(),
      "file": await MultipartFile.fromFile(imagePath.path, filename: "$NomImage.jpg")
    });

    await SingletonDio.getDio().post('$baseUrl/fichier', data: formData);
    compteur++;
  }
}



