import 'package:flutter_test/flutter_test.dart';

import 'package:aun_bmi_tracker/features/calculator/data/models/bmi_log_model.dart';

void main() {
  final testDate = DateTime(2025, 6, 15, 10, 30, 0);

  group('BmiLogModel', () {
    group('fromMap', () {
      test('creates correct model from complete map', () {
        final map = {
          'id': 1,
          'profile_id': 2,
          'weight_kg': 70.5,
          'height_cm': 175.0,
          'bmi': 23.02,
          'category': 'normal',
          'recorded_at': testDate.toIso8601String(),
        };

        final model = BmiLogModel.fromMap(map);

        expect(model.id, 1);
        expect(model.profileId, 2);
        expect(model.weightKg, 70.5);
        expect(model.heightCm, 175.0);
        expect(model.bmi, 23.02);
        expect(model.category, 'normal');
        expect(model.recordedAt, testDate);
      });

      test('creates model with null id', () {
        final map = {
          'id': null,
          'profile_id': 1,
          'weight_kg': 60,
          'height_cm': 165,
          'bmi': 22.04,
          'category': 'normal',
          'recorded_at': testDate.toIso8601String(),
        };

        final model = BmiLogModel.fromMap(map);

        expect(model.id, isNull);
        expect(model.profileId, 1);
      });

      test('handles integer weight and height values', () {
        final map = {
          'id': 1,
          'profile_id': 1,
          'weight_kg': 70,
          'height_cm': 175,
          'bmi': 23,
          'category': 'normal',
          'recorded_at': testDate.toIso8601String(),
        };

        final model = BmiLogModel.fromMap(map);

        expect(model.weightKg, 70.0);
        expect(model.heightCm, 175.0);
        expect(model.bmi, 23.0);
      });
    });

    group('toMap', () {
      test('produces correct map with id', () {
        final model = BmiLogModel(
          id: 5,
          profileId: 3,
          weightKg: 80.0,
          heightCm: 180.0,
          bmi: 24.69,
          category: 'normal',
          recordedAt: testDate,
        );

        final map = model.toMap();

        expect(map['id'], 5);
        expect(map['profile_id'], 3);
        expect(map['weight_kg'], 80.0);
        expect(map['height_cm'], 180.0);
        expect(map['bmi'], 24.69);
        expect(map['category'], 'normal');
        expect(map['recorded_at'], testDate.toIso8601String());
      });

      test('omits id when null', () {
        final model = BmiLogModel(
          profileId: 1,
          weightKg: 70.0,
          heightCm: 170.0,
          bmi: 24.22,
          category: 'normal',
          recordedAt: testDate,
        );

        final map = model.toMap();

        expect(map.containsKey('id'), isFalse);
      });
    });

    group('round-trip', () {
      test('toMap then fromMap produces equivalent model', () {
        final original = BmiLogModel(
          id: 10,
          profileId: 2,
          weightKg: 85.5,
          heightCm: 178.0,
          bmi: 26.97,
          category: 'overweight',
          recordedAt: testDate,
        );

        final map = original.toMap();
        final restored = BmiLogModel.fromMap(map);

        expect(restored.id, original.id);
        expect(restored.profileId, original.profileId);
        expect(restored.weightKg, original.weightKg);
        expect(restored.heightCm, original.heightCm);
        expect(restored.bmi, original.bmi);
        expect(restored.category, original.category);
        expect(restored.recordedAt, original.recordedAt);
      });

      test('round-trip without id', () {
        final original = BmiLogModel(
          profileId: 1,
          weightKg: 55.0,
          heightCm: 160.0,
          bmi: 21.48,
          category: 'normal',
          recordedAt: testDate,
        );

        final map = original.toMap();
        // fromMap expects id key; when absent it will be null
        final restored = BmiLogModel.fromMap({...map, 'id': null});

        expect(restored.id, isNull);
        expect(restored.profileId, original.profileId);
        expect(restored.weightKg, original.weightKg);
        expect(restored.heightCm, original.heightCm);
        expect(restored.bmi, original.bmi);
        expect(restored.category, original.category);
        expect(restored.recordedAt, original.recordedAt);
      });
    });
  });
}
