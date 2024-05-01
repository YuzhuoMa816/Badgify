import 'package:badgify/main.dart';
import 'package:badgify/pages/login/check_code_page.dart';
import 'package:badgify/pages/login/type_title.dart';
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
  TextEditingController signInPhoneEmailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  ExternalAuth externalAuth = ExternalAuth();
  bool isPhone = true;
  ProcessSignIn processSignIn = ProcessSignIn();

  late FocusNode textFieldFocusNode;

  @override
  void initState() {
    super.initState();
    textFieldFocusNode = FocusNode();
  }

  void save(){
    var form = _formKey.currentState;
    if(form!.validate()){
      debugPrint("form valid");
      form.save();
    }
  }


  @override
  void dispose() {
    textFieldFocusNode.dispose();
    super.dispose();
  }

  void googleSignIn() async {
    appStore.setLoading(true);
    await externalAuth.signInWithGoogle().then((googleUser) async {
      String firstName = '';
      String lastName = '';
      print(googleUser.toString());
      if (googleUser.displayName.validate().split(' ').isNotEmpty)
        firstName = googleUser.displayName.splitBefore(' ');
      if (googleUser.displayName.validate().split(' ').length >= 2)
        lastName = googleUser.displayName.splitAfter(' ');
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

  Future<void> clickSignInByPhoneEmail(textInfo) async {
    await processSignIn.processPhoneOrEmail(context, textInfo);
    // update the page state
    setState(() {});
  }

  void infoIsPhone(textInfo) {
    String verifyResult = processSignIn.checkPhoneOrEmail(textInfo);
    if (verifyResult == "Phone") {
      isPhone = true;
    } else {
      isPhone = false;
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
                  key: _formKey,
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
                          controller: signInPhoneEmailController,
                          decoration: InputDecoration(
                            hintText: language.enterYourPhoneEmail,
                            border: OutlineInputBorder(
                              borderSide: const BorderSide(
                                  color: Colors.black87, width: 1.0),
                              borderRadius: BorderRadius.circular(10.0),
                            ),
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              print("Empty!!!");
                              return "input the email or phone number";
                            }
                            return null;
                          },
                          onSaved: (value) {
                            _phoneEmail = value;
                          },
                        ),
                      ),

                      Padding(
                        padding: EdgeInsets.all(paddingSize),
                        child: TextField(
                          onTap: () {
                            textFieldFocusNode.requestFocus();
                          },
                          controller: passwordController,
                          obscureText: true,
                          decoration: InputDecoration(
                            hintText: language.password,
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
                        padding: EdgeInsets.all(paddingSize),
                        child: AppButton(
                          onTap: () async {
                            if (_formKey.currentState!.validate()) {
                              _formKey.currentState?.save();
                              push(const TypeTitle());
                            }else{
                              print("Empty form");
                            }

                            // jump to main page instead
                            // await clickSignInByPhoneEmail(signInPhoneEmailController.text);
                            // infoIsPhone(signInPhoneEmailController.text);
                            // if(appStore.isLoading==false){
                            //   push(
                            //      CheckCode(
                            //         isPhone: isPhone, phoneOrEmailInfo: signInPhoneEmailController.text),
                            //   );
                            // }
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
                              style: const TextStyle(
                                color: Color.fromRGBO(53, 173, 225, 1.0),
                                fontWeight: FontWeight.bold,
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
