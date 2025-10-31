
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

  getUtilisateur() async {
    try {
      response = await UserService.inscription(
          nomControlleur.text, passwordControlleur.text,
          confirmpasswordControlleur.text);
      setState(() {});
    } on DioException catch (e) {
      String erreur = e.response!.data;
      if (erreur == "NomTropCourt")
        print( S.of(context).NameTooShort);
      else if (erreur == "MotDePasseTropCourt")
        print( S.of(context).PasswordTooShort);
      else if (erreur == "MotDePasseNonConfirme")
        print( S.of(context).PasswordMismatch);
      else if (erreur == "NomDejaUtilise")
        print(S.of(context).UsernameTaken);
      else
      print( S.of(context).InvalidCredentials);
    }
  }


  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(

        backgroundColor: Theme.of(context).colorScheme.inversePrimary,

        title: Text(widget.title),
      ),
      body: Center(
          child:Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              SizedBox(
                width: 300, // largeur souhaitée
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
                  backgroundColor: Colors.red, // couleur de fond
                  foregroundColor: Colors.white, // couleur du texte
                  padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 32),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  textStyle: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                onPressed: () async {
                  await getUtilisateur();
                  Navigator.push(context, MaterialPageRoute(builder: (context) => Accueil()));

                },
                child: Text( S.of(context).inscription),
              )
            ],

          )


      ),

    );

  }
}
