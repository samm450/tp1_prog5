// dart
import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dio/dio.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:tp1/Inscription.dart';
import 'generated/l10n.dart';
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

  Future<UserCredential> signInWithGoogle() async {
    // Trigger the authentication flow
    final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();

    // Obtain the auth details from the request
    final GoogleSignInAuthentication? googleAuth = await googleUser?.authentication;

    // Create a new credential
    final credential = GoogleAuthProvider.credential(
      accessToken: googleAuth?.accessToken,
      idToken: googleAuth?.idToken,
    );

    // Once signed in, return the UserCredential
    return await FirebaseAuth.instance.signInWithCredential(credential);
  }

  void _showSnackBar(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message), duration: Duration(seconds: 3)),
    );
  }

  Future<bool> getUtilisateur() async {
    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: nomControlleur.text.trim(),
        password: passwordControlleur.text,
      );
      return true;
    } on FirebaseAuthException catch (e) {
      String message;
      switch (e.code) {
        case 'user-not-found':
        case 'wrong-password':
          message = S.of(context).InvalidCredentials;
          break;
        case 'invalid-email':
          message = S.of(context).InvalidCredentials;
          break;
        case 'user-disabled':
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

  onPressedConnexion() async {
    setState(() {
      isLoading = true;
    });

    bool ok = await getUtilisateur();
    if (!mounted) return;
    if (ok) {
      Navigator.push(context, MaterialPageRoute(builder: (context) => Accueil()));
    }
  }

  onPressedInscription() async {
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
                    onPressed: isLoading ? null : onPressedConnexion,
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
                    onPressed: isLoading ? null : onPressedInscription,
                    child: Text(S.of(context).inscription),
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
                    onPressed: isLoading ? null : signInWithGoogle,
                    child: Text("sign in with google"),
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
