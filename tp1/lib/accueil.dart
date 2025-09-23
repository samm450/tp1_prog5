import 'package:flutter/material.dart';
import 'package:tp1/models/tache.dart';
import 'package:tp1/tacheCree.dart';
import 'package:tp1/service.dart';
import 'package:tp1/drawer.dart';

class Accueil extends StatefulWidget {
  const Accueil({super.key});

  @override
  State<Accueil> createState() => _AccueilState();
}

class _AccueilState extends State<Accueil> {

  List<Tache> taches = [];

  @override void initState() {
    // TODO: implement initState
    super.initState();
    getTaches();

  }

  getTaches() async {
    taches = await TacheService.getTaches2();
    setState(() {});
  }


  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        title: const Text('Accueil'),
      ),
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
                MaterialPageRoute(builder: (context) => TacheCree()),
              );
            },
            title: Text(tache.nom),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('pourcentage de temps écoulé : ${tache.pourcentageTemps ?? "N/A"}'),
                SizedBox(height: 7),
                Text('pourcentage de la tache'),
                LinearProgressIndicator(
                  value: (tache.pourcentageAvancement ?? 0) / 100,
                  minHeight: 6,
                  backgroundColor: Colors.grey[300],
                  color: Colors.blue,
                ),
                SizedBox(height: 5),
                Text("pourcentage d'avancement"),
                LinearProgressIndicator(
                  value: (tache.pourcentageAvancement ?? 0) / 100,
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


/*FutureBuilder<List<Tache>>(
        future: TacheService.getTaches(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Erreur: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('Aucune tâche trouvée.'));
          }
          final taches = snapshot.data!;
          return ListView.builder(
            itemExtent: 130,
            itemCount: taches.length,
            itemBuilder: (context, index) {
              final tache = taches[index];
              return ListTile(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => TacheCree(tache: tache)),
                  );
                },
                title: Text(tache.nom),
                subtitle: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('pourcentage de temps écoulé : ${tache.pourcentageTemps ?? "N/A"}'),
                    SizedBox(height: 7),
                    Text('pourcentage de la tache'),
                    LinearProgressIndicator(
                      value: (tache.pourcentageAvancement ?? 0) / 100,
                      minHeight: 6,
                      backgroundColor: Colors.grey[300],
                      color: Colors.blue,
                    ),
                    SizedBox(height: 5),
                    Text("pourcentage d'avancement"),
                    LinearProgressIndicator(
                      value: (tache.pourcentageAvancement ?? 0) / 100,
                      minHeight: 6,
                      backgroundColor: Colors.grey[300],
                      color: Colors.green,
                    ),
                  ],
                ),
              );
            },
          );
        },
      ),*/