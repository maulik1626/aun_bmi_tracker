import 'package:aun_bmi_tracker/features/calculator/domain/entities/bmi_category.dart';

class BmiResult {
  final double bmi;
  final BmiCategory category;
  final double idealWeightMin;
  final double idealWeightMax;
  final double weightKg;
  final double heightCm;
  final int ageYears;
  final String gender;
  final DateTime recordedAt;

  const BmiResult({
    required this.bmi,
    required this.category,
    required this.idealWeightMin,
    required this.idealWeightMax,
    required this.weightKg,
    required this.heightCm,
    required this.ageYears,
    required this.gender,
    required this.recordedAt,
  });

  @override
  String toString() {
    return 'BmiResult(bmi: ${bmi.toStringAsFixed(1)}, category: $category, '
        'weight: $weightKg kg, height: $heightCm cm, age: $ageYears, '
        'gender: $gender, recordedAt: $recordedAt)';
  }
}
