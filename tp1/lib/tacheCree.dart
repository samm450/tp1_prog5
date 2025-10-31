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

  Future<void> _ajouterTache() async {
    final nomTache = nomController.text;

    if(!nomTache.isEmpty && dateEcheance != null){
      await TacheService.AjoutTache(nomTache, dateEcheance!);
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
                await _ajouterTache();
                Navigator.push(context, MaterialPageRoute(builder: (context) => Accueil()),);
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
