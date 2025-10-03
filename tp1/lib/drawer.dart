import 'package:flutter/material.dart';
import 'accueil.dart';
import 'tacheCree.dart';
import 'connexion.dart';
import 'models/SessionManager.dart';
import 'service.dart';

class MonDrawer extends StatelessWidget {
  const MonDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          DrawerHeader(
            decoration: BoxDecoration(
              color: Colors.blueAccent,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CircleAvatar(
                  radius: 32,
                  backgroundColor: Colors.white,
                  child: Icon(Icons.person, size: 40, color: Colors.blueAccent),
                ),
                const SizedBox(height: 12),
                Text(
                  SessionManager.nomUtilisateur ?? '',
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
          ListTile(
            leading: const Icon(Icons.home),
            title: const Text('Accueil'),
            onTap: () {
              Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => const Accueil()));
            },
          ),
          ListTile(
            leading: const Icon(Icons.add_task),
            title: const Text('Ajout de tâche'),
            onTap: () {
              Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => const TacheCree()));
            },
          ),
          const Divider(),
          ListTile(
            leading: const Icon(Icons.logout),
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
