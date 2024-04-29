import 'package:firebase_auth/firebase_auth.dart';
import 'package:nb_utils/nb_utils.dart';

import '../../dao/processVerifyInfo.dart';
import '../../main.dart';
import '../../utils/normalise_phone_number.dart';

class FirebaseVerify {
  Verify verity = Verify();
  PhoneNumberFormatter formatter = PhoneNumberFormatter();

  // 0 for invalid, 1 for phone, 2 for Email
  Future<bool> verifyInputText(String inputText) async {
    int checkResult = verity.checkPhoneOrEmail(inputText);
    if (checkResult == 1) {
      print("in verifyInputText");
      await FirebaseAuth.instance.verifyPhoneNumber(

          phoneNumber: formatter.formatAUPhoneNumber(inputText),
          verificationCompleted: (PhoneAuthCredential phoneAuthCredential) async {
            toast(language.verified);

            if (isAndroid) {
              await FirebaseAuth.instance.signInWithCredential(phoneAuthCredential);
            }
          },
          verificationFailed: (FirebaseAuthException error) {
            print("in");
            appStore.setLoading(false);
            if (error.code == 'invalid-phone-number') {
              toast(language.theEnteredCodeIsInvalidPleaseTryAgain, print: true);
            } else {
              toast(error.toString(), print: true);
            }
          },
          codeSent: (String verificationId, int? forceResendingToken) {},
          codeAutoRetrievalTimeout: (String verificationId) {}

      );
      return true;
    }

    return false;
  }

}