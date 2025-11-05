import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'Inscription.dart';
import 'accueil.dart';
import 'generated/l10n.dart';
import 'models/utilisateur.dart';
import 'service.dart';


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

  getUtilisateur() async {

    try {
      response = await UserService.connexion(
          nomControlleur.text, passwordControlleur.text);
      setState(() {});
    }
    on DioException catch (e) {
      String erreur = e.response!.data;
      if(e.response?.statusCode == 400){
        print(S.of(context).NoConnexion);

        setState(() {
          isLoading = false;
        });
      }
      else if (erreur == "MauvaisNomOuMotDePasse")
        print( S.of(context).InvalidCredentials);
      else if (erreur == "MotDePasseTropCourt")
        print( S.of(context).PasswordTooShort);
      else if (erreur == "MotDePasseTropLong")
        print( S.of(context).MotDePasseTropLong);
      else if (erreur == "NomTropLong")
        print( S.of(context).NomTropLong);
      else if (erreur == "NomTropCourt")
        print(S.of(context).NameTooShort);
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
  onPressed1() async {
    //apres avoir clicker sur le bouton, on desactive le bouton et on affiche un cercle de chargement

    setState(() {
      isLoading = true;
    });
    Navigator.push(context, MaterialPageRoute(builder: (context) => Inscription(title: "inscription",)));

  }

  bool isLoading = false;

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(

        backgroundColor: Theme.of(context).colorScheme.inversePrimary,

        title: Text(widget.title),
      ),
      body: Column(
        children : [
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
                    onPressed : isLoading ? null : onPressed,
                    child: Text(S.of(context).connexion),
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
                    onPressed : isLoading ? null : onPressed1,
                    child: Text(S.of(context).inscription),
                  )
                ],

              )
            )
          )
        ],
      ),

    );

  }
}
