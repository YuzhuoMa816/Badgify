import 'package:badgify/main.dart';
import 'package:badgify/pages/home_page.dart';
import 'package:badgify/pages/login/check_code_page.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:nb_utils/nb_utils.dart';

import '../../api/external_platform_auth.dart';
import '../../dao/process_sign_in.dart';
import '../../modals/custom_app_bar.dart';
import '../../modals/image.dart';
import '../../modals/satetment_bottom.dart';
import '../../utils/colors.dart';
import '../../utils/normalise_phone_number.dart';
import 'check_estate_manager.dart';

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
  TextEditingController signInPhoneController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  final GlobalKey<FormState> _signInFormKey = GlobalKey<FormState>();

  ExternalAuth externalAuth = ExternalAuth();
  bool isPhone = true;
  ProcessSignIn processSignIn = ProcessSignIn();

  late FocusNode textFieldFocusNode;

  @override
  void initState() {
    super.initState();
    textFieldFocusNode = FocusNode();
  }

  @override
  void dispose() {
    textFieldFocusNode.dispose();
    super.dispose();
  }

  void googleSignIn() async {
    appStore.setLoading(true);
    await externalAuth.signInWithGoogle().then((googleUser) async {
      print(googleUser.toString());
      appStore.userModel.googleUid = googleUser.uid;
      appStore.googleLoginEmail = googleUser.email!;

      if (await processSignIn.verifyGoogleUser(googleUser.uid) == null) {
        push(const CheckEstateManager());
      } else {
        appStore.setLoading(false);
        push(const HomePage(), isNewTask: true);
      }
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
    // await SignInWithApple.getAppleIDCredential(
    //     scopes: [
    //       AppleIDAuthorizationScopes.email,
    //       AppleIDAuthorizationScopes.fullName,
    //     ],
    //     webAuthenticationOptions: WebAuthenticationOptions(clientId: ''
    //
    //     )
    //
    //
    // )
  }

  void fbSignIn() async {
    print("this is fb sign in");
  }

  Future<void> handleSignIn(account) async {
    // verify first
    // if (processSignIn.verifyPhone(account) == false) {
    //   ScaffoldMessenger.of(context)
    //       .showSnackBar( SnackBar(content: Text(language.invalidPhone)));
    //   return;
    // }
    // format phone
    String phoneNum = PhoneNumberFormatter.formatAUPhoneNumber(account);

    // check if current phone is system user

    if (await processSignIn.verifyIsSystemUser(phoneNum)) {
      // send code to current user
      await processSignIn.phoneSendCodeSignin(context, phoneNum);
      // update the page state
      setState(() {});
      appStore.userModel.phoneNumber = phoneNum;

      if (appStore.isLoading == false) {
        push(const CheckCode());
      }
    } else {
      // show info to user
      ScaffoldMessenger.of(context).showSnackBar( SnackBar(
          content: Text(language.dontHaveAccount)));

    }
  }

  @override
  Widget build(BuildContext context) {
    Widget buildButton(String buttonText, Function() onTapAction) {
      return Container(
        decoration: BoxDecoration(
          border: Border.all(color: Colors.black),
          borderRadius: BorderRadius.circular(5),
        ),
        child: AppButton(
          onTap: () async {
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
                    padding: const EdgeInsets.symmetric(vertical: 0),
                    // Adjust the vertical padding here
                    child: Text(
                      buttonText,
                      style: const TextStyle(fontSize: 14),
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

    double paddingSize = context.height() * 0.01;
    String? _phoneEmail;
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
                child: Form(
                  key: _signInFormKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      SizedBox(height: paddingSize),
                      // Logo pic
                      const Logo(),
                      SizedBox(height: context.height() * 0.05),

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
                        padding: EdgeInsets.all(paddingSize),
                        child: TextFormField(
                          onTap: () {
                            textFieldFocusNode.requestFocus();
                          },
                          onChanged: (value) {
                            setState(() {
                              _phoneEmail = value;
                            });
                          },
                          controller: signInPhoneController,
                          decoration: InputDecoration(
                            hintText: language.phoneNumber,
                            border: OutlineInputBorder(
                              borderSide: const BorderSide(
                                  color: Colors.black87, width: 1.0),
                              borderRadius: BorderRadius.circular(10.0),
                            ),
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return language.pleaseEnterPhoneNum;
                            }
                            if(processSignIn.verifyPhone(signInPhoneController.text) ==false){
                              return language.invalidPhone;
                            }
                            return null;
                          },
                          onSaved: (value) {
                            _phoneEmail = value;
                          },
                        ),
                      ),

                      SizedBox(height: context.height() * 0.02),

                      Padding(
                        padding: EdgeInsets.all(paddingSize),
                        child: AppButton(
                          onTap: () async {
                            if (_signInFormKey.currentState!.validate()) {
                              await handleSignIn(
                                signInPhoneController.text,
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
                              text: '${language.dontHaveAccount}?  ',
                              style: const TextStyle(
                                color: Colors.black,
                              ),
                            ),
                            TextSpan(
                              text: language.createAccount,
                              style: TextStyle(
                                color: primaryColor,
                                fontWeight: FontWeight.bold,
                                decoration: TextDecoration.underline,
                              ),
                              recognizer: TapGestureRecognizer()
                                ..onTap = () {
                                  push(const CheckEstateManager());
                                },
                            ),
                          ],
                        ),
                      ),

                      SizedBox(height: context.height() * 0.02),
                      Row(
                        children: [
                          Expanded(
                            child: Container(
                              margin:
                                  EdgeInsets.symmetric(horizontal: paddingSize),
                              height: 1,
                              color: Colors.grey,
                            ),
                          ),
                          Text(
                            language.or,
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Colors.black,
                              fontSize: 18,
                            ),
                          ),
                          Expanded(
                            child: Container(
                              margin:
                                  EdgeInsets.symmetric(horizontal: paddingSize),
                              height: 1,
                              color: Colors.grey,
                            ),
                          ),
                        ],
                      ),

                      SizedBox(height: paddingSize),
                      buildButton(language.continueWithGoogle, googleSignIn),
                      SizedBox(height: paddingSize),
                      buildButton(language.continueWithApple, appleSignIn),
                      SizedBox(height: paddingSize),
                      buildButton(language.continueWithFb, fbSignIn),

                      const InfoCollectionStatement(),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
