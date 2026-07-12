import 'package:flutter/material.dart';

import '../theme/app_text_styles.dart';
import '../utils/money.dart';

/// Displays a money value (stored as integer paise) formatted consistently
/// as ₹ with Indian grouping. The single place paise -> ₹ formatting happens.
class PriceText extends StatelessWidget {
  const PriceText(
    this.paise, {
    super.key,
    this.style,
    this.color,
  });

  final int paise;
  final TextStyle? style;
  final Color? color;

  @override
  Widget build(BuildContext context) {
    final base = style ?? AppTextStyles.price;
    return Text(
      Money.format(paise),
      style: color != null ? base.copyWith(color: color) : base,
    );
  }
}
