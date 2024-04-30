import 'package:flutter/material.dart';

abstract class BaseLanguage {





  static BaseLanguage of(BuildContext context) => Localizations.of<BaseLanguage>(context, BaseLanguage)!;

  String get login;

  String get password;

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

  String get infoCollectionStatement;

  String get close;

  String get agreementText;

  String get verified;

  String get theEnteredCodeIsInvalidPleaseTryAgain;

  String get appleSignInNotAvailable;

  String get lblSignInFailed;

  String get lblUserCancelled;

  String get checkYourCode;

  String get verificationCode;

  String get checkInboxForVerify;

  String get no;

  String get yes;

  String get areYouAgent;

  String get areYouSerPro;

  String get workSpecies;

  String get realEstateAgent;

  String get propertyManager;

  String get photographer;

  String get homeStylist;

  String get other;

  String get iAmA;

  String get iWorkIn;

  String get lJHooker;

  String get handyPlumberEtc;

  String get validating;

  String get otpCodeIsSentToYourMobileNumber;

  String get phoneNumberExample;

  String get lastName;

  String get lastNameExample;

  String get firstName;

  String get firstNameExample;

  String get emailExample;

}
