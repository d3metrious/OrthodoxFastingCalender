import 'package:flutter/material.dart';

enum FastType {
  strictFast(
    label: 'Strict Fast',
    description: 'Refrain from meat, fish, oil, wine, dairy, and eggs.',
    color: Colors.red,
  ),
  wineAndOil(
    label: 'Wine & Oil',
    description: 'Wine and oil are allowed. Refrain from meat, fish, dairy, and eggs.',
    color: Colors.purple,
  ),
  fishOilWine(
    label: 'Fish, Oil & Wine',
    description: 'Fish, oil and wine are allowed. Refrain from meat, dairy and eggs.',
    color: Colors.blue,
  ),
  dairyAllowed(
    label: 'Dairy Allowed',
    description: 'Dairy, eggs, fish, oil and wine are allowed. Refrain from meat.',
    color: Colors.orange,
  ),
  abstainMeat(
    label: 'Abstain from Meat',
    description: 'Refrain from meat only.',
    color: Colors.yellow,
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
