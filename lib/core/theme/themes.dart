import 'package:flutter/material.dart';
import 'colors.dart';
import 'typography.dart';

ThemeData lightTheme = ThemeData(
  colorScheme: ColorScheme.fromSeed(seedColor: AppColors.pink, brightness: Brightness.light),
  useMaterial3: true,
  textTheme: AppText.textTheme,
);

ThemeData darkTheme = ThemeData(
  colorScheme: ColorScheme.fromSeed(seedColor: AppColors.lavender, brightness: Brightness.dark),
  useMaterial3: true,
  textTheme: AppText.textTheme.apply(
    bodyColor: Colors.white, displayColor: Colors.white),
);
