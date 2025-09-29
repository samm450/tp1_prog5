import 'dart:developer';

import 'package:flutter/material.dart';
import 'accueil.dart';
import 'tacheCree.dart';
import 'connexion.dart';
import 'models/SessionManager.dart';
import 'package:untitled1/service.dart';

class MonDrawer extends StatelessWidget {
  const MonDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        children: [
          UserAccountsDrawerHeader(
            accountName: Text(SessionManager.nomUtilisateur ?? ''),
            accountEmail: null,
          ),
          ListTile(
            title: const Text('Accueil'),
            onTap: () {
              Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => const Accueil()));
            },
          ),
          ListTile(
            title: const Text('Ajout de tâche'),
            onTap: () {
              Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => const TacheCree()));
            },
          ),
          ListTile(
            title: const Text('Déconnexion'),
            onTap: () {
              UserService.deconnexion();
              Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => const Connexion(title: 'Connexion')));
            },
          ),
        ],
      ),
    );
  }
}
