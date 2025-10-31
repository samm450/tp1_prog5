import 'dart:io';

import 'package:flutter/material.dart';
import 'consultation.dart';
import 'generated/l10n.dart';
import 'models/tache.dart';
import 'tacheCree.dart';
import 'service.dart';
import 'drawer.dart';
import 'package:cached_network_image/cached_network_image.dart';

class Accueil extends StatefulWidget {
  const Accueil({super.key});

  @override
  State<Accueil> createState() => _AccueilState();
}

class _AccueilState extends State<Accueil> {
  List<Tache> taches = [];
  File image = File('');

  @override
  void initState() {
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
      appBar: AppBar(title: Text(S.of(context).acceuil)),
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
        itemExtent: 150,
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
            title: Text(tache.nom,
                        style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            )),

            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Partie gauche : texte et barres de progression
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(height: 7),

                          Text(
                            '${S.of(context).tempsEcouler} ${tache.pourcentageTemps}%',
                            overflow: TextOverflow.ellipsis,
                          ),
                          SizedBox(height: 8),
                          Text(S.of(context).pourcentage),
                          LinearProgressIndicator(
                            value: (tache.pourcentageTemps) / 100,
                            minHeight: 6,
                            backgroundColor: Colors.grey[300],
                            color: Colors.blue,
                          ),
                          SizedBox(height: 10),
                          Text(S.of(context).pourcentageAvancement),
                          LinearProgressIndicator(
                            value: (tache.pourcentageAvancement) / 100,
                            minHeight: 6,
                            backgroundColor: Colors.grey[300],
                            color: Colors.green,
                          ),
                        ],
                      ),
                    ),
                    // Partie droite : image
                    Padding(
                      padding: const EdgeInsets.only(left: 12.0),
                      child: CachedNetworkImage(
                        imageUrl: '${TacheService.baseUrl}/fichier/${tache.idPhoto}?largeur=80',
                        placeholder: (context, url) => CircularProgressIndicator(),
                        errorWidget: (context, url, error) => Icon(Icons.error),
                        width: 80,
                        height: 80,
                      ),
                    ),
                  ],
                )
              ],
            ),
          );
        },
      ),
    );
  }
}
