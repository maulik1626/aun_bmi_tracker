import 'package:aun_bmi_tracker/features/calculator/data/datasources/local_datasource.dart';
import 'package:aun_bmi_tracker/features/calculator/data/models/bmi_log_model.dart';

class BmiLogRepository {
  final LocalDatasource _datasource = LocalDatasource();

  Future<int> insertLog(BmiLogModel log) async {
    final db = await _datasource.database;
    return await db.insert('bmi_log', log.toMap());
  }

  Future<List<BmiLogModel>> getLogsByProfile(int profileId) async {
    final db = await _datasource.database;
    final maps = await db.query(
      'bmi_log',
      where: 'profile_id = ?',
      whereArgs: [profileId],
      orderBy: 'recorded_at DESC',
    );
    return maps.map((map) => BmiLogModel.fromMap(map)).toList();
  }

  Future<int> deleteLog(int id) async {
    final db = await _datasource.database;
    return await db.delete(
      'bmi_log',
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  Future<List<BmiLogModel>> getAllLogs() async {
    final db = await _datasource.database;
    final maps = await db.query(
      'bmi_log',
      orderBy: 'recorded_at DESC',
    );
    return maps.map((map) => BmiLogModel.fromMap(map)).toList();
  }
}
