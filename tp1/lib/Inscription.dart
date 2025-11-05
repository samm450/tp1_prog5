
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

  getUtilisateur() async {
    try {
      response = await UserService.inscription(
          nomControlleur.text, passwordControlleur.text,
          confirmpasswordControlleur.text);
      setState(() {
      });
    } on DioException catch (e) {
      String erreur = e.response!.data;
      if (e.response?.statusCode == 400) {
        print(S.of(context).NoConnexion);

        setState(() {
          isLoading = false;
        });
      }
      else if (erreur == "NomTropCourt")
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
    finally{
      setState(() {
        isLoading = false;
      });
    }
  }

  onPressed() async {
    //apres avoir clicker sur le bouton, on desactive le bouton et on affiche un cercle de chargement

    setState(() {
      isLoading = true;
    });
    await getUtilisateur();
    Navigator.push(context, MaterialPageRoute(builder: (context) => Accueil()));

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
          SizedBox(
            height: 5,
            child: isLoading ? LinearProgressIndicator() : null
          ),
          Expanded(
            child: Center(
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
                      onPressed: isLoading ? null: onPressed,
                      child: Text( S.of(context).inscription),
                    ),

                    //if (isLoading) const CircularProgressIndicator(),
                  ],

                )


            ),
          ),
        ],
      ),

    );

  }
}
