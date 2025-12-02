import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

/// Cubit for managing app theme mode (light, dark, system).
class ThemeCubit extends Cubit<ThemeMode> {
  ThemeCubit() : super(ThemeMode.system);

  /// Set theme to light mode
  void setLightMode() => emit(ThemeMode.light);

  /// Set theme to dark mode
  void setDarkMode() => emit(ThemeMode.dark);

  /// Set theme to follow system setting
  void setSystemMode() => emit(ThemeMode.system);

  /// Toggle between light and dark mode
  /// If currently system, switches to dark
  void toggleTheme() {
    if (state == ThemeMode.light) {
      emit(ThemeMode.dark);
    } else {
      emit(ThemeMode.light);
    }
  }

  /// Check if dark mode is active
  bool get isDarkMode => state == ThemeMode.dark;

  /// Check if system mode is active
  bool get isSystemMode => state == ThemeMode.system;
}

