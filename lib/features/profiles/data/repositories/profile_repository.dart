import 'package:aun_bmi_tracker/features/calculator/data/datasources/local_datasource.dart';
import 'package:aun_bmi_tracker/features/profiles/data/models/profile_model.dart';

class ProfileRepository {
  final LocalDatasource _datasource = LocalDatasource();

  Future<int> insertProfile(ProfileModel profile) async {
    final db = await _datasource.database;
    return await db.insert('profiles', profile.toMap());
  }

  Future<List<ProfileModel>> getAllProfiles() async {
    final db = await _datasource.database;
    final maps = await db.query('profiles');
    return maps.map((map) => ProfileModel.fromMap(map)).toList();
  }

  Future<int> updateProfile(ProfileModel profile) async {
    final db = await _datasource.database;
    return await db.update(
      'profiles',
      profile.toMap(),
      where: 'id = ?',
      whereArgs: [profile.id],
    );
  }

  Future<int> deleteProfile(int id) async {
    final db = await _datasource.database;
    return await db.delete(
      'profiles',
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  Future<void> setActiveProfile(int id) async {
    final db = await _datasource.database;
    await db.transaction((txn) async {
      // Deactivate all profiles
      await txn.update(
        'profiles',
        {'is_active': 0},
      );
      // Activate the selected profile
      await txn.update(
        'profiles',
        {'is_active': 1},
        where: 'id = ?',
        whereArgs: [id],
      );
    });
  }

  Future<ProfileModel?> getActiveProfile() async {
    final db = await _datasource.database;
    final maps = await db.query(
      'profiles',
      where: 'is_active = ?',
      whereArgs: [1],
      limit: 1,
    );
    if (maps.isEmpty) return null;
    return ProfileModel.fromMap(maps.first);
  }
}
