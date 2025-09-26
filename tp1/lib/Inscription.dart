
import 'package:flutter/material.dart';
import 'package:tp1/models/utilisateur.dart';
import 'package:tp1/service.dart';
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
    response = await UserService.inscription(nomControlleur.text, passwordControlleur.text, confirmpasswordControlleur.text);
    setState(() {});
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
                    labelText: 'Username',
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
                    labelText: 'password',
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
                    labelText: 'password confirm',
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
                child: const Text("S'inscrire"),
              )
            ],

          )


      ),

    );

  }
}
