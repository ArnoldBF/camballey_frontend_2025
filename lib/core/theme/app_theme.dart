import 'package:flutter/material.dart';
import 'app_colors.dart';

ThemeData buildAppTheme() {
  final base = ThemeData.light(useMaterial3: true);
  return base.copyWith(
    colorScheme: ColorScheme.fromSeed(seedColor: AppColors.primary),
    scaffoldBackgroundColor: AppColors.background,
    inputDecorationTheme: const InputDecorationTheme(
      border: OutlineInputBorder(),
      filled: true,
      fillColor: Colors.white,
    ),
    filledButtonTheme: FilledButtonThemeData(
      style: FilledButton.styleFrom(minimumSize: const Size.fromHeight(48)),
    ),
  );
}
