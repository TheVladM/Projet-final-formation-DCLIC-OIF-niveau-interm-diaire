import 'package:flutter/material.dart';
import 'gestion_base_donnees.dart';

class PageEditionNote extends StatefulWidget {
  final Note? note;

  const PageEditionNote({super.key, this.note});

  @override
  _EtatPageEditionNote createState() => _EtatPageEditionNote();
}

class _EtatPageEditionNote extends State<PageEditionNote> {
  final TextEditingController _controlleurContenu = TextEditingController();
  final GestionBaseDonnees _gestionBD = GestionBaseDonnees();

  @override
  void initState() {
    super.initState();
    if (widget.note != null) {
      _controlleurContenu.text = widget.note!.contenu;
    }
  }

  void _sauvegarderNote() async {
    final contenu = _controlleurContenu.text.trim();
    if (contenu.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Veuillez saisir une note')),
      );
      return;
    }

    if (widget.note == null) {
      await _gestionBD.insererNote(Note(contenu: contenu));
    } else {
      await _gestionBD.mettreAJourNote(
        Note(id: widget.note!.id, contenu: contenu),
      );
    }

    if (mounted) {
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.note == null ? 'Nouvelle Note' : 'Modifier la Note'),
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            onPressed: _sauvegarderNote,
            icon: const Icon(Icons.save),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _controlleurContenu,
              maxLines: null,
              decoration: const InputDecoration(
                hintText: 'Entrez votre note ici...',
                border: InputBorder.none,
                hintStyle: TextStyle(fontSize: 16),
              ),
              style: const TextStyle(fontSize: 16),
            ),
          ],
        ),
      ),
    );
  }
}