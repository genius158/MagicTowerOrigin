import 'dart:convert';
import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class Translations {
  Locale _locale;
  static Map<dynamic, dynamic> _localizedValues;

  Translations(Locale locale) {
    this._locale = locale;
    _localizedValues = null;
  }

  static Translations of(BuildContext context) =>
      Localizations.of<Translations>(context, Translations);

  String text(String key) => _localizedValues[key] ?? '** $key not found';

  static Future<Translations> load(Locale locale) async {
    Translations translations = new Translations(locale);
    String jsonContent = await rootBundle
        .loadString('lib/locale/i18n_${locale.languageCode}.json');
    _localizedValues = json.decode(jsonContent);
    return translations;
  }

  get currentLanguage => _locale.languageCode;
}

class TranslationsDelegate extends LocalizationsDelegate<Translations> {
  const TranslationsDelegate();

  ///验证支持的语言
  @override
  bool isSupported(Locale locale) => ['en', 'zh'].contains(locale.languageCode);

  @override
  Future<Translations> load(Locale locale) => Translations.load(locale);

  @override
  bool shouldReload(LocalizationsDelegate<Translations> old) => false;
}
