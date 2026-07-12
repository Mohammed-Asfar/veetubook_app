import 'package:flutter/material.dart';

import '../../../core/di/service_locator.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../home_shell.dart';
import '../../../l10n/app_localizations.dart';
import '../data/onboarding_store.dart';
import 'onboarding_page.dart';

/// Branded in-app splash shown right after launch. Service-locator init already
/// completed in main(), so this is a short hand-off that then routes to
/// onboarding (first launch) or straight to the home shell.
class SplashPage extends StatefulWidget {
  const SplashPage({super.key});

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  @override
  void initState() {
    super.initState();
    _go();
  }

  Future<void> _go() async {
    // Brief, deliberate hold so the brand splash doesn't just flash.
    await Future<void>.delayed(const Duration(milliseconds: 900));
    if (!mounted) return;

    final navigator = Navigator.of(context);
    final onboarding = sl<OnboardingStore>();

    if (onboarding.hasSeenOnboarding) {
      navigator.pushReplacement(
        MaterialPageRoute(builder: (_) => const HomeShell()),
      );
      return;
    }

    navigator.pushReplacement(
      MaterialPageRoute(
        builder: (_) => OnboardingPage(
          onDone: () async {
            await onboarding.markSeen();
            navigator.pushReplacement(
              MaterialPageRoute(builder: (_) => const HomeShell()),
            );
          },
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    // Fixed brand background so it matches the native splash underneath (no
    // flicker) regardless of light/dark mode.
    return Scaffold(
      backgroundColor: AppColors.primary,
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(AppSpacing.radiusLg),
              child: Image.asset(
                'assets/logo/veetubook_icon.png',
                width: 120,
                height: 120,
              ),
            ),
            const SizedBox(height: AppSpacing.xl),
            Text(
              l10n.appTitle,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 28,
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(height: AppSpacing.sm),
            Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: AppSpacing.xxl),
              child: Text(
                l10n.appTagline,
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.white.withValues(alpha: 0.85),
                  fontSize: 14,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
