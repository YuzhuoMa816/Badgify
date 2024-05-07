import 'package:badgify/pages/login/sign_in_page.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:nb_utils/nb_utils.dart';

import '../../dao/process_sign_in.dart';
import '../../main.dart';
import '../../modals/custom_app_bar.dart';
import '../../modals/image.dart';
import '../../utils/colors.dart';
import '../../utils/normalise_phone_number.dart';
import 'check_code_page.dart';

class CollectAllInfo extends StatefulWidget {
  const CollectAllInfo({super.key});

  @override
  State<CollectAllInfo> createState() => _CollectAllInfoState();
}

class _CollectAllInfoState extends State<CollectAllInfo> {
  final GlobalKey<FormState> _createAccountFormKey = GlobalKey<FormState>();
  ProcessSignIn processSignIn = ProcessSignIn();
  late String preWriteEmail;


  @override
  void initState() {
    super.initState();

  }

  TextEditingController phoneNumController = TextEditingController();
  TextEditingController firstNameTextController = TextEditingController();
  TextEditingController lastNameTextController = TextEditingController();


  Future<void> handleAllInfoSubmit(String firstNamePara, String lastNamePara, String phoneNumPara) async {
    // verify phone first
    if(processSignIn.verifyPhone(phoneNumPara)==false){
      ScaffoldMessenger.of(context).showSnackBar( SnackBar(
          content: Text(language.invalidPhone)));
    }

    // format phone
    String phoneNum = PhoneNumberFormatter.formatAUPhoneNumber(phoneNumPara);


    // Store the info
    appStore.userModel.firstName = firstNamePara;
    appStore.userModel.lastName = lastNamePara;
    appStore.userModel.phoneNumber = phoneNum;

    // check current phone is already under the system, if true back to signin
    if (await processSignIn
        .verifyIsSystemUser(phoneNum)) {
      ScaffoldMessenger.of(context).showSnackBar( SnackBar(
          content: Text(language.alreadyHaveAccount
              )));
      await push(const SignIn(),
          isNewTask: true);
      return;
    }else {
      await processSignIn.phoneSendCodeSignin(context, phoneNum);
      // update the page state
      setState(() {});
      if (appStore.isLoading == false) {
        push(const CheckCode());
      }
    }
  }


    @override
  Widget build(BuildContext context) {
    double paddingSize = context.height() * 0.01;
    String? _firstName;
    String? _lastName;
    String? _phoneNumber;
    String? _email;

    Widget customTextForm(
        TextEditingController? textController,
        String hintText,
        String labelText,
        String validatorText,
        String onChangedValue) {
      return TextFormField(
        onChanged: (value) {
          setState(() {
            onChangedValue = value;
          });
        },
        controller: textController,
        decoration: InputDecoration(
          hintText: hintText,
          labelText: labelText,
          border: const OutlineInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(10)),
            borderSide: BorderSide(
              color: Colors.red,
              width: 2.0,
            ),
          ),
        ),
        validator: (value) {
          if (value == null || value.isEmpty) {
            return validatorText;
          }

          return null;
        },
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
                              key: _createAccountFormKey,
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
                                        firstNameTextController,
                                        language.firstNameExample,
                                        language.firstName,
                                        language.pleaseEnterFirstName,
                                        "Yuzhuo"),
                                    SizedBox(height: context.height() * 0.03),
                                    customTextForm(
                                        lastNameTextController,
                                        language.lastNameExample,
                                        language.lastName,
                                        language.pleaseEnterLastName,
                                        "Yuzhuo"),
                                    SizedBox(height: context.height() * 0.03),
                                    customTextForm(
                                        phoneNumController,
                                        language.phoneNumberExample,
                                        language.phoneNumber,
                                        language.pleaseEnterPhoneNum,
                                        "Yuzhuo"),
                                    SizedBox(height: context.height() * 0.03),


                                    Padding(
                                      padding: EdgeInsets.all(paddingSize),
                                      child: AppButton(
                                        onTap: () async {
                                          if (_createAccountFormKey
                                              .currentState!
                                              .validate()) {

                                            await handleAllInfoSubmit(
                                                firstNameTextController.text,
                                              lastNameTextController.text,
                                              phoneNumController.text
                                            );
                                          }
                                        },
                                        text: language.continueWord,
                                        color: primaryColor,
                                        textColor: Colors.white,
                                        width: context.width(),
                                      ),
                                    ),
                                  ]))))))),
    );
  }
}
