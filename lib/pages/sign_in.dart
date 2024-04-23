import 'package:badgify/main.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:nb_utils/nb_utils.dart';

import '../utils/colors.dart';

class SignIn extends StatefulWidget {
  const SignIn({super.key});

  @override
  State<SignIn> createState() => _SignInState();
}

Color getHighContrastColor() {
  return Color.alphaBlend(Colors.white.withOpacity(0.3), Colors.transparent)
              .computeLuminance() >
          0.5
      ? Colors.black
      : Colors.white;
}

Color highContrastColor = getHighContrastColor();

Widget buildButton(String buttonText) {
  return Container(
    decoration: BoxDecoration(
      border: Border.all(color: Colors.black),
      borderRadius: BorderRadius.circular(5),
    ),
    child: AppButton(
      onTap: () {},
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

class _SignInState extends State<SignIn> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
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
                  const SizedBox(height: 40),

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
                      onTap: () {},
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
                  buildButton(language.continueWithGoogle),
                  const SizedBox(height: 6),

                  buildButton(language.continueWithFb),
                  const SizedBox(height: 6),
                  buildButton(language.continueWithApple),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
