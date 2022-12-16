import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'dart:io' as io;

class DBHelper {
  static Database? _db;

  Future<Database> get db async {
    if (_db != null) {
      return _db!;
    }
    _db = await initDatabase();
    return _db!;
  }

  initDatabase() async {
    io.Directory documentDirectory = await getApplicationDocumentsDirectory();
    String path = join(documentDirectory.path, 'ussd.db');
    var db = openDatabase(path, version: 1, onCreate: _onCreate);
    return db;
  }

  _onCreate(Database db, int version) {
    String sql =
        // 'CREATE TABLE ussd (id INTEGER PRIMARY KEY, libeler TEXT, codeussd TEXT, simchoice INTEGER)';
        'CREATE TABLE ussd (id INTEGER PRIMARY KEY, numeros INTEGER, montant INTEGER, status INTEGER)';
    db.execute(sql);
  }
}
