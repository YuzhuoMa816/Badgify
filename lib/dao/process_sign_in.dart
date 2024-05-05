import 'package:badgify/main.dart';
import 'package:badgify/utils/verify.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:nb_utils/nb_utils.dart';

import '../data/repositories/user_repository.dart';
import '../model/user_model.dart';
import '../utils/config.dart';
import '../utils/normalise_phone_number.dart';

class ProcessSignIn {
  VerifyValidate verifyValidate = VerifyValidate();
  FirebaseAuth auth = FirebaseAuth.instance;

  Future<void> processPhoneOrEmailSignIn(
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
    PhoneAuthCredential credential = PhoneAuthProvider.credential(
        verificationId: appStore.verifyCode, smsCode: smsCode);
    await FirebaseAuth.instance
        .signInWithCredential(credential)
        .then((UserCredential userCredential) {
      User? user = userCredential.user;
      print(user?.uid);
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
      return user;
    }
  }

  Future<bool> verifyIsSystemUser(String phoneNum) async {
    UserModel? userModel = await fetchUserDetailsByPhone(phoneNum);

    if (userModel == null) {
      // no such user, return false
      return false;
    } else {
      return true;
    }
  }

  // check phone or email first, then check auth by firebase, store user data
  // into gloable return result by string
  Future<String> signInByPhoneOrEmail(
      BuildContext context, String account, String password) async {
    String verifyResult = verifyValidate.checkPhoneOrEmail(account);

    String userAccount = account;
    if (verifyResult == "Phone") {
      String formattedPhoneNum = PhoneNumberFormatter.formatAUPhoneNumber(account);

      print("formattedPhoneNum$formattedPhoneNum");
      UserModel? userModel = await fetchUserDetailsByPhone(formattedPhoneNum);
      if (userModel == null) {
        return "No user found.";
      }
      userAccount = userModel.email;
    }
    UserCredential? userCredential;

    try {
      userCredential = await FirebaseAuth.instance
          .signInWithEmailAndPassword(email: userAccount, password: password);
      //   if verify success, store all the user data into the app_store
      appStore.userModel = await fetchUserDetails(userCredential.user!.uid);
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        return "No user found.";
      } else if (e.code == 'wrong-password') {
        return "Wrong password";
      }
    }
    if (userCredential != null) {
      return "Login Success";
    } else {
      return "Wrong Password";
    }
  }

  void submitCreateAccountInfo(UserModel user) {
    // store new user into the Database
    saveUserRecord(user);
  }
}
