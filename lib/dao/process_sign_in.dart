import 'package:badgify/main.dart';
import 'package:badgify/utils/verify.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:nb_utils/nb_utils.dart';

import '../utils/config.dart';

class ProcessSignIn {
  VerifyValidate verifyValidate = VerifyValidate();
  FirebaseAuth auth = FirebaseAuth.instance;

  Future<void> processPhoneOrEmail(
      BuildContext context, String userData) async {
    hideKeyboard(context);
    appStore.setLoading(true);
    toast(language.validating);
    String verifyResult = verifyValidate.checkPhoneOrEmail(userData);
    try {
      if (verifyResult == "Email") {
        FirebaseAuth.instance
            .sendSignInLinkToEmail(email: userData, actionCodeSettings: acs)
            .catchError(
                (onError) => print('Error sending email verification $onError'))
            .then((value) => print('Successfully sent email verification'));
        appStore.setLoading(false);
      } else if (verifyResult == "Phone") {
        String reformattedPhone = verifyValidate.reformatPhone(userData);

        await FirebaseAuth.instance.verifyPhoneNumber(
          phoneNumber: reformattedPhone,
          verificationCompleted: (PhoneAuthCredential credential) async {
            print("in verificationCompleted");
            // if (isAndroid) {
            //   await auth.signInWithCredential(credential);
            // }
          },
          verificationFailed: (FirebaseAuthException e) {
            print("verificationFailed INFO " + e.toString());
            appStore.setLoading(false);
            toast(e.toString(), print: true);
          },
          codeSent: (String verificationId, int? resendToken) async {
            toast(language.otpCodeIsSentToYourMobileNumber);

            print("In codeSent");
            print(verificationId);

            appStore.setVerifyCode(verificationId);
          },
          codeAutoRetrievalTimeout: (String verificationId) {
            FirebaseAuth.instance.signOut();
          },
        );
        appStore.setLoading(false);
      } else {
        appStore.setLoading(false);
      }
    } catch (e) {
      throw 'Process Phone or email wrong, please try again';
    }
  }

  String checkPhoneOrEmail(String userData) {
    String verifyResult = verifyValidate.checkPhoneOrEmail(userData);
    return verifyResult;
  }

  Future<void> verifyCredential(String smsCode) async {
    print("In verifyCredential");
    PhoneAuthCredential credential = PhoneAuthProvider.credential(
        verificationId: appStore.verifyCode, smsCode: smsCode);
    print("smsCode" + smsCode);
    await FirebaseAuth.instance
        .signInWithCredential(credential)
        .then((UserCredential userCredential) {
      User? user = userCredential.user;
      print("user*****");
      print(user?.uid);
      appStore.setValidate(true);
    }).catchError((error) {
      print('Error verifying code: $error');
    });
  }
}
