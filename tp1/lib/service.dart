import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cookie_jar/cookie_jar.dart';
import 'package:dio/dio.dart';
import 'package:dio_cookie_manager/dio_cookie_manager.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_auth/firebase_auth.dart' as fb_auth;
import 'package:image_picker/image_picker.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:tp1/main.dart';
import 'models/SessionManager.dart';
import 'models/tache.dart';
import 'package:http/http.dart' as http;
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';

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
class FirebaseService {

  static CollectionReference<Tache> getTaskCollection() {
    return FirebaseFirestore.instance
        .collection("users")
        .doc(getUserId().toString())
        .collection("tasks")
        .withConverter(
          fromFirestore: Tache.fromFirestore,
          toFirestore: (Tache tache, options) => tache.toFirestore(),
        );
  }

  static String getUserId() {
    fb_auth.User? user = FirebaseAuth.instance.currentUser!;
    String userId = user.uid;

    return userId;
  }
  static Future<Tache> getTache(String id) async {
    DocumentSnapshot<Tache> tache = await getTaskCollection().doc(id).get();

    return tache.data()!;
  }

    static Future<List<Tache>> getTachesFromFirebase() async {

    QuerySnapshot<Tache> tachesCollection = await getTaskCollection().get();

    List<Tache> resultat = [];
    for (QueryDocumentSnapshot<Tache> element in tachesCollection.docs) {
      resultat.add(element.data());
    }

    return resultat;
  }

  static Future<void> ajouterTacheFirebase(String nom, DateTime dateLimite) async {
    Tache nouvelleTache = Tache()
      ..nom = nom
      ..dateLimite = dateLimite;

    await getTaskCollection().add(nouvelleTache);
  }

  static Future<void> modifierTacheFirebase(Tache tache) async{

    await getTaskCollection().doc(tache.id).set(tache);
  }




  /*static Future<void> modifierTacheFirebase(String id, int pourcentage) async{

    Tache tachemodifier = await getTache(id);

    tachemodifier.pourcentageAvancement = pourcentage;

    await getTaskCollection().doc(id).set(tachemodifier);
  }*/
}
class SupaBaseService {

  var _imageFile;
  var _publicUrl;

   Future<void> ajouterImage(XFile image, int tacheId) async {

      final supabase = Supabase.instance.client;
      final String fullPath = await supabase
          .storage
          .from('supabucket')
          .upload( image.name, File(image.path)
      );

      _publicUrl = supabase
          .storage
          .from('supabucket')
          .getPublicUrl(image.name);
   }

  // static Future<String> getImage(String fileName) async {
  //
  //   final supabase = Supabase.instance.client;
  //
  //
  //   String url = supabase
  //       .storage
  //       .from('supabucket')
  //       .getPublicUrl("nom-du-fichier");
  //
  //   return url;
  // }



}


/*class UserService {
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
}*/


/*class TacheService {
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
}*/



