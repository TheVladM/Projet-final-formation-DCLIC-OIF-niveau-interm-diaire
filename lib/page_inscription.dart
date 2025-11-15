import 'package:flutter/material.dart';
import 'gestion_base_donnees.dart';
import 'page_connexion.dart';

class PageInscription extends StatefulWidget {
  const PageInscription({super.key});

  @override
  _EtatPageInscription createState() => _EtatPageInscription();
}

class _EtatPageInscription extends State<PageInscription> {
  final TextEditingController _controlleurNomUtilisateur = TextEditingController();
  final TextEditingController _controlleurMotDePasse = TextEditingController();
  final TextEditingController _controlleurConfirmationMotDePasse = TextEditingController();

  void _sInscrire() async {
    final nomUtilisateur = _controlleurNomUtilisateur.text.trim();
    final motDePasse = _controlleurMotDePasse.text.trim();
    final confirmationMotDePasse = _controlleurConfirmationMotDePasse.text.trim();

    if (nomUtilisateur.isEmpty || motDePasse.isEmpty) {
      _afficherErreur('Veuillez remplir tous les champs');
      return;
    }

    if (motDePasse != confirmationMotDePasse) {
      _afficherErreur('Les mots de passe ne correspondent pas');
      return;
    }

    if (motDePasse.length < 4) {
      _afficherErreur('Le mot de passe doit contenir au moins 4 caractères');
      return;
    }

    final GestionBaseDonnees gestionBD = GestionBaseDonnees();
    final utilisateurExiste = await gestionBD.utilisateurExiste(nomUtilisateur);
    
    if (utilisateurExiste) {
      _afficherErreur('Ce nom d\'utilisateur est déjà utilisé');
      return;
    }

    await gestionBD.insererUtilisateur(Utilisateur(nomUtilisateur: nomUtilisateur, motDePasse: motDePasse));
    
    if (mounted) {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('Compte Créé'),
          content: const Text('Votre compte a été créé avec succès.'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => const PageConnexion()),
                );
              },
              child: const Text('OK'),
            ),
          ],
        ),
      );
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
                'assets/images/dclic.jpg',
                height: 100,
                width: 500,
                fit: BoxFit.cover,
              ),
              
              const SizedBox(height: 20),
              
              const Text(
                'Bienvenu sur l\'interface de creation de compte',
                style: TextStyle(
                  fontSize: 16, 
                  fontWeight: FontWeight.bold, 
                  color: Colors.pink,
                ),
              ),
              const SizedBox(height: 5),
              const Text(
                'Créer un Compte',
                style: TextStyle(
                  fontSize: 18, 
                  fontWeight: FontWeight.w300, 
                  color: Colors.grey,
                ),
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
              const SizedBox(height: 20),
              
              TextField(
                controller: _controlleurConfirmationMotDePasse,
                obscureText: true,
                decoration: const InputDecoration(
                  labelText: 'Confirmer le mot de passe',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.lock_outline),
                ),
              ),
              const SizedBox(height: 30),
              
              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  onPressed: _sInscrire,
                  child: const Text('Créer le Compte'),
                ),
              ),
              const SizedBox(height: 20),
              
              TextButton(
                onPressed: () {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (context) => const PageConnexion()),
                  );
                },
                child: const Text('Déjà un compte ? Se Connecter'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}