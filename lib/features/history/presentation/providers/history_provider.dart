import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:aun_bmi_tracker/features/calculator/data/models/bmi_log_model.dart';
import 'package:aun_bmi_tracker/features/calculator/presentation/providers/bmi_provider.dart';

// ---------------------------------------------------------------------------
// History for a specific profile
// ---------------------------------------------------------------------------

final bmiHistoryProvider =
    FutureProvider.family<List<BmiLogModel>, int>((ref, profileId) async {
  final repo = ref.watch(bmiLogRepositoryProvider);
  return repo.getLogsByProfile(profileId);
});

// ---------------------------------------------------------------------------
// Filter chip selection
// ---------------------------------------------------------------------------

enum HistoryFilter { week, month, threeMonths, all }

final historyFilterProvider = StateProvider<HistoryFilter>(
  (ref) => HistoryFilter.all,
);

// ---------------------------------------------------------------------------
// Filtered history — combines profile history + filter
// ---------------------------------------------------------------------------

final filteredHistoryProvider =
    Provider.family<AsyncValue<List<BmiLogModel>>, int>((ref, profileId) {
  final historyAsync = ref.watch(bmiHistoryProvider(profileId));
  final filter = ref.watch(historyFilterProvider);

  return historyAsync.whenData((logs) {
    if (filter == HistoryFilter.all) return logs;

    final now = DateTime.now();
    final Duration cutoff;

    switch (filter) {
      case HistoryFilter.week:
        cutoff = const Duration(days: 7);
      case HistoryFilter.month:
        cutoff = const Duration(days: 30);
      case HistoryFilter.threeMonths:
        cutoff = const Duration(days: 90);
      case HistoryFilter.all:
        cutoff = Duration.zero;
    }

    final earliest = now.subtract(cutoff);
    return logs.where((l) => l.recordedAt.isAfter(earliest)).toList();
  });
});
