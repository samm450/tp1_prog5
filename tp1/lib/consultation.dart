
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'generated/l10n.dart';
import 'models/tache.dart';
import 'service.dart';
import 'drawer.dart';
import 'accueil.dart';
import 'package:image_picker/image_picker.dart';
import 'package:cached_network_image/cached_network_image.dart';

class consultation extends StatefulWidget {
  final String id;
  const consultation({super.key, required this.id});

  @override
  State<consultation> createState() => _consultationState();
}

class _consultationState extends State<consultation> with WidgetsBindingObserver {
  File? _image;
  Tache tache = Tache();
  double avancement = 0;
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    getDetails();
    isLoading = true;
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    // annuler timers / controllers existants si besoin
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
      setState(() => isLoading = true);
      await getDetails(); // remplacer par votre méthode de chargement existante
    } catch (e) {
      // gérer l'erreur (optionnel : afficher SnackBar)
    } finally {
      if (mounted) setState(() => isLoading = false);
    }
  }
  final picker = ImagePicker();

  // on met le fichier dans l'etat pour l'afficher dans la page
  var _imageFile;
  var _publicUrl;

  sendPicture(XFile xfile) async {

    final supabase = Supabase.instance.client;

    String bucketid = "Supa-bucket";

    try {
      await supabase
          .storage
          .createBucket(bucketid, BucketOptions(public: true));
    } on StorageException catch(e) {

      if(e.error == "Duplicate") {
        // Le bucket existe déjà
        print(e);
      }

    }

    final String fullPath = await supabase
        .storage
        .from(bucketid)
        .upload(
        xfile.name,
        File(xfile.path)
    );

    _publicUrl = supabase
        .storage
        .from(bucketid)
        .getPublicUrl(xfile.name);
  }

  Future getImage() async {
    print("ouverture du selecteur d'image");
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      print("l'image a ete choisie ${pickedFile.path}");
      _imageFile = File(pickedFile.path);
      setState(() {});

      await sendPicture(pickedFile);
      setState(() { });
    }
  }

  onPressedButton() async{
    setState(() => isLoading = true);
    try {
      //await TacheService.UpdateProgress(tache.id, avancement.toInt());
      await FirebaseService.modifierTacheFirebase(tache.id, avancement.toInt());
      await UploadImage();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(S.of(context).modification)),
      );
      Navigator.push(context,
          MaterialPageRoute(builder: (context) => Accueil()));
    } finally {
      setState(() => isLoading = false);
    }
  }

  getDetails() async {
    setState(() => isLoading = true);
    try {
      String id = widget.id;
      tache = await FirebaseService.getTache(id);
      avancement = tache.pourcentageAvancement.toDouble();
      setState(() {});
    }
    finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(S.of(context).consultation),
          bottom: PreferredSize(
            preferredSize: const Size.fromHeight(3),
            child: SizedBox(
              height: 3,
              child: isLoading ? const LinearProgressIndicator() : const SizedBox.shrink(),
            ),
          ),
        ),
        drawer: const MonDrawer(),
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
                  onPressed: isLoading ? null : pickImage,
                  child: Text(S.of(context).pickImage),
                ),

                SizedBox(
                  height: 250,
                  width: double.infinity,
                  child: buildImage(),
                ),
                SizedBox(height: 16),

                ElevatedButton(
                  onPressed : isLoading ? null : onPressedButton,
                  child: Text(S.of(context).enregistrer),
                ),
              ],
            ),
          ),
        )
    );
  }

  Widget buildImage() {
    if (_image != null) {
      return Image.file(_image!);
    }
    return CachedNetworkImage(
        imageUrl:
        'A CHANGER',
        placeholder: (context, url) =>
        const Center(child: CircularProgressIndicator()),
        errorWidget: (context, url, error) =>
        const Icon(Icons.error),
        fit: BoxFit.contain
    );
  }
}