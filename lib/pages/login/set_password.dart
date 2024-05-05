import 'package:badgify/pages/login/check_code_page.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:nb_utils/nb_utils.dart';

import '../../api/firebase/phone_email_verify.dart';
import '../../dao/process_sign_in.dart';
import '../../main.dart';
import '../../modals/custom_app_bar.dart';
import '../../modals/image.dart';
import '../../utils/colors.dart';

class SetPassword extends StatefulWidget {
  const SetPassword({super.key});

  @override
  State<SetPassword> createState() => _SetPasswordState();
}

class _SetPasswordState extends State<SetPassword> {
  final GlobalKey<FormState> _setPasswordKey = GlobalKey<FormState>();
  ProcessSignIn processSignIn = ProcessSignIn();

  FirebaseVerify firebaseVerify = FirebaseVerify();

  TextEditingController passwordController = TextEditingController();
  TextEditingController repeatPasswordController = TextEditingController();

  String? validatePassword(String? value) {
    if (value == null || value.isEmpty) {
      return language.passwordNotEmpty;
    } else if (value.length < 8 || value.length > 16) {
      return 'Password must be between 8 and 16 characters';
    }
    return null;
  }

  String? validateRepeatPassword(String? value) {
    if (value != passwordController.text) {
      return 'Passwords do not match';
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    double paddingSize = context.height() * 0.01;

    Widget customTextForm(TextEditingController? textController,
        String labelText, String validatorText, String? Function(String?) validator, String onChangedValue) {
      return TextFormField(
        onChanged: (value) {
          setState(() {
            onChangedValue = value;
          });
        },
        obscureText: true,
        controller: textController,
        decoration: InputDecoration(
          labelText: labelText,
          border: const OutlineInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(10)),
            borderSide: BorderSide(
              color: Colors.red,
              width: 2.0,
            ),
          ),
        ),
        validator:  validator ,
      );
    }

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
                                key: _setPasswordKey,
                                child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.stretch,
                                    children: [
                                      SizedBox(height: paddingSize),
                                      const Logo(),
                                      SizedBox(height: context.height() * 0.05),
                                      Text(
                                        language.createAccount,
                                        textAlign: TextAlign.center,
                                        style: const TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 24,
                                        ),
                                      ),
                                      SizedBox(height: context.height() * 0.03),
                                      customTextForm(
                                          passwordController,
                                          language.password,
                                          language.passwordNotEmpty,
                                          validatePassword,
                                          "Yuzhuo"),
                                      SizedBox(height: context.height() * 0.03),
                                      customTextForm(
                                          repeatPasswordController,
                                          language.repeatPassword,
                                          language.passwordNotEmpty,
                                          validateRepeatPassword,

                                          "Yuzhuo"),
                                      SizedBox(height: context.height() * 0.03),
                                      Text(
                                        language.passwordRule,
                                        textAlign: TextAlign.center,
                                        style: const TextStyle(
                                          fontSize: 10,
                                        ),
                                      ),
                                      SizedBox(height: context.height() * 0.03),
                                      SizedBox(height: context.height() * 0.03),

                                      Padding(
                                        padding: EdgeInsets.all(paddingSize),
                                        child: AppButton(
                                          onTap: () async{
                                            if (_setPasswordKey.currentState!.validate()) {
                                              print("in firebaseVerify.emailPasswordLogin ");
                                              print(appStore.userModel.email);
                                              print(passwordController.text);

                                              await firebaseVerify.emailPasswordSignIn(appStore.userModel.email, passwordController.text );
                                              // send the verify code
                                              await processSignIn.processPhoneOrEmailSignIn(context, appStore.userModel.phoneNumber);
                                              // update the page state
                                              setState(() {});
                                              if (appStore.isLoading == false) {
                                                print("Pass");
                                                push(CheckCode());
                                              }

                                            }
                                          },
                                          text: language.continueWord,
                                          color: primaryColor,
                                          textColor: Colors.white,
                                          width: context.width(),
                                        ),
                                      )
                                    ]))))))));
  }
}
