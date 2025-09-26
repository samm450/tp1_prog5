
import 'package:cookie_jar/cookie_jar.dart';
import 'package:dio/dio.dart';
import 'package:dio_cookie_manager/dio_cookie_manager.dart';
import 'package:tp1/models/SessionManager.dart';

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
    final nomUtilisateur = SessionManager.nomUtilisateur;
    final response = await SingletonDio.getDio().get('$baseUrl/tache/accueil');
    //queryParameters: {'nomUtilisateur': nomUtilisateur});

    List tachesjson = response.data;

    List<Tache> taches = tachesjson
        .map((json) => Tache.fromJson(json))
        .toList();

    return taches;
  }

  static Future<Tache> TacheDetail(int id) async{
    final response = await SingletonDio.getDio().get('$baseUrl/tache/detail/$id');
    return Tache.fromJson(response.data);
  }

  static Future<void> AjoutTache(String nom, DateTime dateEcheance) async {
    final nomUtilisateur = SessionManager.nomUtilisateur;
    final response = await SingletonDio.getDio().post('$baseUrl/tache/ajout',
        data: {'nom': nom, 'dateEcheance': dateEcheance.toIso8601String(), 'nomUtilisateur': nomUtilisateur});

    //return Tache.fromJson(response.data);
  }



}