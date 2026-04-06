import 'package:flutter_test/flutter_test.dart';

import 'package:aun_bmi_tracker/features/profiles/data/models/profile_model.dart';

void main() {
  group('ProfileModel', () {
    group('fromMap', () {
      test('creates correct model from complete map', () {
        final map = {
          'id': 1,
          'name': 'Alice',
          'date_of_birth': '1995-03-15T00:00:00.000',
          'gender': 'Female',
          'height_cm': 165.0,
          'is_active': 1,
        };

        final model = ProfileModel.fromMap(map);

        expect(model.id, 1);
        expect(model.name, 'Alice');
        expect(model.dateOfBirth, DateTime(1995, 3, 15));
        expect(model.gender, 'Female');
        expect(model.heightCm, 165.0);
        expect(model.isActive, isTrue);
      });

      test('handles is_active = 0 as false', () {
        final map = {
          'id': 2,
          'name': 'Bob',
          'gender': 'Male',
          'height_cm': 180,
          'is_active': 0,
        };

        final model = ProfileModel.fromMap(map);

        expect(model.isActive, isFalse);
      });

      test('handles is_active = 1 as true', () {
        final map = {
          'id': 3,
          'name': 'Charlie',
          'gender': 'Male',
          'height_cm': 175,
          'is_active': 1,
        };

        final model = ProfileModel.fromMap(map);

        expect(model.isActive, isTrue);
      });

      test('handles null is_active as false', () {
        final map = {
          'id': 4,
          'name': 'Dana',
          'gender': 'Female',
          'height_cm': 160,
          'is_active': null,
        };

        final model = ProfileModel.fromMap(map);

        expect(model.isActive, isFalse);
      });
    });

    group('toMap', () {
      test('produces correct map', () {
        final model = ProfileModel(
          id: 1,
          name: 'Alice',
          dateOfBirth: DateTime(1995, 3, 15),
          gender: 'Female',
          heightCm: 165.0,
          isActive: true,
        );

        final map = model.toMap();

        expect(map['id'], 1);
        expect(map['name'], 'Alice');
        expect(map['date_of_birth'], DateTime(1995, 3, 15).toIso8601String());
        expect(map['gender'], 'Female');
        expect(map['height_cm'], 165.0);
        expect(map['is_active'], 1);
      });

      test('converts isActive true to 1', () {
        final model = ProfileModel(
          name: 'Test',
          gender: 'Male',
          heightCm: 170.0,
          isActive: true,
        );

        expect(model.toMap()['is_active'], 1);
      });

      test('converts isActive false to 0', () {
        final model = ProfileModel(
          name: 'Test',
          gender: 'Male',
          heightCm: 170.0,
          isActive: false,
        );

        expect(model.toMap()['is_active'], 0);
      });

      test('omits id when null', () {
        final model = ProfileModel(
          name: 'Test',
          gender: 'Male',
          heightCm: 170.0,
        );

        expect(model.toMap().containsKey('id'), isFalse);
      });
    });

    group('null optional fields', () {
      test('dateOfBirth defaults to null', () {
        final model = ProfileModel(
          name: 'Test',
          gender: 'Male',
          heightCm: 170.0,
        );

        expect(model.dateOfBirth, isNull);
      });

      test('fromMap with null date_of_birth', () {
        final map = {
          'id': 1,
          'name': 'Test',
          'date_of_birth': null,
          'gender': 'Male',
          'height_cm': 170,
          'is_active': 1,
        };

        final model = ProfileModel.fromMap(map);

        expect(model.dateOfBirth, isNull);
      });

      test('toMap with null dateOfBirth includes null value', () {
        final model = ProfileModel(
          name: 'Test',
          gender: 'Male',
          heightCm: 170.0,
        );

        final map = model.toMap();

        expect(map.containsKey('date_of_birth'), isTrue);
        expect(map['date_of_birth'], isNull);
      });

      test('fromMap with missing gender defaults to empty string', () {
        final map = {
          'id': 1,
          'name': 'Test',
          'height_cm': 170,
          'is_active': 1,
        };

        final model = ProfileModel.fromMap(map);

        expect(model.gender, '');
      });

      test('fromMap with missing height_cm defaults to 0.0', () {
        final map = {
          'id': 1,
          'name': 'Test',
          'gender': 'Male',
          'is_active': 1,
        };

        final model = ProfileModel.fromMap(map);

        expect(model.heightCm, 0.0);
      });
    });

    group('round-trip', () {
      test('toMap then fromMap produces equivalent model', () {
        final original = ProfileModel(
          id: 7,
          name: 'Eve',
          dateOfBirth: DateTime(2000, 1, 1),
          gender: 'Female',
          heightCm: 162.5,
          isActive: true,
        );

        final map = original.toMap();
        final restored = ProfileModel.fromMap(map);

        expect(restored.id, original.id);
        expect(restored.name, original.name);
        expect(restored.dateOfBirth, original.dateOfBirth);
        expect(restored.gender, original.gender);
        expect(restored.heightCm, original.heightCm);
        expect(restored.isActive, original.isActive);
      });
    });
  });
}
