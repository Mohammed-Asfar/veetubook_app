import 'package:flutter/material.dart';

import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/app_theme_extension.dart';
import '../../../l10n/app_localizations.dart';

/// One onboarding slide's content.
class _Slide {
  const _Slide({
    required this.icon,
    required this.title,
    required this.body,
  });
  final IconData icon;
  final String Function(AppLocalizations) title;
  final String Function(AppLocalizations) body;
}

const _slides = <_Slide>[
  _Slide(
    icon: Icons.checklist_rtl,
    title: _t1,
    body: _b1,
  ),
  _Slide(
    icon: Icons.shopping_cart_checkout,
    title: _t2,
    body: _b2,
  ),
  _Slide(
    icon: Icons.insights,
    title: _t3,
    body: _b3,
  ),
  _Slide(
    icon: Icons.translate,
    title: _t4,
    body: _b4,
  ),
];

// Tear-off getters keep _slides `const` while still resolving live per locale.
String _t1(AppLocalizations l) => l.onboard1Title;
String _b1(AppLocalizations l) => l.onboard1Body;
String _t2(AppLocalizations l) => l.onboard2Title;
String _b2(AppLocalizations l) => l.onboard2Body;
String _t3(AppLocalizations l) => l.onboard3Title;
String _b3(AppLocalizations l) => l.onboard3Body;
String _t4(AppLocalizations l) => l.onboard4Title;
String _b4(AppLocalizations l) => l.onboard4Body;

/// First-launch (and revisitable) intro: swipeable Step 1..N pages teaching the
/// core List → Shop → Track flow. On finish/skip it calls [onDone].
class OnboardingPage extends StatefulWidget {
  const OnboardingPage({super.key, required this.onDone});

  /// Called when the user finishes or skips. The host decides where to go next
  /// (home for first launch, or pop() when opened from Settings).
  final VoidCallback onDone;

  @override
  State<OnboardingPage> createState() => _OnboardingPageState();
}

class _OnboardingPageState extends State<OnboardingPage> {
  final _controller = PageController();
  int _index = 0;

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  bool get _isLast => _index == _slides.length - 1;

  void _next() {
    if (_isLast) {
      widget.onDone();
    } else {
      _controller.nextPage(
        duration: const Duration(milliseconds: 280),
        curve: Curves.easeOut,
      );
    }
  }

  void _back() {
    _controller.previousPage(
      duration: const Duration(milliseconds: 280),
      curve: Curves.easeOut,
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final theme = Theme.of(context);

    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            // Top bar: step counter + Skip.
            Padding(
              padding: const EdgeInsets.fromLTRB(
                AppSpacing.lg,
                AppSpacing.sm,
                AppSpacing.sm,
                0,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    l10n.onboardStep(_index + 1, _slides.length),
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: context.appColors.mutedText,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  TextButton(
                    onPressed: widget.onDone,
                    child: Text(l10n.onboardingSkip),
                  ),
                ],
              ),
            ),
            Expanded(
              child: PageView.builder(
                controller: _controller,
                itemCount: _slides.length,
                onPageChanged: (i) => setState(() => _index = i),
                itemBuilder: (context, i) => _SlideView(slide: _slides[i]),
              ),
            ),
            _Dots(count: _slides.length, index: _index),
            const SizedBox(height: AppSpacing.lg),
            // Bottom actions: a full-width primary button, with Back below it
            // once past the first step. The primary button intentionally spans
            // the width (the themed FilledButton has a full-width minimum), so
            // it is NOT nested in a Row.
            Padding(
              padding: const EdgeInsets.fromLTRB(
                AppSpacing.lg,
                0,
                AppSpacing.lg,
                AppSpacing.lg,
              ),
              child: Column(
                children: [
                  FilledButton(
                    onPressed: _next,
                    child: Text(
                      _isLast
                          ? l10n.onboardingGetStarted
                          : l10n.onboardingNext,
                    ),
                  ),
                  SizedBox(
                    height: 40,
                    child: _index > 0
                        ? TextButton(
                            onPressed: _back,
                            child: Text(l10n.onboardingBack),
                          )
                        : null,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _SlideView extends StatelessWidget {
  const _SlideView({required this.slide});
  final _Slide slide;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.xl),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 140,
            height: 140,
            decoration: BoxDecoration(
              color: scheme.primary.withValues(alpha: 0.10),
              shape: BoxShape.circle,
            ),
            child: Icon(slide.icon, size: 64, color: scheme.primary),
          ),
          const SizedBox(height: AppSpacing.xxl),
          Text(
            slide.title(l10n),
            textAlign: TextAlign.center,
            style: theme.textTheme.headlineSmall?.copyWith(
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: AppSpacing.md),
          Text(
            slide.body(l10n),
            textAlign: TextAlign.center,
            style: theme.textTheme.bodyLarge?.copyWith(
              color: context.appColors.mutedText,
              height: 1.4,
            ),
          ),
        ],
      ),
    );
  }
}

class _Dots extends StatelessWidget {
  const _Dots({required this.count, required this.index});
  final int count;
  final int index;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        for (var i = 0; i < count; i++)
          AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            margin: const EdgeInsets.symmetric(horizontal: AppSpacing.xs),
            width: i == index ? 20 : 8,
            height: 8,
            decoration: BoxDecoration(
              color: i == index
                  ? scheme.primary
                  : scheme.primary.withValues(alpha: 0.25),
              borderRadius: BorderRadius.circular(AppSpacing.radiusSm),
            ),
          ),
      ],
    );
  }
}
