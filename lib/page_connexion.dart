import 'package:flutter/material.dart';
import 'page_liste_notes.dart';
import 'page_inscription.dart';
import 'gestion_base_donnees.dart';

class PageConnexion extends StatefulWidget {
  const PageConnexion({super.key});

  @override
  _EtatPageConnexion createState() => _EtatPageConnexion();
}

class _EtatPageConnexion extends State<PageConnexion> {
  final TextEditingController _controlleurNomUtilisateur = TextEditingController();
  final TextEditingController _controlleurMotDePasse = TextEditingController();
  final GestionBaseDonnees _gestionBD = GestionBaseDonnees();

  void _seConnecter() async {
    final nomUtilisateur = _controlleurNomUtilisateur.text.trim();
    final motDePasse = _controlleurMotDePasse.text.trim();

    if (nomUtilisateur.isEmpty || motDePasse.isEmpty) {
      _afficherErreur('Veuillez saisir tous les champs');
      return;
    }

    final estValide = await _gestionBD.validerUtilisateur(nomUtilisateur, motDePasse);
    
    if (estValide) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const PageListeNotes()),
      );
    } else {
      _afficherErreur('Nom d\'utilisateur ou mot de passe incorrect');
    }
  }

  void _afficherErreur(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.red,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const SizedBox(height: 40),
              
              // IMAGE DCLIC
              Image.asset(
                'assets/images/dclic.jpg', // Votre image
                height: 100,
                width: 500,
                fit: BoxFit.cover, // Ou BoxFit.contain selon votre préférence
              ),
              
              const SizedBox(height: 20),
              
              const Text(
                'PROJET FINAL',
                style: TextStyle(
                  fontSize: 32, 
                  fontWeight: FontWeight.bold, 
                  color: Colors.blue,
                ),
              ),
              const SizedBox(height: 5),
              const Text(
                'Ma to-do list',
                style: TextStyle(
                  fontSize: 16, 
                  fontWeight: FontWeight.w300, 
                  color: Colors.pinkAccent,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 40),
              
              TextField(
                controller: _controlleurNomUtilisateur,
                decoration: const InputDecoration(
                  labelText: 'Nom d\'utilisateur',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.person),
                ),
              ),
              const SizedBox(height: 20),
              
              TextField(
                controller: _controlleurMotDePasse,
                obscureText: true,
                decoration: const InputDecoration(
                  labelText: 'Mot de passe',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.lock),
                ),
              ),
              const SizedBox(height: 30),
              
              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  onPressed: _seConnecter,
                  child: const Text('Se Connecter'),
                ),
              ),
              const SizedBox(height: 20),
              
              TextButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const PageInscription()),
                  );
                },
                child: const Text('Créer un Compte'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}