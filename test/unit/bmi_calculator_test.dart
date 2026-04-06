import 'package:flutter_test/flutter_test.dart';

import 'package:aun_bmi_tracker/features/calculator/domain/bmi_calculator.dart';
import 'package:aun_bmi_tracker/features/calculator/domain/entities/bmi_category.dart';

void main() {
  group('BmiCalculator.calculate', () {
    group('BMI formula accuracy', () {
      test('70kg / 170cm produces BMI ~24.22', () {
        final result = BmiCalculator.calculate(
          weightKg: 70,
          heightCm: 170,
          ageYears: 25,
          gender: 'Male',
        );

        expect(result.bmi, closeTo(24.22, 0.01));
      });

      test('90kg / 180cm produces BMI ~27.78', () {
        final result = BmiCalculator.calculate(
          weightKg: 90,
          heightCm: 180,
          ageYears: 30,
          gender: 'Male',
        );

        expect(result.bmi, closeTo(27.78, 0.01));
      });

      test('50kg / 160cm produces BMI ~19.53', () {
        final result = BmiCalculator.calculate(
          weightKg: 50,
          heightCm: 160,
          ageYears: 22,
          gender: 'Female',
        );

        expect(result.bmi, closeTo(19.53, 0.01));
      });

      test('45kg / 155cm produces BMI ~18.73', () {
        final result = BmiCalculator.calculate(
          weightKg: 45,
          heightCm: 155,
          ageYears: 20,
          gender: 'Female',
        );

        expect(result.bmi, closeTo(18.73, 0.01));
      });

      test('120kg / 175cm produces BMI ~39.18', () {
        final result = BmiCalculator.calculate(
          weightKg: 120,
          heightCm: 175,
          ageYears: 40,
          gender: 'Male',
        );

        expect(result.bmi, closeTo(39.18, 0.01));
      });
    });

    group('ideal weight range calculation', () {
      test('ideal weight range for 170cm uses BMI 18.5–24.9', () {
        final result = BmiCalculator.calculate(
          weightKg: 70,
          heightCm: 170,
          ageYears: 25,
          gender: 'Male',
        );

        final heightM = 1.70;
        final expectedMin = 18.5 * heightM * heightM;
        final expectedMax = 24.9 * heightM * heightM;

        expect(result.idealWeightMin, closeTo(expectedMin, 0.01));
        expect(result.idealWeightMax, closeTo(expectedMax, 0.01));
      });

      test('ideal weight range for 180cm', () {
        final result = BmiCalculator.calculate(
          weightKg: 80,
          heightCm: 180,
          ageYears: 30,
          gender: 'Male',
        );

        final heightM = 1.80;
        final expectedMin = 18.5 * heightM * heightM;
        final expectedMax = 24.9 * heightM * heightM;

        expect(result.idealWeightMin, closeTo(expectedMin, 0.01));
        expect(result.idealWeightMax, closeTo(expectedMax, 0.01));
      });
    });

    group('result includes correct input values', () {
      test('result preserves weight, height, age, gender', () {
        final result = BmiCalculator.calculate(
          weightKg: 65,
          heightCm: 165,
          ageYears: 28,
          gender: 'Female',
        );

        expect(result.weightKg, 65);
        expect(result.heightCm, 165);
        expect(result.ageYears, 28);
        expect(result.gender, 'Female');
      });

      test('result has a recordedAt timestamp', () {
        final before = DateTime.now();
        final result = BmiCalculator.calculate(
          weightKg: 70,
          heightCm: 170,
          ageYears: 25,
          gender: 'Male',
        );
        final after = DateTime.now();

        expect(
          result.recordedAt.isAfter(before.subtract(const Duration(seconds: 1))),
          isTrue,
        );
        expect(
          result.recordedAt.isBefore(after.add(const Duration(seconds: 1))),
          isTrue,
        );
      });
    });

    group('correct category assignment', () {
      test('underweight BMI returns underweight category', () {
        final result = BmiCalculator.calculate(
          weightKg: 40,
          heightCm: 170,
          ageYears: 25,
          gender: 'Male',
        );

        expect(result.category, BmiCategory.underweight);
      });

      test('normal BMI returns normal category', () {
        final result = BmiCalculator.calculate(
          weightKg: 70,
          heightCm: 170,
          ageYears: 25,
          gender: 'Male',
        );

        expect(result.category, BmiCategory.normal);
      });

      test('overweight BMI returns overweight category', () {
        final result = BmiCalculator.calculate(
          weightKg: 90,
          heightCm: 180,
          ageYears: 30,
          gender: 'Male',
        );

        expect(result.category, BmiCategory.overweight);
      });

      test('obese BMI returns obese category', () {
        final result = BmiCalculator.calculate(
          weightKg: 120,
          heightCm: 175,
          ageYears: 40,
          gender: 'Male',
        );

        expect(result.category, BmiCategory.obese);
      });
    });
  });
}
