library nb_utils;

import 'dart:async';

import 'package:flutter/material.dart';
import 'package:nb_utils/nb_utils.dart';


//region Global variables - This variables can be changed.
Color textPrimaryColorGlobal = textPrimaryColor;
Color textSecondaryColorGlobal = textSecondaryColor;
double textBoldSizeGlobal = 16;
double textPrimarySizeGlobal = 16;
double textSecondarySizeGlobal = 14;
String? fontFamilyBoldGlobal;
String? fontFamilyPrimaryGlobal;
String? fontFamilySecondaryGlobal;
FontWeight fontWeightBoldGlobal = FontWeight.bold;
FontWeight fontWeightPrimaryGlobal = FontWeight.normal;
FontWeight fontWeightSecondaryGlobal = FontWeight.normal;


LanguageDataModel? selectedLanguageDataModel;
List<LanguageDataModel> localeLanguageList = [];

Future<void> initialize({
  double? defaultDialogBorderRadius,
  List<LanguageDataModel>? aLocaleLanguageList,
  String? defaultLanguage,
}) async {
  sharedPreferences = await SharedPreferences.getInstance();

  defaultAppButtonShapeBorder =
      RoundedRectangleBorder(borderRadius: radius(defaultAppButtonRadius));

  defaultDialogShape = dialogShape(defaultDialogBorderRadius);

  localeLanguageList = aLocaleLanguageList ?? [];

  selectedLanguageDataModel =
      getSelectedLanguageModel(defaultLanguage: defaultLanguage);
}

Future<T?> push<T>(
    Widget widget, {
      bool isNewTask = false,
      PageRouteAnimation? pageRouteAnimation,
      Duration? duration,
    }) async {
  if (isNewTask) {
    return await Navigator.of(getContext).pushAndRemoveUntil(
      buildPageRoute(
          widget, pageRouteAnimation ?? pageRouteAnimationGlobal, duration),
          (route) => false,
    );
  } else {
    return await Navigator.of(getContext).push(
      buildPageRoute(
          widget, pageRouteAnimation ?? pageRouteAnimationGlobal, duration),
    );
  }
}

void pop([Object? object]) {
  if (Navigator.canPop(getContext)) Navigator.pop(getContext, object);
}