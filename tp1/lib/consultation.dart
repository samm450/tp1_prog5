import 'package:flutter/material.dart';
import 'models/tache.dart';
import 'service.dart';
import 'drawer.dart';
import 'accueil.dart';

class consultation extends StatefulWidget {
  final int id;
  const consultation({super.key, required this.id});

  @override
  State<consultation> createState() => _consultationState();
}

class _consultationState extends State<consultation> {

  Tache tache = Tache();
  double avancement = 0;

  @override
  void initState() {
    super.initState();
    getDetails();
  }

  getDetails() async {
    int id = widget.id;
    tache = await TacheService.TacheDetail(id);
    avancement = tache.pourcentageAvancement.toDouble();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: Text('Consultation')),
        drawer: const MonDrawer(),
        // lib/consultation.dart
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Nom : ${tache.nom}',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
              SizedBox(height: 16),
              Text(
                  'Date d\'échéance : ${tache.dateLimite ?? "Non renseignée"}'),
              SizedBox(height: 16),
              Text('Pourcentage d\'avancement : ${avancement.toStringAsFixed(
                  0)}%'),
              Slider(
                value: avancement,
                min: 0,
                max: 100,
                divisions: 100,
                label: '${avancement.toStringAsFixed(0)}%',
                onChanged: (value) {
                  setState(() {
                    avancement = value;
                    tache.pourcentageAvancement = value.toInt();
                  });
                },
              ),
              SizedBox(height: 16),
              Text('Pourcentage de temps écoulé : ${tache.pourcentageTemps ??
                  0}%'),
              SizedBox(height: 16),
              ElevatedButton(
                onPressed: () async {
                  await TacheService.UpdateProgress(tache.id, avancement.toInt());
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Modifications enregistrées')),
                  );
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => Accueil()));
                },
                child: Text('Enregistrer'),
              ),
            ],
          ),

        )
    );
  }
}