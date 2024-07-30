import 'package:sqflite/sqflite.dart' as sqlite;
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart'; // Importa path_provider

import '../planetas/planetas.dart';

class DB {
  // Conexión a la base de datos y creación de tablas
  static Future<sqlite.Database> db() async {
    final directory = await getApplicationDocumentsDirectory(); // Usa path_provider para obtener el directorio
    final String path = join(directory.path, "solarsystem.db");

    return sqlite.openDatabase(
      path,
      version: 1,
      singleInstance: true,
      onCreate: (db, version) async {
        await create(db);
      },
    );
  }

  static Future<void> create(sqlite.Database db) async {
    const String sql = """
      CREATE TABLE planeta (
      id INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL,
      nombre TEXT NOT NULL,
      distanciaSol REAL NOT NULL,
      radio REAL NOT NULL,
      createdAt TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP
      )
    """;
    await db.execute(sql);
  }

  static Future<List<Planetas>> consulta() async {
    final sqlite.Database db = await DB.db();
    final List<Map<String, dynamic>> query = await db.query("planeta");
    List<Planetas> planetario = query.map((e) {
      return Planetas.deMapa(e);
    }).toList();
    return planetario;
  }

  static Future<int> insertar(Planetas planeta) async {
    final sqlite.Database db = await DB.db();
    final int id = await db.insert(
      "planeta",
      planeta.mapeador(),
      conflictAlgorithm: sqlite.ConflictAlgorithm.replace,
    );
    return id;
  }

  static Future<int> actualizar(Planetas planeta) async {
    final sqlite.Database db = await DB.db();
    final int id = await db.update(
      "planeta",
      planeta.mapeador(),
      where: "id = ?",
      whereArgs: [planeta.id],
    );
    return id;
  }

  static Future<void> borrar(int id) async {
    final sqlite.Database db = await DB.db();
    await db.delete("planeta", where: "id = ?", whereArgs: [id]);
  }
}
