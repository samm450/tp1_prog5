import 'dart:convert';
import 'package:cookie_jar/cookie_jar.dart';
import 'package:dio/dio.dart';
import 'package:dio_cookie_manager/dio_cookie_manager.dart';
import 'package:tp1/models/SessionManager.dart';
import 'package:http/http.dart' as http;
import 'package:tp1/models/utilisateur.dart';

import 'models/tache.dart';


class SingletonDio {
  static var cookieManager = CookieManager(CookieJar());

  static Dio getDio() {
    Dio dio = Dio();
    dio.interceptors.add(cookieManager);

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
}


class TacheService {
  static const String baseUrl = 'http://10.0.2.2:8080';

  static Future<List<Tache>> getTaches2() async {
    final response = await SingletonDio.getDio().get('$baseUrl/tache/acceuil');

    List tachesjson = response.data;

    List<Tache> taches = tachesjson
        .map((json) => Tache.fromJson(json))
        .toList();

    return taches;
  }

  // Récupérer les tâches
  static Future<List<Map<String, dynamic>>> getTaches() async {
    final response = await http.get(Uri.parse('$baseUrl/tache/acceuil'));

    if (response.statusCode == 200) {
      List<dynamic> data = json.decode(response.body);
      return data.cast<Map<String, dynamic>>();
    } else {
      throw Exception('Erreur lors du chargement des tâches');
    }
  }

  // Créer une tâche
  static Future<bool> creerTache(String titre, String description) async {
    final response = await http.post(
      Uri.parse('$baseUrl/taches'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode({
        'titre': titre,
        'description': description,
      }),
    );

    return response.statusCode == 201;
  }
}