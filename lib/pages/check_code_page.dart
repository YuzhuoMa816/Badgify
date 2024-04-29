import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:flutter_verification_code_field/flutter_verification_code_field.dart';

import '../main.dart';
import '../utils/colors.dart';

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

  @override
  void initState() {
    super.initState();
    checkCodePhoneEmailController.text = widget.phoneOrEmailInfo ?? '';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        systemOverlayStyle: SystemUiOverlayStyle(
            statusBarIconBrightness:
                appStore.isDarkMode ? Brightness.light : Brightness.dark,
            statusBarColor: context.scaffoldBackgroundColor),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
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
                      padding: const EdgeInsets.all(12.0),
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
                      padding: const EdgeInsets.all(12.0),
                      child: TextField(
                        controller: checkCodePhoneEmailController,
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
                          suffix: VerificationCodeField(
                            length: 6,
                            onFilled: (value) => print(value),
                            size: Size(30, 60),
                            spaceBetween: 16,
                            matchingPattern: RegExp(r'^\d+$'),
                          ),
                          contentPadding:
                              EdgeInsets.fromLTRB(25.0, 15.0, 20.0, 15.0),
                        ),
                      ),
                    ),

                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: AppButton(
                        onTap: () async {},
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
