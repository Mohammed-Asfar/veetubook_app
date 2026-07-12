// Smoke test for the onboarding flow: it renders, advances through steps, and
// fires onDone on the last page's "Get started".

import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:veetubook/core/theme/app_theme.dart';
import 'package:veetubook/features/onboarding/presentation/onboarding_page.dart';
import 'package:veetubook/l10n/app_localizations.dart';

Widget _wrap(Widget child) => MaterialApp(
      theme: AppTheme.light,
      localizationsDelegates: const [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: AppLocalizations.supportedLocales,
      home: child,
    );

void main() {
  testWidgets('advances to the last step and calls onDone', (tester) async {
    var done = false;
    await tester.pumpWidget(_wrap(OnboardingPage(onDone: () => done = true)));
    await tester.pumpAndSettle();

    // Step 1 visible.
    expect(find.text('Build your list'), findsOneWidget);
    expect(find.text('Next'), findsOneWidget);

    // Tap Next through to the final slide (4 slides -> 3 taps).
    for (var i = 0; i < 3; i++) {
      await tester.tap(find.text('Next'));
      await tester.pumpAndSettle();
    }

    // Last step shows Get started; tapping it fires onDone.
    expect(find.text('Get started'), findsOneWidget);
    await tester.tap(find.text('Get started'));
    await tester.pumpAndSettle();
    expect(done, isTrue);
  });

  testWidgets('Skip fires onDone immediately', (tester) async {
    var done = false;
    await tester.pumpWidget(_wrap(OnboardingPage(onDone: () => done = true)));
    await tester.pumpAndSettle();

    await tester.tap(find.text('Skip'));
    await tester.pumpAndSettle();
    expect(done, isTrue);
  });
}
