import 'package:fastingcalender/utils/app_colors.dart';
import 'package:flutter/material.dart';

enum FastType {
  strictFast(
    label: 'Strict Fast',
    description: 'Refrain from meat, fish, oil, wine, dairy, and eggs.',
    color: AppColors.fastStrict,
  ),
  wineAndOil(
    label: 'Wine & Oil',
    description: 'Wine and oil are allowed. Refrain from meat, fish, dairy, and eggs.',
    color: AppColors.fastWineAndOil,
  ),
  fishOilWine(
    label: 'Fish, Oil & Wine',
    description: 'Fish, oil and wine are allowed. Refrain from meat, dairy and eggs.',
    color: AppColors.fastFishOilWine,
  ),
  dairyAllowed(
    label: 'Dairy Allowed',
    description: 'Dairy, eggs, fish, oil and wine are allowed. Refrain from meat.',
    color: AppColors.fastDairy,
  );

  const FastType({
    required this.label,
    required this.description,
    required this.color,
  });

  final String label;
  final String description;
  final Color color;
}
