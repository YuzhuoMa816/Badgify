import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:nb_utils/nb_utils.dart';

import '../../api/firebase/phone_email_verify.dart';
import '../../dao/process_sign_in.dart';
import '../../data/repositories/user_repository.dart';
import '../../main.dart';
import '../../modals/custom_app_bar.dart';
import '../../modals/image.dart';
import '../../modals/statement.dart';
import '../../utils/colors.dart';
import '../home_page.dart';

class CheckCode extends StatefulWidget {
  const CheckCode({Key? key}) : super(key: key);

  @override
  State<CheckCode> createState() => _CheckCodeState();
}

class _CheckCodeState extends State<CheckCode> {
  TextEditingController checkCodePhoneController = TextEditingController();
  TextEditingController checkCodeVerifyCodeController = TextEditingController();
  FirebaseVerify firebaseVerify = FirebaseVerify();

  ProcessSignIn processSignIn = ProcessSignIn();
  int countDownSeconds = 60;
  bool isSendingCode = false;

  @override
  void initState() {
    super.initState();
    checkCodePhoneController.text = appStore.userModel.phoneNumber ?? '';
  }

  Future<void> clickSignInByPhone(textInfo) async {
    await processSignIn.phoneSendCodeSignin(context, textInfo);
    // update the page state
    setState(() {});
  }

  Future<void> startCountDown() async {
    setState(() {
      isSendingCode = true;
      countDownSeconds = 60;
    });

    while (countDownSeconds > 0) {
      await Future.delayed(const Duration(seconds: 1));
      setState(() {
        countDownSeconds--;
      });
    }

    setState(() {
      isSendingCode = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    double paddingSize = context.height() * 0.01;

    return Scaffold(
      appBar: CustomAppBar(
        title: '',
        isDarkMode: appStore.isDarkMode,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.all(context.height() * 0.01),
            child: Center(
              child: SizedBox(
                width: context.width() * 0.9,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    SizedBox(height: paddingSize),
                    // Logo pic
                    const Logo(),
                    SizedBox(height: context.height() * 0.05),
                    Text(
                      language.checkYourCode,
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 24,
                      ),
                    ),
                    Text(
                      language.checkInboxForVerify,
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        fontSize: 10,
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.all(paddingSize),
                      child: TextField(
                        controller: checkCodePhoneController,
                        decoration: InputDecoration(
                          suffixIcon: Icon(Icons.edit),
                          border: OutlineInputBorder(
                            borderSide: const BorderSide(
                                color: Colors.black87, width: 1.0),
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                          prefixIcon: const Icon(
                            Icons.phone,
                            color: Colors.black87,
                          ),
                          contentPadding: EdgeInsets.symmetric(vertical: 13),
                        ),
                      ),
                    ),

                    Padding(
                      padding: EdgeInsets.all(paddingSize),
                      child: TextField(
                        controller: checkCodeVerifyCodeController,
                        decoration: InputDecoration(
                          labelText: language.verificationCode,
                          hintText: language.verificationCode,
                          border: OutlineInputBorder(
                            borderSide: const BorderSide(
                                color: Colors.black87, width: 1.0),
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                          prefixIcon: Icon(
                            Icons.lock,
                            color: Colors.black87,
                          ),
                          contentPadding:
                              EdgeInsets.fromLTRB(25.0, 15.0, 20.0, 15.0),
                        ),
                      ),
                    ),

                    Padding(
                      padding: EdgeInsets.all(paddingSize),
                      child: AppButton(
                        onTap: () async {
                          // fetch user id here
                          await processSignIn.verifyCredential(
                              checkCodeVerifyCodeController.text);
                          if (appStore.isValidated) {
                            appStore.setVerifyCode("");
                            appStore.userModel.isPhoneVerified = true;


                            bool agreed = false;
                            // fetch user from DB
                            appStore.userModel = await fetchUserDetails(
                                appStore.userModel.uid);
                            if (appStore.userModel.agreedPolicy) {
                              push(const HomePage(), isNewTask: true);
                              return;
                            } else {
                              agreed =
                                  await AgreementModal.showPrivacyPolicyDialog(
                                      context);
                            }
                            if (agreed) {
                              // first time user come in
                              // fetch user from DB
                              // after verified, update user modal in appstore
                              appStore.userModel.agreedPolicy = true;
                              processSignIn
                                  .submitCreateAccountInfo(appStore.userModel);

                              push(const HomePage(), isNewTask: true);
                            } else {
                              ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                      content:
                                          Text("You need to agree first")));
                            }
                          } else {
                            showDialog(
                              context: context,
                              builder: (BuildContext context) {
                                return AlertDialog(
                                  title: Text(language.invalidCode),
                                  content: Text(
                                      language.invalidCodeNotificationText),
                                  actions: [
                                    TextButton(
                                      onPressed: () {
                                        Navigator.of(context).pop();
                                      },
                                      child: Text("OK"),
                                    ),
                                  ],
                                );
                              },
                            );
                          }
                        },
                        text: language.continueWord,
                        color: primaryColor,
                        textColor: Colors.white,
                        width: context.width(),
                      ),
                    ),
                    SizedBox(height: context.height() * 0.02),
                    RichText(
                      textAlign: TextAlign.center,
                      text: TextSpan(
                        children: [
                          TextSpan(
                            text: '${language.didNotReceiveCode}?  ',
                            style: const TextStyle(
                              color: Colors.black,
                            ),
                          ),
                          TextSpan(
                            text: language.sendAgain,
                            style: TextStyle(
                              color: isSendingCode
                                  ? Colors.grey
                                  : Color.fromRGBO(53, 173, 225, 1.0),
                              fontWeight: FontWeight.bold,
                              decoration: TextDecoration.underline,
                            ),
                            recognizer: TapGestureRecognizer()
                              ..onTap = () async {
                                // need resend the verify code
                                if (!isSendingCode) {
                                  appStore.userModel.phoneNumber =
                                      checkCodePhoneController.text;
                                  await clickSignInByPhone(
                                      appStore.userModel.phoneNumber);
                                  await startCountDown();
                                }
                              },
                          ),
                          if (isSendingCode)
                            TextSpan(
                              text: ' ($countDownSeconds)',
                              style: TextStyle(color: primaryColor),
                            ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
