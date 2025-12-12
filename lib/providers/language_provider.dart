import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../utils/app_strings.dart';

class LanguageProvider extends ChangeNotifier {
  String _currentLanguage = 'en';

  String get currentLanguage => _currentLanguage;

  LanguageProvider() {
    _loadLanguage();
  }

  Future<void> _loadLanguage() async {
    final prefs = await SharedPreferences.getInstance();
    _currentLanguage = prefs.getString('language_code') ?? 'en';
    notifyListeners();
  }

  Future<void> setLanguage(String code) async {
    if (_currentLanguage != code) {
      _currentLanguage = code;
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('language_code', code);
      notifyListeners();
    }
  }

  String getText(String key) {
    return AppStrings.getString(_currentLanguage, key);
  }
}
