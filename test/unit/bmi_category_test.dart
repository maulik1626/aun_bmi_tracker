import 'package:flutter_test/flutter_test.dart';

import 'package:aun_bmi_tracker/features/calculator/domain/bmi_calculator.dart';
import 'package:aun_bmi_tracker/features/calculator/domain/entities/bmi_category.dart';

/// Helper that calculates BMI from a target bmi value by reverse-engineering
/// weight for a fixed height of 100cm (1m), so weight == bmi.
BmiCategory _classifyBmi(double targetBmi, {int age = 25}) {
  // With height = 100cm (1m), BMI = weight / 1^2 = weight.
  final result = BmiCalculator.calculate(
    weightKg: targetBmi,
    heightCm: 100,
    ageYears: age,
    gender: 'Male',
  );
  return result.category;
}

void main() {
  group('BMI category classification', () {
    group('boundary values', () {
      test('BMI 18.49 is underweight', () {
        expect(_classifyBmi(18.49), BmiCategory.underweight);
      });

      test('BMI 18.5 is normal', () {
        expect(_classifyBmi(18.5), BmiCategory.normal);
      });

      test('BMI 24.99 is normal', () {
        expect(_classifyBmi(24.99), BmiCategory.normal);
      });

      test('BMI 25.0 is overweight', () {
        expect(_classifyBmi(25.0), BmiCategory.overweight);
      });

      test('BMI 29.99 is overweight', () {
        expect(_classifyBmi(29.99), BmiCategory.overweight);
      });

      test('BMI 30.0 is obese', () {
        expect(_classifyBmi(30.0), BmiCategory.obese);
      });
    });

    group('extreme values', () {
      test('BMI 10 is underweight', () {
        expect(_classifyBmi(10), BmiCategory.underweight);
      });

      test('BMI 50 is obese', () {
        expect(_classifyBmi(50), BmiCategory.obese);
      });

      test('BMI 15 is underweight', () {
        expect(_classifyBmi(15), BmiCategory.underweight);
      });

      test('BMI 40 is obese', () {
        expect(_classifyBmi(40), BmiCategory.obese);
      });
    });

    group('classification for different ages', () {
      test('BMI 22 is normal for age 18', () {
        expect(_classifyBmi(22, age: 18), BmiCategory.normal);
      });

      test('BMI 22 is normal for age 50', () {
        expect(_classifyBmi(22, age: 50), BmiCategory.normal);
      });

      test('BMI 22 is normal for age 80', () {
        expect(_classifyBmi(22, age: 80), BmiCategory.normal);
      });

      test('BMI 17 is underweight for age 30', () {
        expect(_classifyBmi(17, age: 30), BmiCategory.underweight);
      });

      test('BMI 27 is overweight for age 60', () {
        expect(_classifyBmi(27, age: 60), BmiCategory.overweight);
      });

      test('BMI 35 is obese for age 45', () {
        expect(_classifyBmi(35, age: 45), BmiCategory.obese);
      });
    });
  });
}
