import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:aun_bmi_tracker/features/calculator/data/models/bmi_log_model.dart';
import 'package:aun_bmi_tracker/features/calculator/data/repositories/bmi_log_repository.dart';
import 'package:aun_bmi_tracker/features/calculator/domain/bmi_calculator.dart';
import 'package:aun_bmi_tracker/features/calculator/domain/entities/bmi_result.dart';
import 'package:aun_bmi_tracker/features/profiles/presentation/providers/profile_provider.dart';

// ---------------------------------------------------------------------------
// Repository provider
// ---------------------------------------------------------------------------

final bmiLogRepositoryProvider = Provider<BmiLogRepository>((ref) {
  return BmiLogRepository();
});

// ---------------------------------------------------------------------------
// Unit toggle (true = metric, false = imperial)
// ---------------------------------------------------------------------------

final isMetricProvider = StateProvider<bool>((ref) => true);

// ---------------------------------------------------------------------------
// BMI Notifier
// ---------------------------------------------------------------------------

class BmiNotifier extends StateNotifier<AsyncValue<BmiResult?>> {
  BmiNotifier(this._ref) : super(const AsyncData(null));

  final Ref _ref;

  Future<void> calculate({
    required double weight,
    required double height,
    required int age,
    required String gender,
  }) async {
    state = const AsyncLoading();

    try {
      final isMetric = _ref.read(isMetricProvider);

      // Convert imperial to metric if needed.
      final weightKg = isMetric ? weight : weight * 0.453592;
      final heightCm = isMetric ? height : height * 2.54;

      final result = BmiCalculator.calculate(
        weightKg: weightKg,
        heightCm: heightCm,
        ageYears: age,
        gender: gender,
      );

      state = AsyncData(result);
    } catch (e, st) {
      state = AsyncError(e, st);
    }
  }

  Future<void> saveCurrentResult() async {
    final result = state.valueOrNull;
    if (result == null) return;

    try {
      final repo = _ref.read(bmiLogRepositoryProvider);
      final activeProfile = _ref.read(activeProfileProvider);
      final profileId = activeProfile?.id ?? 1;

      final log = BmiLogModel(
        profileId: profileId,
        weightKg: result.weightKg,
        heightCm: result.heightCm,
        bmi: result.bmi,
        category: result.category.name,
        recordedAt: result.recordedAt,
      );

      await repo.insertLog(log);
    } catch (_) {
      // Silently fail — the result is still displayed.
    }
  }

  void reset() {
    state = const AsyncData(null);
  }
}

final bmiNotifierProvider =
    StateNotifierProvider<BmiNotifier, AsyncValue<BmiResult?>>((ref) {
  return BmiNotifier(ref);
});
