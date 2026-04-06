import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:aun_bmi_tracker/features/profiles/data/models/profile_model.dart';
import 'package:aun_bmi_tracker/features/profiles/data/repositories/profile_repository.dart';

// ---------------------------------------------------------------------------
// Repository provider
// ---------------------------------------------------------------------------

final profileRepositoryProvider = Provider<ProfileRepository>((ref) {
  return ProfileRepository();
});

// ---------------------------------------------------------------------------
// Profiles list notifier
// ---------------------------------------------------------------------------

class ProfilesNotifier extends StateNotifier<AsyncValue<List<ProfileModel>>> {
  ProfilesNotifier(this._repo) : super(const AsyncLoading()) {
    loadProfiles();
  }

  final ProfileRepository _repo;

  Future<void> loadProfiles() async {
    state = const AsyncLoading();
    try {
      final profiles = await _repo.getAllProfiles();

      // If no profiles exist, create a default one.
      if (profiles.isEmpty) {
        const defaultProfile = ProfileModel(
          name: 'Default',
          gender: 'Male',
          heightCm: 170,
          isActive: true,
        );
        await _repo.insertProfile(defaultProfile);
        final updatedProfiles = await _repo.getAllProfiles();
        state = AsyncData(updatedProfiles);
      } else {
        state = AsyncData(profiles);
      }
    } catch (e, st) {
      state = AsyncError(e, st);
    }
  }

  Future<void> addProfile(ProfileModel profile) async {
    try {
      await _repo.insertProfile(profile);
      await loadProfiles();
    } catch (e, st) {
      state = AsyncError(e, st);
    }
  }

  Future<void> updateProfile(ProfileModel profile) async {
    try {
      await _repo.updateProfile(profile);
      await loadProfiles();
    } catch (e, st) {
      state = AsyncError(e, st);
    }
  }

  Future<void> deleteProfile(int id) async {
    try {
      await _repo.deleteProfile(id);
      await loadProfiles();
    } catch (e, st) {
      state = AsyncError(e, st);
    }
  }

  Future<void> setActive(int id) async {
    try {
      await _repo.setActiveProfile(id);
      await loadProfiles();
    } catch (e, st) {
      state = AsyncError(e, st);
    }
  }
}

final profilesProvider =
    StateNotifierProvider<ProfilesNotifier, AsyncValue<List<ProfileModel>>>(
        (ref) {
  final repo = ref.watch(profileRepositoryProvider);
  return ProfilesNotifier(repo);
});

// ---------------------------------------------------------------------------
// Active profile — derived provider
// ---------------------------------------------------------------------------

final activeProfileProvider = Provider<ProfileModel?>((ref) {
  final profilesState = ref.watch(profilesProvider);
  return profilesState.whenOrNull(
    data: (profiles) {
      try {
        return profiles.firstWhere((p) => p.isActive);
      } catch (_) {
        return profiles.isNotEmpty ? profiles.first : null;
      }
    },
  );
});
