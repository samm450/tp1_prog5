// dart
import 'dart:async';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
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

class _AccueilState extends State<Accueil> with WidgetsBindingObserver {
  List<Tache> taches = [];
  File image = File('');
  bool isLoading = false;
  final FirebaseFirestore _firebaseStore = FirebaseFirestore.instance;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    getTaches();
  }
  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }
  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);
    if (state == AppLifecycleState.resumed) {
      _refreshDataOnResume();
    }
  }

  Future<void> _refreshDataOnResume() async {
    if (!mounted) return;
    try {
      setState(() => isLoading = true); // si vous avez un indicateur
      await getTaches(); // remplacer par votre méthode de chargement existante
    } catch (e) {
      // gestion d'erreur (optionnel : afficher SnackBar)
    } finally {
      if (mounted) setState(() => isLoading = false);
    }
  }


  Future<void> deleteTache(Tache tache) async {
    await FirebaseService.getTaskCollection().doc(tache.id).delete();
    if (!mounted) return;
    setState(() {
      taches.removeWhere((t) => t.id == tache.id);
      isLoading = false;
    });
    _showSnackBar(context, 'Tâche supprimée');
  }

  void _showSnackBar(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message), duration: const Duration(seconds: 3)),
    );
  }

  Future<void> getTaches() async {

    setState(() => isLoading = true);


    final resultat = await FirebaseService.getTachesFromFirebase();
    setState(() {
      taches = resultat;
      isLoading = false;
    });
  }

  onPressed() async {
    setState(() {
      isLoading = true;
    });
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const TacheCree()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(S.of(context).acceuil)),
      drawer: const MonDrawer(),
      floatingActionButton: FloatingActionButton(
        onPressed: isLoading ? null : onPressed,
        child: const Icon(Icons.add),
      ),
      body: AbsorbPointer(
        absorbing: isLoading,
        child: Column(
          children: [
            if (isLoading) const LinearProgressIndicator(minHeight: 4),
            Expanded(
              child: ListView.builder(
                itemExtent: 150,
                itemCount: taches.length,
                itemBuilder: (context, index) {
                  final tache = taches[index];
                  return ListTile(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => consultation(id: tache.id,), //a changer, hardcoder
                        ),
                      );
                    },
                    title: Text(
                      tache.nom,
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const SizedBox(height: 7),
                                  Text(
                                    '${S.of(context).tempsEcouler} ${tache.pourcentageTemps}%',
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                  const SizedBox(height: 8),
                                  Text(S.of(context).pourcentage),
                                  LinearProgressIndicator(
                                    value: (tache.pourcentageTemps) / 100,
                                    minHeight: 6,
                                    backgroundColor: Colors.grey[300],
                                    color: Colors.blue,
                                  ),
                                  const SizedBox(height: 10),
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
                            Padding(
                              padding: const EdgeInsets.only(left: 12.0),
                              child: CachedNetworkImage(
                                imageUrl: tache.PhotoURL,
                                placeholder: (context, url) =>
                                const Center(child: CircularProgressIndicator()),
                                errorWidget: (context, url, error) =>
                                const Icon(Icons.error),
                                width: 80,
                                height: 80,
                              ),
                            ),

                          ],
                        )
                      ],
                    ),
                    trailing: IconButton(
                      icon: const Icon(Icons.delete, color: Colors.red),
                      onPressed: isLoading ? null : () => deleteTache(tache),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
