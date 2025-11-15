import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class Note {
  int? id;
  String contenu;
  DateTime dateCreation;

  Note({
    this.id,
    required this.contenu,
    DateTime? dateCreation,
  }) : dateCreation = dateCreation ?? DateTime.now();

  Map<String, dynamic> versMap() {
    return {
      'id': id,
      'contenu': contenu,
      'dateCreation': dateCreation.millisecondsSinceEpoch,
    };
  }

  factory Note.depuisMap(Map<String, dynamic> map) {
    return Note(
      id: map['id'],
      contenu: map['contenu'],
      dateCreation: DateTime.fromMillisecondsSinceEpoch(map['dateCreation']),
    );
  }
}

class Utilisateur {
  int? id;
  String nomUtilisateur;
  String motDePasse;

  Utilisateur({
    this.id,
    required this.nomUtilisateur,
    required this.motDePasse,
  });

  Map<String, dynamic> versMap() {
    return {
      'id': id,
      'nomUtilisateur': nomUtilisateur,
      'motDePasse': motDePasse,
    };
  }

  factory Utilisateur.depuisMap(Map<String, dynamic> map) {
    return Utilisateur(
      id: map['id'],
      nomUtilisateur: map['nomUtilisateur'],
      motDePasse: map['motDePasse'],
    );
  }
}

class GestionBaseDonnees {
  static Database? _baseDeDonnees;

  Future<Database> get baseDeDonnees async {
    if (_baseDeDonnees != null) return _baseDeDonnees!;
    _baseDeDonnees = await _initialiserBaseDeDonnees();
    return _baseDeDonnees!;
  }

  Future<Database> _initialiserBaseDeDonnees() async {
    final chemin = join(await getDatabasesPath(), 'projetfinal.db');
    return await openDatabase(
      chemin,
      version: 2,
      onCreate: (db, version) async {
        await db.execute('''
          CREATE TABLE notes(
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            contenu TEXT NOT NULL,
            dateCreation INTEGER NOT NULL
          )
        ''');
        await _creerTableUtilisateurs(db);
        
        // Ajouter un utilisateur par défaut
        await db.insert('utilisateurs', {
          'nomUtilisateur': 'admin',
          'motDePasse': 'password'
        });
      },
      onUpgrade: (db, ancienneVersion, nouvelleVersion) async {
        if (ancienneVersion < 2) {
          await _creerTableUtilisateurs(db);
        }
      },
    );
  }

  Future<void> _creerTableUtilisateurs(Database db) async {
    await db.execute('''
      CREATE TABLE IF NOT EXISTS utilisateurs(
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        nomUtilisateur TEXT UNIQUE NOT NULL,
        motDePasse TEXT NOT NULL
      )
    ''');
  }

  Future<int> insererNote(Note note) async {
    final db = await baseDeDonnees;
    return await db.insert('notes', note.versMap());
  }

  Future<List<Note>> obtenirNotes() async {
    final db = await baseDeDonnees;
    final List<Map<String, dynamic>> maps = await db.query(
      'notes',
      orderBy: 'dateCreation DESC',
    );
    return List.generate(maps.length, (i) => Note.depuisMap(maps[i]));
  }

  Future<int> mettreAJourNote(Note note) async {
    final db = await baseDeDonnees;
    return await db.update(
      'notes',
      note.versMap(),
      where: 'id = ?',
      whereArgs: [note.id],
    );
  }

  Future<int> supprimerNote(int id) async {
    final db = await baseDeDonnees;
    return await db.delete(
      'notes',
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  Future<bool> utilisateurExiste(String nomUtilisateur) async {
    final db = await baseDeDonnees;
    final List<Map<String, dynamic>> resultat = await db.query(
      'utilisateurs',
      where: 'nomUtilisateur = ?',
      whereArgs: [nomUtilisateur],
    );
    return resultat.isNotEmpty;
  }

  Future<int> insererUtilisateur(Utilisateur utilisateur) async {
    final db = await baseDeDonnees;
    return await db.insert('utilisateurs', utilisateur.versMap());
  }

  Future<bool> validerUtilisateur(String nomUtilisateur, String motDePasse) async {
    final db = await baseDeDonnees;
    final List<Map<String, dynamic>> resultat = await db.query(
      'utilisateurs',
      where: 'nomUtilisateur = ? AND motDePasse = ?',
      whereArgs: [nomUtilisateur, motDePasse],
    );
    return resultat.isNotEmpty;
  }
}