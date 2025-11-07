// dart
import 'dart:async';
import 'dart:io';

import 'package:dio/dio.dart';
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

  Timer? _timeoutTimer;
  bool _timedOut = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    getTaches();
  }
  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _timeoutTimer?.cancel();
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


  void _showSnackBar(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message), duration: const Duration(seconds: 3)),
    );
  }

  Future<void> getTaches() async {
    setState(() => isLoading = true);

    // (Re)initialiser le timeout
    _timedOut = false;
    _timeoutTimer?.cancel();
    _timeoutTimer = Timer(const Duration(seconds: 5), () {
      if (!mounted) return;
      _timedOut = true;
      _showSnackBar(context, S.of(context).NoConnexion);
      setState(() => isLoading = false);
    });

    try {
      final resultat = await TacheService.getTaches2();

      // Si le timeout s'est produit pendant l'attente, ignorer la suite
      if (_timedOut) {
        _timeoutTimer?.cancel();
        return;
      }

      _timeoutTimer?.cancel();
      setState(() {
        taches = resultat;
      });
    } on DioException catch (e) {
      _timeoutTimer?.cancel();
      if (_timedOut) return;
      else {
        // Utiliser e.message si disponible, sinon message générique
        final errMsg = e.message ?? S.of(context).NoConnexion;
        _showSnackBar(context, errMsg);
      }
    } finally {
      _timeoutTimer?.cancel();
      if (mounted && !_timedOut) {
        setState(() {
          isLoading = false;
        });
      }
    }
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
                          builder: (context) => consultation(id: tache.id),
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
                                imageUrl:
                                '${TacheService.baseUrl}/fichier/${tache.idPhoto}?largeur=80',
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
