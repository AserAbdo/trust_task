import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// State for language management
class LanguageState extends Equatable {
  final Locale locale;

  const LanguageState({required this.locale});

  @override
  List<Object?> get props => [locale];
}

/// Cubit for managing app language with persistence
class LanguageCubit extends Cubit<LanguageState> {
  static const String _languageKey = 'app_language';
  final SharedPreferences _prefs;

  LanguageCubit({required SharedPreferences prefs})
    : _prefs = prefs,
      super(const LanguageState(locale: Locale('ar'))) {
    _loadSavedLanguage();
  }

  /// Load saved language from SharedPreferences
  void _loadSavedLanguage() {
    final savedLanguage = _prefs.getString(_languageKey);
    if (savedLanguage != null) {
      emit(LanguageState(locale: Locale(savedLanguage)));
    }
  }

  /// Change the app language and save to SharedPreferences
  Future<void> changeLanguage(String languageCode) async {
    await _prefs.setString(_languageKey, languageCode);
    emit(LanguageState(locale: Locale(languageCode)));
  }

  /// Toggle between Arabic and English
  Future<void> toggleLanguage() async {
    final newLanguageCode = state.locale.languageCode == 'ar' ? 'en' : 'ar';
    await changeLanguage(newLanguageCode);
  }

  /// Check if current language is Arabic
  bool get isArabic => state.locale.languageCode == 'ar';

  /// Get current language name
  String get currentLanguageName => isArabic ? 'العربية' : 'English';
}
