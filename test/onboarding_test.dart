// Verifies the first-launch onboarding flag persists via shared_preferences.

import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:veetubook/features/onboarding/data/onboarding_store.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  test('onboarding starts unseen, then stays seen after markSeen', () async {
    SharedPreferences.setMockInitialValues({});
    final prefs = await SharedPreferences.getInstance();
    final store = OnboardingStore(prefs);

    // First launch: not seen yet.
    expect(store.hasSeenOnboarding, isFalse);

    await store.markSeen();
    expect(store.hasSeenOnboarding, isTrue);

    // A fresh store over the same prefs still reads it as seen (persisted).
    expect(OnboardingStore(prefs).hasSeenOnboarding, isTrue);
  });
}
