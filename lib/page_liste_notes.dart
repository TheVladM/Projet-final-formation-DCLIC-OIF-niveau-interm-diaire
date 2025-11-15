import 'package:flutter/material.dart';
import 'gestion_base_donnees.dart';
import 'page_edition_note.dart';

class PageListeNotes extends StatefulWidget {
  const PageListeNotes({super.key});

  @override
  _EtatPageListeNotes createState() => _EtatPageListeNotes();
}

class _EtatPageListeNotes extends State<PageListeNotes> {
  List<Note> _notes = [];
  final GestionBaseDonnees _gestionBD = GestionBaseDonnees();

  @override
  void initState() {
    super.initState();
    _chargerNotes();
  }

  void _chargerNotes() async {
    final notes = await _gestionBD.obtenirNotes();
    setState(() {
      _notes = notes;
    });
  }

  void _supprimerNote(int id) async {
    await _gestionBD.supprimerNote(id);
    _chargerNotes();
  }

  void _confirmerSuppression(int id) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Supprimer la Note'),
        content: const Text('Voulez-vous vraiment supprimer cette note ?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Annuler'),
          ),
          TextButton(
            onPressed: () {
              _supprimerNote(id);
              Navigator.pop(context);
            },
            child: const Text('Supprimer'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Mes Notes'),
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
      ),
      body: _notes.isEmpty
          ? const Center(
              child: Text(
                'Aucune note trouvée\nCliquez sur + pour en ajouter',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 18, color: Colors.grey),
              ),
            )
          : ListView.builder(
              itemCount: _notes.length,
              itemBuilder: (context, index) {
                final note = _notes[index];
                return Card(
                  margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                  elevation: 2,
                  child: ListTile(
                    leading: const Icon(Icons.note, color: Colors.blue),
                    title: Text(
                      note.contenu,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(fontSize: 16),
                    ),
                    subtitle: Text(
                      'Créée le ${_formaterDate(note.dateCreation)}',
                      style: const TextStyle(fontSize: 12, color: Colors.grey),
                    ),
                    trailing: IconButton(
                      icon: const Icon(Icons.delete, color: Colors.red),
                      onPressed: () => _confirmerSuppression(note.id!),
                    ),
                    onTap: () async {
                      await Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => PageEditionNote(note: note),
                        ),
                      );
                      _chargerNotes();
                    },
                  ),
                );
              },
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          await Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const PageEditionNote(),
            ),
          );
          _chargerNotes();
        },
        backgroundColor: Colors.blue,
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }

  String _formaterDate(DateTime date) {
    return '${date.day}/${date.month}/${date.year}';
  }
}