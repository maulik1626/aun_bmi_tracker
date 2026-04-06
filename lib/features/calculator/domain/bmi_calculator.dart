import 'package:aun_bmi_tracker/features/calculator/domain/entities/bmi_category.dart';
import 'package:aun_bmi_tracker/features/calculator/domain/entities/bmi_result.dart';

class BmiCalculator {
  static BmiResult calculate({
    required double weightKg,
    required double heightCm,
    required int ageYears,
    required String gender,
  }) {
    final heightM = heightCm / 100;
    final bmi = weightKg / (heightM * heightM);

    return BmiResult(
      bmi: bmi,
      category: _classify(bmi, ageYears),
      idealWeightMin: 18.5 * heightM * heightM,
      idealWeightMax: 24.9 * heightM * heightM,
      weightKg: weightKg,
      heightCm: heightCm,
      ageYears: ageYears,
      gender: gender,
      recordedAt: DateTime.now(),
    );
  }

  static BmiCategory _classify(double bmi, int age) {
    if (bmi < 18.5) return BmiCategory.underweight;
    if (bmi < 25.0) return BmiCategory.normal;
    if (bmi < 30.0) return BmiCategory.overweight;
    return BmiCategory.obese;
  }
}
