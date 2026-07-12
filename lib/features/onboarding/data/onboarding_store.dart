import 'package:shared_preferences/shared_preferences.dart';

/// Tracks whether the first-launch onboarding has been completed. This is a
/// one-off launch flag, not a user preference, so it lives outside AppSettings.
class OnboardingStore {
  OnboardingStore(this._prefs);

  final SharedPreferences _prefs;

  static const _kSeen = 'onboarding.completed';

  /// True once the user has finished (or skipped) onboarding at least once.
  bool get hasSeenOnboarding => _prefs.getBool(_kSeen) ?? false;

  Future<void> markSeen() => _prefs.setBool(_kSeen, true);
}
