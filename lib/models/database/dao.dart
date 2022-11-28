import 'package:bibliotheca/models/auteur.dart';
import 'package:bibliotheca/models/categorie.dart';
import 'package:bibliotheca/models/livre.dart';
import 'package:bibliotheca/views/liste_categorie.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class Dao {
  //La reférence de notre base de données
  static Database? _database;

  //Un getter qui renvoie l'objet de base de donnée.
  //Si la base n'existe pas _initDB la créé
  static Future<Database> get database async {
    if (_database != null) return _database!;

    _database = await _initDB('bibliotheca.db');
    return _database!;
  }

  //_initDB initialise notre base de données.
  static Future<Database> _initDB(String filePath) async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, filePath);

    //openDatabase ouvre notre base de données située à l'emplacement "path"
    //si la base n'existe pas openDatabase exécute _createDB
    return await openDatabase(path, version: 1, onCreate: _createDB);
  }

  //_createDB est la méthode qui s'occupe de la définition des tables de notre base de données
  //_createDB exécute les transactions de base de données qui pour créer les tables
  static Future _createDB(Database db, int version) async {
    await db.execute('''
      CREATE TABLE auteur (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        nom VARCHAR(255) NOT NULL,
        prenoms VARCHAR(255) NOT NULL,
        email VARCHAR(255)
      )
      ''');
    await db.execute('''
      CREATE TABLE categorie (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        libelle VARCHAR(255) NOT NULL
      )
      ''');
    await db.execute('''
      CREATE TABLE livre (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        libelle VARCHAR(255) NOT NULL,
        image VARCHAR,
        nb_page INTEGER,
        description TEXT,
        auteur_id INTEGER NOT NULL,
        categorie_id INTEGER NOT NULL
      )
      ''');
  }

  //Gestion de la table catégorie
  static Future<List<Categorie>> listeCategorie() async {
    final db = await database;

    final maps = await db.query(
      "categorie",
      columns: ["*"],
    );

    if (maps.isNotEmpty) {
      return maps.map((e) => Categorie.fromJson(e)).toList();
    } else {
      return [];
    }
  }

  static Future<int> updateCategorie(Categorie categorie) async {
    final db = await database;
    return db.update(
      "categorie",
      categorie.toJson()..remove("id"),
      where: 'id = ?',
      whereArgs: [categorie.id],
    );
  }

  static Future<Categorie> createCategorie(Categorie categorie) async {
    final db = await database;
    final id = await db.insert("categorie", categorie.toJson());
    categorie.id = id;
    return categorie;
  }

  static Future<int> deleteCategorie(int id) async {
    final db = await database;
    return await db.delete(
      "categorie",
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  //Gestion de la table auteur
  static Future<List<Auteur>> listeAuteur() async {
    final db = await database;

    final maps = await db.query(
      "auteur",
      columns: ["*"],
    );

    if (maps.isNotEmpty) {
      return maps.map((e) => Auteur.fromJson(e)).toList();
    } else {
      return [];
    }
  }

  static Future<int> updateAuteur(Auteur auteur) async {
    final db = await database;
    return db.update(
      "auteur",
      auteur.toJson()..remove("id"),
      where: 'id = ?',
      whereArgs: [auteur.id],
    );
  }

  static Future<Auteur> createAuteur(Auteur auteur) async {
    final db = await database;
    final id = await db.insert("auteur", auteur.toJson());
    auteur.id = id;
    return auteur;
  }

  static Future<int> deleteAuteur(int id) async {
    final db = await database;
    return await db.delete(
      "auteur",
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  //Gestion de la table livre
  static Future<List<Livre>> listeLivre() async {
    final db = await database;

    final maps = await db.query(
      "livre",
      columns: ["*"],
    );

    if (maps.isNotEmpty) {
      return maps.map((e) => Livre.fromJson(e)).toList();
    } else {
      return [];
    }
  }

  static Future<Livre?> livreParId({required int id}) async {
    final db = await database;

    final maps = await db.query(
      "livre",
      columns: ["*"],
      where: "id = ?",
      whereArgs: [id],
    );

    if (maps.isNotEmpty) {
      return Livre.fromJson(maps.first);
    } else {
      return null;
    }
  }

  static Future<int> updateLivre(Livre livre) async {
    final db = await database;
    return db.update(
      "livre",
      livre.toJson()..remove("id"),
      where: 'id = ?',
      whereArgs: [livre.id],
    );
  }

  static Future<Livre> createLivre(Livre livre) async {
    final db = await database;
    final id = await db.insert("livre", livre.toJson());
    livre.id = id;
    return livre;
  }

  static Future<int> deleteLivre(int id) async {
    final db = await database;
    return await db.delete(
      "livre",
      where: 'id = ?',
      whereArgs: [id],
    );
  }
}
