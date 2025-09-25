import 'dart:developer';

import 'package:flutter/material.dart';
import 'accueil.dart';
import 'models/SessionManager.dart';
import 'service.dart';

class TacheCree extends StatefulWidget {
  const TacheCree({super.key});

  @override
  State<TacheCree> createState() => _TacheCreeState();
}

class _TacheCreeState extends State<TacheCree> {
  final TextEditingController nomController = TextEditingController();
  DateTime? dateEcheance;

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: dateEcheance ?? DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime(2100),
    );
    if (picked != null && picked != dateEcheance) {
      setState(() {
        dateEcheance = picked;
      });
    }
  }

  Future<void> _ajouterTache() async {
    //icic on veux ajouter la tache cree a la liste de tache a l'utilisatuer utiliser en ce momemnt avec le service
    final nomTache = nomController.text;
    String nomUtilisateur = SessionManager.nomUtilisateur!;
    final TacheService tache = TacheService();

    if(!nomTache.isEmpty && dateEcheance != null){
      await tache.AjoutTache(nomTache, dateEcheance.toIso8601String(), nomUtilisateur)
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Créer une tâche')),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextField(
              controller: nomController,
              decoration: const InputDecoration(
                labelText: 'Nom de la tâche',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 24),
            Row(
              children: [
                Expanded(
                  child: Text(
                    dateEcheance == null
                        ? 'Aucune date sélectionnée'
                        : 'Échéance: ${dateEcheance!.day}/${dateEcheance!.month}/${dateEcheance!.year}',
                  ),
                ),
                TextButton(
                  onPressed: () => _selectDate(context),
                  child: const Text('Choisir la date'),
                ),
              ],
            ),
            const SizedBox(height: 32),
            ElevatedButton(
              onPressed: _ajouterTache,
              child: const Text('Ajouter'),
              style: ElevatedButton.styleFrom(
                minimumSize: const Size(double.infinity, 48),
                backgroundColor: Colors.red,
                foregroundColor: Colors.white,
                textStyle: const TextStyle(fontSize: 18),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
