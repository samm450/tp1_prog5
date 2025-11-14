// dart
import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dio/dio.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:tp1/Inscription.dart';
import 'generated/l10n.dart';
import 'models/utilisateur.dart';
import 'service.dart';
import 'accueil.dart';

class Connexion extends StatefulWidget {
  const Connexion({super.key, required this.title});
  final String title;

  @override
  State<Connexion> createState() => _ConnexionState();
}

class _ConnexionState extends State<Connexion> {
  final TextEditingController nomControlleur = TextEditingController();
  final TextEditingController passwordControlleur = TextEditingController();
  ReponseConnexion response = ReponseConnexion();

  bool isLoading = false;
  Timer? _timeoutTimer;
  bool _timedOut = false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    FirebaseAuth.instance
        .authStateChanges()
        .listen((User? user) {
      if (user == null) {
        print('User is currently signed out!');
      } else {
        print('User is signed in! ' + user.email!);
      }
    }
    );
  }

  void _showSnackBar(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message), duration: Duration(seconds: 3)),
    );
  }

  Future<bool> getUtilisateur() async {
    _timedOut = false;
    _timeoutTimer?.cancel();
    _timeoutTimer = Timer(const Duration(seconds: 5), () {
      if (!mounted) return;
      _timedOut = true;
      _showSnackBar(context, S.of(context).NoConnexion);
      setState(() {
        isLoading = false;
      });
    });

    try {
      response = await UserService.connexion(
        nomControlleur.text,
        passwordControlleur.text,
      );

      if (_timedOut) {
        _timeoutTimer?.cancel();
        return false;
      }

      _timeoutTimer?.cancel();
      setState(() {}); // mettre à jour l'UI si nécessaire
      return true;
    } on DioException catch (e) {
      _timeoutTimer?.cancel();
      if (_timedOut) return false;

      final String erreur = e.response?.data ?? '';

      if (erreur == "MauvaisNomOuMotDePasse") {
        _showSnackBar(context, S.of(context).InvalidCredentials);
      } else if (erreur == "MotDePasseTropCourt") {
        _showSnackBar(context, S.of(context).PasswordTooShort);
      } else if (erreur == "MotDePasseTropLong") {
        _showSnackBar(context, S.of(context).MotDePasseTropLong);
      } else if (erreur == "NomTropLong") {
        _showSnackBar(context, S.of(context).NomTropLong);
      } else if (erreur == "NomTropCourt") {
        _showSnackBar(context, S.of(context).NameTooShort);
      } else {
        _showSnackBar(context, S.of(context).InvalidCredentials);
      }
      return false;
    } finally {
      _timeoutTimer?.cancel();
      if (mounted && !_timedOut) {
        setState(() {
          isLoading = false;
        });
      }
    }
  }

  onPressed() async {
    setState(() {
      isLoading = true;
    });

    bool ok = await getUtilisateur();
    if (!mounted) return;
    if (ok) {
      Navigator.push(context, MaterialPageRoute(builder: (context) => Accueil()));
    }
  }

  onPressed1() async {
    setState(() {
      isLoading = true;
    });
    Navigator.push(context, MaterialPageRoute(builder: (context) => Inscription(title: "Inscription")));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      body: Column(
        children: [
          SizedBox(height: 5, child: isLoading ? LinearProgressIndicator() : null),
          Expanded(
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  SizedBox(
                    width: 300,
                    child: TextField(
                      controller: nomControlleur,
                      decoration: InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: S.of(context).username,
                      ),
                    ),
                  ),
                  SizedBox(height: 16),
                  SizedBox(
                    width: 300,
                    child: TextField(
                      controller: passwordControlleur,
                      decoration: InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: S.of(context).password,
                      ),
                      obscureText: true,
                    ),
                  ),
                  SizedBox(height: 16),
                  TextButton(
                    style: TextButton.styleFrom(
                      backgroundColor: Colors.red,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 32),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      textStyle: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    onPressed: isLoading ? null : onPressed,
                    child: Text(S.of(context).connexion),
                  ),
                  SizedBox(height: 16),
                  TextButton(
                    style: TextButton.styleFrom(
                      backgroundColor: Colors.red,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 32),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      textStyle: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    onPressed: isLoading ? null : onPressed1,
                    child: Text(S.of(context).inscription),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
