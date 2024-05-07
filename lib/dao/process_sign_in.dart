import 'package:badgify/main.dart';
import 'package:badgify/utils/verify.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:nb_utils/nb_utils.dart';

import '../data/repositories/user_repository.dart';
import '../model/user_model.dart';

class ProcessSignIn {
  VerifyValidate verifyValidate = VerifyValidate();
  FirebaseAuth auth = FirebaseAuth.instance;

  bool verifyPhone(String userData) {
    String verifyResult = verifyValidate.checkValidPhone(userData);
    if (verifyResult == "Phone") {
      return true;
    } else {
      return false;
    }
  }

  Future<void> phoneSendCodeSignin(
      BuildContext context, String phoneNum) async {
    hideKeyboard(context);
    appStore.setLoading(true);
    toast(language.validating);
    try {
      await FirebaseAuth.instance.verifyPhoneNumber(
        phoneNumber: phoneNum,
        verificationCompleted: (PhoneAuthCredential credential) async {
          print("in verificationCompleted");
        },
        verificationFailed: (FirebaseAuthException e) {
          print("verificationFailed INFO " + e.toString());
          appStore.setLoading(false);
          toast(e.toString(), print: true);
        },
        codeSent: (String verificationId, int? resendToken) async {
          toast(language.otpCodeIsSentToYourMobileNumber);

          appStore.setVerifyCode(verificationId);
        },
        codeAutoRetrievalTimeout: (String verificationId) {
          FirebaseAuth.instance.signOut();
        },
      );
      appStore.setLoading(false);
    } catch (e) {
      throw 'Process Phone wrong, please try again';
    }
  }

  Future<void> verifyCredential(String smsCode) async {
    PhoneAuthCredential credential = PhoneAuthProvider.credential(
        verificationId: appStore.verifyCode, smsCode: smsCode);
    await FirebaseAuth.instance
        .signInWithCredential(credential)
        .then((UserCredential userCredential) async {
      User? user = userCredential.user;
      appStore.userModel.uid = user!.uid;

      appStore.setValidate(true);
    }).catchError((error) {
      print('Error verifying code: $error');
    });
  }



  Future<UserModel?> verifyGoogleUser(String googleUserUid) async {
    UserModel? user = await fetchUserDetailsByGoogleId(googleUserUid);
    if (user == null) {
      return null;
    } else {
      appStore.userModel = user;
      return user;
    }
  }

  Future<bool> verifyIsSystemUser(String phoneNum) async {
    UserModel? userModel = await fetchUserDetailsByPhone(phoneNum);

    if (userModel == null) {
      print("userModel == null");
      return false;
    } else {
      return true;
    }
  }

  Future<UserModel?> fetchSystemUser(String phoneNum) async {
    return await fetchUserDetailsByPhone(phoneNum);
  }

  void submitCreateAccountInfo(UserModel user) {
    // store new user into the Database
    saveUserRecord(user);
  }
}
