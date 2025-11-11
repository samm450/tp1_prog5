// dart
import 'dart:async';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'generated/l10n.dart';
import 'models/utilisateur.dart';
import 'service.dart';
import 'accueil.dart';

class Inscription extends StatefulWidget {
  Inscription({super.key, required this.title});
  final String title;

  @override
  State<Inscription> createState() => _InscriptionState();
}

class _InscriptionState extends State<Inscription> {
  final TextEditingController nomControlleur = TextEditingController();
  final TextEditingController passwordControlleur = TextEditingController();
  final TextEditingController confirmpasswordControlleur = TextEditingController();
  ReponseConnexion response = ReponseConnexion();

  bool isLoading = false;
  Timer? _timeoutTimer;
  bool _timedOut = false;

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
      response = await UserService.inscription(
        nomControlleur.text,
        passwordControlleur.text,
        confirmpasswordControlleur.text,
      );

      if (_timedOut) {
        _timeoutTimer?.cancel();
        return false;
      }

      _timeoutTimer?.cancel();
      setState(() {}); // mettre à jour si besoin
      return true;
    } on DioException catch (e) {
      _timeoutTimer?.cancel();
      if (_timedOut) return false;

      final String erreur = e.response?.data ?? '';

      if (erreur == "NomTropCourt") {
        _showSnackBar(context, S.of(context).NameTooShort);
      } else if (erreur == "MotDePasseTropCourt") {
        _showSnackBar(context, S.of(context).PasswordTooShort);
      } else if (erreur == "MotsDePasseDifferents") {
        _showSnackBar(context, S.of(context).PasswordMismatch);
      } else if (erreur == "NomDejaUtilise") {
        _showSnackBar(context, S.of(context).UsernameTaken);
      } else {
        _showSnackBar(context, S.of(context).InvalidCredentials);
      }
      return false;
    } finally {
      //_timeoutTimer?.cancel();
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
    // si !ok on reste sur la page ; le SnackBar a déjà été affiché
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
                  SizedBox(
                    width: 300,
                    child: TextField(
                      controller: confirmpasswordControlleur,
                      decoration: InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: S.of(context).passwordConfirmation,
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
