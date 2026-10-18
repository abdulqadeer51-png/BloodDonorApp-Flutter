
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AppThemeController {
  AppThemeController._();

  static final ValueNotifier<bool> isDarkMode =
      ValueNotifier<bool>(false);

  static Future<void> loadTheme() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      isDarkMode.value = prefs.getBool('dark_mode') ?? false;
    } catch (e) {
      debugPrint('Error loading theme: $e');
    }
  }

  static Future<void> setDarkMode(bool value) async {
    // Update the UI immediately.
    isDarkMode.value = value;

    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setBool('dark_mode', value);
    } catch (e) {
      debugPrint('Error saving theme: $e');
    }
  }
}
