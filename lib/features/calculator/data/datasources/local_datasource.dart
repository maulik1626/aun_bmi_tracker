import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';

class LocalDatasource {
  static final LocalDatasource _instance = LocalDatasource._internal();
  static Database? _database;

  LocalDatasource._internal();

  factory LocalDatasource() => _instance;

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    final directory = await getApplicationDocumentsDirectory();
    final path = join(directory.path, 'aun_bmi_tracker.db');

    return await openDatabase(
      path,
      version: 1,
      onCreate: _onCreate,
    );
  }

  Future<void> _onCreate(Database db, int version) async {
    await db.execute('''
      CREATE TABLE profiles (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        name TEXT NOT NULL,
        date_of_birth TEXT,
        gender TEXT,
        height_cm REAL,
        is_active INTEGER DEFAULT 1
      )
    ''');

    await db.execute('''
      CREATE TABLE bmi_log (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        profile_id INTEGER,
        weight_kg REAL NOT NULL,
        height_cm REAL NOT NULL,
        bmi REAL NOT NULL,
        category TEXT NOT NULL,
        recorded_at TEXT,
        FOREIGN KEY (profile_id) REFERENCES profiles(id)
      )
    ''');
  }
}
