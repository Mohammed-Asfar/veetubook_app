import 'package:flutter/material.dart';

import '../localization/app_language.dart';

/// Picks the right name for a bilingual entity (product / category / item)
/// based on the active language, with graceful fallback.
///
/// PRD rule: never show a blank name. If the preferred-language name is
/// missing, fall back to the other language's name.
String resolveBilingual({
  required AppLanguage language,
  required String? nameTa,
  required String? nameEn,
}) {
  final ta = (nameTa ?? '').trim();
  final en = (nameEn ?? '').trim();
  switch (language) {
    case AppLanguage.tamil:
      return ta.isNotEmpty ? ta : en;
    case AppLanguage.english:
      return en.isNotEmpty ? en : ta;
  }
}

/// Renders a bilingual name using the active locale, falling back to whichever
/// name exists. Use this everywhere product/category/item names are shown so
/// the fallback rule lives in exactly one place.
class BilingualText extends StatelessWidget {
  const BilingualText({
    super.key,
    required this.nameTa,
    required this.nameEn,
    this.style,
    this.maxLines,
    this.overflow = TextOverflow.ellipsis,
  });

  final String? nameTa;
  final String? nameEn;
  final TextStyle? style;
  final int? maxLines;
  final TextOverflow overflow;

  @override
  Widget build(BuildContext context) {
    // Derive language from the active locale so it updates live on switch.
    final language = AppLanguage.fromCode(Localizations.localeOf(context).languageCode);
    final text = resolveBilingual(
      language: language,
      nameTa: nameTa,
      nameEn: nameEn,
    );
    return Text(
      text,
      style: style ?? Theme.of(context).textTheme.bodyLarge,
      maxLines: maxLines,
      overflow: overflow,
    );
  }
}
