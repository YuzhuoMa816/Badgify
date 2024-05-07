import 'package:firebase_auth/firebase_auth.dart';
import 'package:nb_utils/nb_utils.dart';

import '../../main.dart';
import '../../utils/normalise_phone_number.dart';
import '../../utils/verify.dart';

class FirebaseVerify {
  VerifyValidate verity = VerifyValidate();

  // 0 for invalid, 1 for phone, 2 for Email
  Future<bool> verifyInputText(String inputText) async {
    int checkResult = verity.checkValidPhone(inputText) as int;
    if (checkResult == 1) {
      await FirebaseAuth.instance.verifyPhoneNumber(
          phoneNumber: PhoneNumberFormatter.formatAUPhoneNumber(inputText),
          verificationCompleted:
              (PhoneAuthCredential phoneAuthCredential) async {
            toast(language.verified);
            if (isAndroid) {
              await FirebaseAuth.instance
                  .signInWithCredential(phoneAuthCredential);
            }
          },
          verificationFailed: (FirebaseAuthException error) {
            print("in");
            appStore.setLoading(false);
            if (error.code == 'invalid-phone-number') {
              toast(language.theEnteredCodeIsInvalidPleaseTryAgain,
                  print: true);
            } else {
              toast(error.toString(), print: true);
            }
          },
          codeSent: (String verificationId, int? forceResendingToken) {},
          codeAutoRetrievalTimeout: (String verificationId) {});
      return true;
    }

    return false;
  }

  Future<void> emailPasswordSignIn(String emailAddress, String password) async {
    appStore.setLoading(true);
    UserCredential? userCredential;
    try {
      userCredential =
          await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: emailAddress,
        password: password,
      );

      appStore.userModel.emailPasswordUid = userCredential.user!.uid;
      print("Email verify success");
      appStore.userModel.isEmailVerified = true;

      appStore.setLoading(false);
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        toast('The password provided is too weak.');
        appStore.setLoading(false);
      } else if (e.code == 'email-already-in-use') {
        appStore.setLoading(false);
        toast('The account already exists for that email.');
      }
    } catch (e) {
      print(e);
    }
  }

  // Future<void> updatePasswordForEmail(
  //     String emailAddress, String password) async {
  //
  //   final user = FirebaseAuth.instance.currentUser!;
  //
  //
  //
  //   //Pass in the password to updatePassword.
  //   user.updatePassword(password).then((_) {
  //     toast("Successfully update the password");
  //   }).catchError((error) {
  //     toast("Password can't be changed$error");
  //   });
  // }
}
