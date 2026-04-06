import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart' as p;

// ════════════════════════════════════════════════════════════════
// Core Riverpod providers — database & shared preferences.
// ════════════════════════════════════════════════════════════════

/// Provides the singleton [SharedPreferences] instance.
///
/// Must be overridden at app startup:
/// ```dart
/// final prefs = await SharedPreferences.getInstance();
/// runApp(
///   ProviderScope(
///     overrides: [sharedPrefsProvider.overrideWithValue(prefs)],
///     child: const MyApp(),
///   ),
/// );
/// ```
final sharedPrefsProvider = Provider<SharedPreferences>((ref) {
  throw UnimplementedError(
    'sharedPrefsProvider must be overridden with a real SharedPreferences '
    'instance before use. Override it in ProviderScope.',
  );
});

/// Database name constant.
const String _dbName = 'aun_bmi_tracker.db';

/// Database version — increment when schema changes.
const int _dbVersion = 1;

/// Provides the singleton [Database] instance.
///
/// Must be overridden at app startup:
/// ```dart
/// final db = await openDatabase(...);
/// runApp(
///   ProviderScope(
///     overrides: [databaseProvider.overrideWithValue(db)],
///     child: const MyApp(),
///   ),
/// );
/// ```
final databaseProvider = Provider<Database>((ref) {
  throw UnimplementedError(
    'databaseProvider must be overridden with an open Database '
    'instance before use. Override it in ProviderScope.',
  );
});

/// Helper that opens (or creates) the app database.
/// Call this once during app initialization before building the widget tree.
Future<Database> openAppDatabase() async {
  final dbPath = await getDatabasesPath();
  final path = p.join(dbPath, _dbName);

  return openDatabase(
    path,
    version: _dbVersion,
    onCreate: (db, version) async {
      // ── BMI records table ──
      await db.execute('''
        CREATE TABLE bmi_records (
          id INTEGER PRIMARY KEY AUTOINCREMENT,
          profile_id INTEGER,
          height_cm REAL NOT NULL,
          weight_kg REAL NOT NULL,
          bmi REAL NOT NULL,
          category TEXT NOT NULL,
          date TEXT NOT NULL,
          note TEXT,
          created_at TEXT NOT NULL DEFAULT (datetime('now'))
        )
      ''');

      // ── Profiles table ──
      await db.execute('''
        CREATE TABLE profiles (
          id INTEGER PRIMARY KEY AUTOINCREMENT,
          name TEXT NOT NULL,
          age INTEGER,
          gender TEXT,
          avatar_index INTEGER DEFAULT 0,
          is_default INTEGER DEFAULT 0,
          created_at TEXT NOT NULL DEFAULT (datetime('now'))
        )
      ''');
    },
    onUpgrade: (db, oldVersion, newVersion) async {
      // Future migrations go here.
    },
  );
}

/// Provider that indicates whether the app has finished initialization.
final appInitializedProvider = StateProvider<bool>((ref) => false);
