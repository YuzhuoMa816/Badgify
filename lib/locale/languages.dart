import 'package:flutter/material.dart';

abstract class BaseLanguage {



  static BaseLanguage of(BuildContext context) => Localizations.of<BaseLanguage>(context, BaseLanguage)!;

  String get login;

  String get signIn;

  String get phoneNumber;

  String get email;

  String get pleaseTryAgain;

  String get somethingWentWrong;

  String get requiredText;

  String get internetNotAvailable;

  String get enterYourPhoneEmail;

  String get continueWord;

  String get dontHaveAccount;

  String get continueWithApple;

  String get continueWithFb;

  String get continueWithGoogle;

  String get or;

  String get createAccount;






}
