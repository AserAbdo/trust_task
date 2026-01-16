import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

/// AppLocalizations - Loads translations from JSON files in assets/l10n/
class AppLocalizations {
  final Locale locale;
  late Map<String, String> _localizedStrings;

  AppLocalizations(this.locale);

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// Load translations from JSON file
  Future<bool> load() async {
    final jsonString = await rootBundle.loadString(
      'assets/l10n/${locale.languageCode}.json',
    );
    final Map<String, dynamic> jsonMap = json.decode(jsonString);

    _localizedStrings = jsonMap.map((key, value) {
      return MapEntry(key, value.toString());
    });

    return true;
  }

  /// Get translated string by key
  String translate(String key, {Map<String, String>? params}) {
    String result = _localizedStrings[key] ?? key;

    // Replace parameters if provided (e.g., {name} -> actual name)
    if (params != null) {
      params.forEach((paramKey, paramValue) {
        result = result.replaceAll('{$paramKey}', paramValue);
      });
    }

    return result;
  }

  /// Check if current locale is Arabic
  bool get isArabic => locale.languageCode == 'ar';
}

/// Localization Delegate
class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  bool isSupported(Locale locale) {
    return ['en', 'ar'].contains(locale.languageCode);
  }

  @override
  Future<AppLocalizations> load(Locale locale) async {
    final localizations = AppLocalizations(locale);
    await localizations.load();
    return localizations;
  }

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

/// Extension for easy access to localizations
extension LocalizationsExtension on BuildContext {
  AppLocalizations get l10n => AppLocalizations.of(this)!;
  bool get isRtl => Localizations.localeOf(this).languageCode == 'ar';
}
