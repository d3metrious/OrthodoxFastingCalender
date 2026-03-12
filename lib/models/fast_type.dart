import 'package:fastingcalender/utils/app_colors.dart';
import 'package:flutter/material.dart';

enum FastType {
  strictFast(
    color: AppColors.fastStrict,
    icon: Icons.add, // This is a Greek cross (equilateral)
  ),
  wineAndOil(
    color: AppColors.fastWineAndOil,
    icon: Icons.opacity,
  ),
  fishOilWine(
    color: AppColors.fastFishOilWine,
    icon: Icons.restaurant,
  ),
  dairyAllowed(
    color: AppColors.fastDairy,
    icon: Icons.egg,
  );

  const FastType({
    required this.color,
    required this.icon,
  });

  final Color color;
  final IconData icon;
}
