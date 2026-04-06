import 'package:flutter/foundation.dart';

/// Stub analytics service. Replace with Firebase Analytics when
/// Firebase project is configured (add firebase_core, firebase_analytics
/// to pubspec.yaml and place google-services.json / GoogleService-Info.plist).
///
/// All methods are no-ops until Firebase is wired up.
class AnalyticsService {
  AnalyticsService._();

  static final AnalyticsService instance = AnalyticsService._();

  bool _initialized = false;

  bool get isInitialized => _initialized;

  void initialize() {
    _initialized = true;
    debugPrint('AnalyticsService: stub initialized (Firebase not configured)');
  }

  Future<void> logScreenView({
    required String screenName,
    String? screenClass,
  }) async {
    _log('screen_view', {'screen': screenName});
  }

  Future<void> logBmiCalculated({
    required double bmi,
    required String category,
  }) async {
    _log('bmi_calculated', {'bmi': bmi, 'category': category});
  }

  Future<void> logBmiSaved({required double bmi}) async {
    _log('bmi_saved', {'bmi': bmi});
  }

  Future<void> logBmiShared({required double bmi}) async {
    _log('bmi_shared', {'bmi': bmi});
  }

  Future<void> logProfileCreated() async {
    _log('profile_created', {});
  }

  Future<void> logProfileSwitched() async {
    _log('profile_switched', {});
  }

  Future<void> logAdImpression({required String adType}) async {
    _log('ad_impression', {'ad_type': adType});
  }

  Future<void> logUnitChanged({required String unit}) async {
    _log('unit_changed', {'unit': unit});
  }

  Future<void> logCustomEvent({
    required String name,
    Map<String, Object>? parameters,
  }) async {
    _log(name, parameters ?? {});
  }

  Future<void> setUserProperty({
    required String name,
    required String? value,
  }) async {
    debugPrint('AnalyticsService: setUserProperty($name=$value) [stub]');
  }

  void _log(String event, Map<String, Object> params) {
    debugPrint('AnalyticsService: $event $params [stub]');
  }
}
