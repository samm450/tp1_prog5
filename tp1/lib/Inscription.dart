// dart
import 'dart:async';
import 'package:dio/dio.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'generated/l10n.dart';
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

  bool isLoading = false;

  Future<bool> getUtilisateur() async {
    try {
      await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: nomControlleur.text.trim(),
        password: passwordControlleur.text,
      );
      return true;
    } on FirebaseAuthException catch (e) {
      String message;
      switch (e.code) {
        case 'email-already-in-use':
          message = S.of(context).UsernameTaken;
          break;
        case 'invalid-email':
          message = S.of(context).InvalidCredentials;
          break;
        case 'weak-password':
          message = S.of(context).PasswordTooShort;
          break;
        case 'operation-not-allowed':
          message = S.of(context).InvalidCredentials;
          break;
        default:
          message = e.message ?? S.of(context).InvalidCredentials;
      }
      _showSnackBar(context, message);
      return false;
    } catch (e) {
      _showSnackBar(context, e.toString());
      return false;
    } finally {
      if (mounted) {
        setState(() {
          isLoading = false;
        });
      }
    }
  }

  void _showSnackBar(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message), duration: Duration(seconds: 3)),
    );
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
