import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DatabaseHelper {
  static final DatabaseHelper instance = DatabaseHelper._init();
  static Database? _database;

  DatabaseHelper._init();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB('invoices.db');
    return _database!;
  }

  Future<Database> _initDB(String filePath) async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, filePath);

    return await openDatabase(path, version: 1, onCreate: _createDB);
  }

  Future<void> _createDB(Database db, int version) async {
    await db.execute('''
      CREATE TABLE invoices (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        client_name TEXT NOT NULL,
        amount REAL NOT NULL,
        status TEXT CHECK(status IN ('Paid', 'Unpaid')) NOT NULL DEFAULT 'Unpaid',
        due_date TEXT NOT NULL,
        created_at TEXT DEFAULT CURRENT_TIMESTAMP
      )
    ''');
  }
}
