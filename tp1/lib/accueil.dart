import 'package:flutter/material.dart';
import 'consultation.dart';
import 'models/tache.dart';
import 'tacheCree.dart';
import 'service.dart';
import 'drawer.dart';

class Accueil extends StatefulWidget {
  const Accueil({super.key});

  @override
  State<Accueil> createState() => _AccueilState();
}

class _AccueilState extends State<Accueil> {
  List<Tache> taches = [];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getTaches();
    setState(() {});
  }

  getTaches() async {
    taches = await TacheService.getTaches2();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Accueil')),
      drawer: const MonDrawer(),
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
      body: ListView.builder(
        itemExtent: 130,
        itemCount: taches.length,
        itemBuilder: (context, index) {
          final tache = taches[index];
          return ListTile(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => consultation(id: tache.id),
                ),
              );
            },
            title: Text(tache.nom),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'pourcentage de temps écoulé : ${tache.pourcentageTemps} %',
                ),
                SizedBox(height: 7),
                Text('pourcentage de la tache'),
                LinearProgressIndicator(
                  value: (tache.pourcentageTemps) / 100,
                  minHeight: 6,
                  backgroundColor: Colors.grey[300],
                  color: Colors.blue,
                ),
                SizedBox(height: 5),
                Text("pourcentage d'avancement"),
                LinearProgressIndicator(
                  value: (tache.pourcentageAvancement) / 100,
                  minHeight: 6,
                  backgroundColor: Colors.grey[300],
                  color: Colors.green,
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
