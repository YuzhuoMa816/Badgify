import 'package:badgify/locale/language_cn.dart';
import 'package:badgify/locale/language_en.dart';

import 'package:flutter/material.dart';

import 'package:flutter/cupertino.dart';
import 'package:nb_utils/nb_utils.dart';

import 'languages.dart';

class AppLocalizations extends LocalizationsDelegate<BaseLanguage> {
  const AppLocalizations();
  @override
  Future<BaseLanguage> load(Locale locale) async {
    switch (locale.languageCode) {
      case 'en':
        return LanguageEn();
      case 'cn':
        return LanguageCn();

      default:
        return LanguageEn();
    }
  }

  @override
  bool isSupported(Locale locale) => LanguageDataModel.languages().contains(locale.languageCode);


  @override
  bool shouldReload(LocalizationsDelegate<BaseLanguage> old) => false;
}