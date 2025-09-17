import 'package:flutter/material.dart';
import 'package:tp1/tacheCree.dart';

class Accueil extends StatefulWidget {
  const Accueil({super.key});

  @override
  State<Accueil> createState() => _AccueilState();
}

class _AccueilState extends State<Accueil> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Accueil'),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const TacheCree()),
          );
        },
        child: const Icon(Icons.add),
      ),

      //cree une list qui prend tout l'ecran qui affiche des taches
       body: ListView(
         itemExtent: 130,
         children: <Widget>[
           //quand je click sur la list tile, cela me mene a la page de consultation de la tache

           ListTile(
              onTap: () {
                 Navigator.push(
                   context,
                   MaterialPageRoute(builder: (context) => const TacheCree()),
                 );
              },
             title: Text('Tache 1'),
              subtitle : Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
              Text('pourcentage de temps écoulé :'  'chiffre a inscrire'),
              SizedBox(height: 7),
              Text('pourcentage de la tache'),
             LinearProgressIndicator(
                    value: 10 / 100,
                    minHeight: 6,
                    backgroundColor: Colors.grey[300],
                    color: Colors.blue
             ),
                  SizedBox(height: 5),
                  Text("pourcentage d'avancement"),
                  LinearProgressIndicator(
                      value: 10 / 100,
                      minHeight: 6,
                      backgroundColor: Colors.grey[300],
                      color: Colors.green
                  ),

           ],
          )

           ),
           ListTile(
             title: Text('Tache 2'),
           ),
           ListTile(
             title: Text('Tache 3'),
           ),
           ListTile(
             title: Text('Tache 4'),
           ),
           ListTile(
             title: Text('Tache 5'),
           ),
           ListTile(
             title: Text('Tache 6'),
           ),
           ListTile(
             title: Text('Tache 7'),
           ),
           ListTile(
             title: Text('Tache 8'),
           ),
           ListTile(
             title: Text('Tache 9'),
           ),
           ListTile(
             title: Text('Tache 10'),
           ),
           ListTile(
             title: Text('Tache 11'),
           ),ListTile(
             title: Text('Tache 12'),
           ),
           ListTile(
             title: Text('Tache 13'),
           ),
           ListTile(
             title: Text('Tache 14'),
           ),
           ListTile(
             title: Text('Tache 15'),
           ),
           ListTile(
             title: Text('Tache 16'),
           ),
           ListTile(
             title: Text('Tache 17'),
           ),

         ],
    ));
  }
}
