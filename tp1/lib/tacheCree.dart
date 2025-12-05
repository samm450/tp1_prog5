import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dio/dio.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'generated/l10n.dart';
import 'models/SessionManager.dart';
import 'service.dart';
import 'accueil.dart';
import 'drawer.dart';

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

  Future<bool> _ajouterTache() async {
    try {
      final nomTrim = nomController.text.trim();

      // Validation 1 : nom non vide
      if (nomTrim.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Le nom de la tâche ne peut pas être vide.')),
        );
        return false;
      }

      // Validation 2 : date fournie et dans le futur
      if (dateEcheance == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Veuillez sélectionner une date d\'échéance.')),
        );
        return false;
      }
      if (!dateEcheance!.isAfter(DateTime.now())) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('La date doit être dans le futur.')),
        );
        return false;
      }

      Future<bool> _tacheExiste(String nom) async {
        final task = await FirebaseService.getTaskCollection().where('nom', isEqualTo: nom).limit(1).get();
        return task.docs.isNotEmpty;
      }

      final exists = await _tacheExiste(nomTrim);
      if (exists) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Une tâche avec ce nom existe déjà.')),
        );
        return false;
      }

      // Appel du service seulement si toutes les validations passent
      await FirebaseService.ajouterTacheFirebase(nomTrim, dateEcheance!);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Tâche créée avec succès.')),
      );
      return true;
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Erreur lors de la création: ${e.toString()}')),
      );
      return false;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(S.of(context).creeTache)),
      drawer: const MonDrawer(),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextField(
              controller: nomController,
              decoration: InputDecoration(
                labelText: S.of(context).nomTache,
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 24),
            Row(
              children: [
                Expanded(
                  child: Text(
                    dateEcheance == null
                        ? S.of(context).noDate
                        : '${S.of(context).echeance}: ${dateEcheance!.day}/${dateEcheance!.month}/${dateEcheance!.year}',
                  ),
                ),
                TextButton(
                  onPressed: () => _selectDate(context),
                  child: Text(S.of(context).selectDate),
                ),
              ],
            ),
            const SizedBox(height: 32),
            ElevatedButton(
              onPressed: () async {
                final success = await _ajouterTache();
                if (success) {
                  Navigator.push(context, MaterialPageRoute(builder: (context) => Accueil()));
                }
              },
              child: Text(S.of(context).add),
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
