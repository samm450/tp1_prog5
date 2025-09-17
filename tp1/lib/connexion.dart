import 'package:flutter/material.dart';
import 'package:tp1/Inscription.dart';
import 'accueil.dart';


class Connexion extends StatefulWidget {
  const Connexion({super.key, required this.title});



  final String title;

  @override
  State<Connexion> createState() => _ConnexionState();
}

class _ConnexionState extends State<Connexion> {


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
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'password',
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
            onPressed: () {
              Navigator.push(context, MaterialPageRoute(builder: (context) => const Accueil()));
            },
            child: const Text('Connexion'),
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
              onPressed: () {
                Navigator.push(context, MaterialPageRoute(builder: (context) => const Inscription(title: "Inscription")));
              },
              child: const Text('Inscription'),
            )
          ],

      )


      ),

    );

  }
}
