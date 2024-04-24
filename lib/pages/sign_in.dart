import 'package:badgify/main.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:nb_utils/nb_utils.dart';

import '../api/external_platform_auth.dart';
import '../api/firebase/phone_email_verify.dart';
import '../modals/statement.dart';
import '../utils/colors.dart';

import 'package:http/http.dart' as http;
import 'package:sign_in_with_apple/sign_in_with_apple.dart';



class SignIn extends StatefulWidget {
  const SignIn({super.key});



  @override
  State<SignIn> createState() => _SignInState();
}

// create getHighContrastColor for different theme(dark/light)
Color getHighContrastColor() {
  return Color.alphaBlend(Colors.white.withOpacity(0.3), Colors.transparent)
              .computeLuminance() >
          0.5
      ? Colors.black
      : Colors.white;
}

Color highContrastColor = getHighContrastColor();

// extract button widget for the continue with apple/google/fb


class _SignInState extends State<SignIn> {

  TextEditingController signInPhoneEmailController = TextEditingController();
  ExternalAuth externalAuth = ExternalAuth();



  void googleSignIn() async {
    appStore.setLoading(true);
    await externalAuth.signInWithGoogle().then((googleUser) async {

      String firstName = '';
      String lastName = '';
      print(googleUser.toString());
      if (googleUser.displayName
          .validate()
          .split(' ')
          .length >= 1) firstName = googleUser.displayName.splitBefore(' ');
      if (googleUser.displayName
          .validate()
          .split(' ')
          .length >= 2) lastName = googleUser.displayName.splitAfter(' ');

    }).catchError((e) {
      appStore.setLoading(false);
      toast(e.toString());
    });
  }

  void appleSignIn() async {
    appStore.setLoading(true);
    await externalAuth.appleSignIn().then((appleUser) async {
      print("in apple");
      print(appleUser.toString());
    }).catchError((e) {
      appStore.setLoading(false);
      toast(e.toString());
    });

  }

  void fbSignIn() async {
    print("this is fb sign in");
  }


  bool clickSignInByPhoneEmail() {

  //   TODO verify current phone/email, if not pass return invalid info else jump to check code page

    return false;

  }


  @override
  Widget build(BuildContext context) {

    Widget buildButton(String buttonText, Function() onTapAction) {
      return
        Container(
          decoration: BoxDecoration(
            border: Border.all(color: Colors.black),
            borderRadius: BorderRadius.circular(5),
          ),
          child: AppButton(
            onTap:  () async {
              await onTapAction();
            },
            color: Colors.white,
            textColor: highContrastColor,
            width: double.infinity,
            // Fill the available width
            child: Center(
              child: Row(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.arrow_forward, color: highContrastColor),
                  // Add some space between icon and text
                  Expanded(
                    child: Padding(
                      padding: EdgeInsets.symmetric(vertical: 0),
                      // Adjust the vertical padding here
                      child: Text(
                        buttonText,
                        style: TextStyle(fontSize: 14),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
                ],
              ),
            ),

          ),
        );
    }
    return Scaffold(
      appBar: AppBar(
        systemOverlayStyle: SystemUiOverlayStyle(statusBarIconBrightness: appStore.isDarkMode ? Brightness.light : Brightness.dark, statusBarColor: context.scaffoldBackgroundColor),

      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(5.0),
          child: Center(
            child: SizedBox(
              width: context.width() * 0.9,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const SizedBox(height: 15),
                  // Logo pic
                  Image.asset(
                    'assets/badgify_logo_long.png',
                    height: 60,
                    width: 100,
                  ),
                  const SizedBox(height: 30),

                  Text(
                    language.signIn,
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 24,
                    ),
                  ),
                  // phone / email
                  Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: TextField(
                      controller: signInPhoneEmailController,
                      decoration: InputDecoration(
                        hintText: language.enterYourPhoneEmail,
                        border: OutlineInputBorder(
                          borderSide: const BorderSide(
                              color: Colors.black87, width: 1.0),
                          borderRadius: BorderRadius.circular(10.0),
                        ),
                      ),
                    ),
                  ),
                  // Continue button
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: AppButton(
                      onTap: () async {
                         clickSignInByPhoneEmail();
                      },
                      text: language.continueWord,
                      color: primaryColor,
                      textColor: Colors.white,
                      width: context.width(),
                    ),
                  ),

                  const SizedBox(height: 10),
                  RichText(
                    textAlign: TextAlign.center,
                    text: TextSpan(
                      children: [
                        TextSpan(
                          text: '${language.dontHaveAccount}?  ',
                          style: TextStyle(
                            color: Colors.black,
                          ),
                        ),
                        TextSpan(
                          text: language.createAccount,
                          style: const TextStyle(
                            color: Color.fromRGBO(53, 173, 225, 1.0),
                            fontWeight: FontWeight.bold,
                          ),
                          recognizer: TapGestureRecognizer()
                            ..onTap = () {
                              //  jump to sign up
                            },
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 20),
                  Row(
                    children: [
                      Expanded(
                        child: Container(
                          margin: EdgeInsets.symmetric(horizontal: 16),
                          height: 1,
                          color: Colors.grey,
                        ),
                      ),
                      Text(
                        language.or,
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                          fontSize: 18,
                        ),
                      ),
                      Expanded(
                        child: Container(
                          margin: EdgeInsets.symmetric(horizontal: 16),
                          height: 1,
                          color: Colors.grey,
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 10),
                  buildButton(language.continueWithGoogle, googleSignIn),
                  const SizedBox(height: 6),
                  buildButton(language.continueWithApple, appleSignIn),
                  const SizedBox(height: 6),
                  buildButton(language.continueWithFb, fbSignIn),


                  const Divider(
                    color: Colors.grey,
                    thickness: 1.0,
                    height: 20.0,
                    indent: 0.0,
                    endIndent: 0.0,
                  ),

                  Center(
                    child: GestureDetector(
                      onTap: (){
                        setState(() {
                          AgreementModal.showAgreementDialog(context);
                        });
                      },
                      child: Text(
                        language.infoCollectionStatement,
                        style: TextStyle(fontSize: 10.0, color: primaryColor),
                      ),
                    ),
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }


}
