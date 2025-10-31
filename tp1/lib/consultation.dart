import 'dart:io';
import 'package:flutter/material.dart';
import 'generated/l10n.dart';
import 'models/tache.dart';
import 'service.dart';
import 'drawer.dart';
import 'accueil.dart';
import 'package:image_picker/image_picker.dart';
import 'package:cached_network_image/cached_network_image.dart';

class consultation extends StatefulWidget {
  final int id;
  const consultation({super.key, required this.id});

  @override
  State<consultation> createState() => _consultationState();
}

class _consultationState extends State<consultation> {

  File? _image;
  Tache tache = Tache();
  double avancement = 0;

  @override
  void initState() {
    super.initState();
    getDetails();
  }
  
   void pickImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _image = File(pickedFile.path);
      });
    }
  }

  UploadImage() async {
    int id = widget.id;
    if(_image != null) {
      await TacheService.AjouterImageBD(_image!, id);
    }
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
        appBar: AppBar(title: Text(S.of(context).consultation)),
        drawer: const MonDrawer(),
        // lib/consultation.dart
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('${S.of(context).name} ${tache.nom}',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                SizedBox(height: 16),
                Text(
                    ' ${S.of(context).dateDechange} ${tache.dateLimite ?? "Non renseignée"}'),
                SizedBox(height: 16),
                Text('${S.of(context).pourcentageAvancement} ${avancement.toStringAsFixed(
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
                Text('${S.of(context).pourcentageTempsEcoule} ${tache.pourcentageTemps ??
                    0}%'),
                SizedBox(height: 16),

                ElevatedButton(
                  onPressed: pickImage,
                  child: Text(S.of(context).pickImage),
                ),

                SizedBox(
                  height: 250,
                  width: double.infinity,
                  child: CachedNetworkImage(
                    imageUrl: '${TacheService.baseUrl}/fichier/${tache.idPhoto}',
                    placeholder: (context, url) => Center(child: CircularProgressIndicator()),
                    errorWidget: (context, url, error) => Icon(Icons.error),
                  ),
                ),
                SizedBox(height: 16),

                ElevatedButton(
                  onPressed: () async {
                    await TacheService.UpdateProgress(tache.id, avancement.toInt());
                    await UploadImage();
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text(S.of(context).modification)),
                    );
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) => Accueil()));
                  },
                  child: Text(S.of(context).enregistrer),
                ),
              ],
            ),

          ),
        )
    );
  }
}