import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:flutter_verification_code_field/flutter_verification_code_field.dart';

import '../../dao/process_sign_in.dart';
import '../../main.dart';
import '../../modals/custom_app_bar.dart';
import '../../modals/image.dart';
import '../../modals/satetment_bottom.dart';
import '../../utils/colors.dart';
import 'check_estate_manager.dart';

class CheckCode extends StatefulWidget {
  final bool? isPhone;
  final String? phoneOrEmailInfo;

  const CheckCode({super.key, this.isPhone, this.phoneOrEmailInfo});

  @override
  State<CheckCode> createState() => _CheckCodeState();
}

class _CheckCodeState extends State<CheckCode> {
  TextEditingController checkCodePhoneEmailController = TextEditingController();
  TextEditingController checkCodeVerifyCodeController = TextEditingController();

  ProcessSignIn processSignIn = ProcessSignIn();

  @override
  void initState() {
    super.initState();
    checkCodePhoneEmailController.text = widget.phoneOrEmailInfo ?? '';
  }




  @override
  Widget build(BuildContext context) {
    double paddingSize = context.height()*0.01;
    return Scaffold(
      appBar:CustomAppBar(
        title: '',
        isDarkMode: appStore.isDarkMode,
      ),

      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding:  EdgeInsets.all(context.height()*0.01),
            child: Center(
              child: SizedBox(
                width: context.width() * 0.9,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    SizedBox(height: paddingSize),
                    // Logo pic
                    const Logo(),
                    SizedBox(height: context.height()*0.05),
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
                      padding:  EdgeInsets.all(paddingSize),
                      child: TextField(
                        controller: checkCodePhoneEmailController,
                        decoration: InputDecoration(
                          suffixIcon: Icon(Icons.edit),
                          hintText: widget.phoneOrEmailInfo,
                          border: OutlineInputBorder(
                            borderSide: const BorderSide(
                                color: Colors.black87, width: 1.0),
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                          prefixIcon: Icon(
                            widget.isPhone == true ? Icons.phone : Icons.email,
                            color: Colors.black87,
                          ),
                          contentPadding: EdgeInsets.symmetric(vertical: 13),
                        ),
                      ),
                    ),

                    Padding(
                      padding:  EdgeInsets.all(paddingSize),
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
                          // suffix: VerificationCodeField(
                          //   length: 6,
                          //   onFilled: (value) => print(value),
                          //   size: Size(30, 60),
                          //   spaceBetween: 16,
                          //   matchingPattern: RegExp(r'^\d+$'),
                          // ),
                          contentPadding:
                              EdgeInsets.fromLTRB(25.0, 15.0, 20.0, 15.0),
                        ),
                      ),
                    ),

                    Padding(
                      padding:  EdgeInsets.all(paddingSize),
                      child: AppButton(
                        onTap: () async {
                          // await processSignIn.verifyCredential(checkCodeVerifyCodeController.text);

                          print("appStore.verifyCode");
                          print(appStore.verifyCode);
                          print(checkCodeVerifyCodeController.text);
                          PhoneAuthCredential credential = PhoneAuthProvider.credential(verificationId: appStore.verifyCode, smsCode: checkCodeVerifyCodeController.text);


                          print("credential"+credential.toString());

                          await FirebaseAuth.instance.signInWithCredential(credential);

                          print("In ....");

                          if(appStore.isValidated) {
                            // appStore.setVerifyCode("");
                            push(const CheckEstateManager());
                          }
                        },
                        text: language.continueWord,
                        color: primaryColor,
                        textColor: Colors.white,
                        width: context.width(),
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
