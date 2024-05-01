import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:nb_utils/nb_utils.dart';

import '../../dao/process_sign_in.dart';
import '../../main.dart';
import '../../modals/custom_app_bar.dart';
import '../../modals/image.dart';
import '../../utils/colors.dart';
import 'check_code_page.dart';

class CollectAllInfo extends StatefulWidget {
  const CollectAllInfo({super.key});

  @override
  State<CollectAllInfo> createState() => _CollectAllInfoState();
}

class _CollectAllInfoState extends State<CollectAllInfo> {

  TextEditingController phoneNumController = TextEditingController();
  ProcessSignIn processSignIn = ProcessSignIn();


  Future<void> clickSignInByPhoneEmail(textInfo) async {

    await processSignIn.processPhoneOrEmail(context, textInfo);
    // update the page state
    setState(() {
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
                                TextField(
                                  decoration: InputDecoration(
                                    hintText: language.firstNameExample,
                                    labelText: language.firstName,
                                    border: const OutlineInputBorder(
                                      borderRadius: BorderRadius.all(Radius.circular(10)),
                                      borderSide: BorderSide(
                                        color: Colors.red,
                                        width: 2.0,
                                      ),
                                    ),

                                  ),
                                ),
                                SizedBox(height: context.height() * 0.03),

                                TextField(
                                  decoration: InputDecoration(
                                    hintText: language.lastNameExample,
                                    labelText: language.lastName,
                                    border: const OutlineInputBorder(
                                      borderRadius: BorderRadius.all(Radius.circular(10)),
                                      borderSide: BorderSide(
                                        color: Colors.red,
                                        width: 2.0,
                                      ),
                                    ),
                                  ),
                                ),
                                SizedBox(height: context.height() * 0.03),

                                TextField(
                                  controller: phoneNumController,
                                  decoration: InputDecoration(
                                    hintText: language.phoneNumberExample,
                                    labelText: language.phoneNumber,
                                    border: const OutlineInputBorder(
                                      borderRadius: BorderRadius.all(Radius.circular(10)),
                                      borderSide: BorderSide(
                                        color: Colors.red,
                                        width: 2.0,
                                      ),
                                    ),
                                    suffixIcon: Icon(Icons.call),
                                  ),
                                ),
                                SizedBox(height: context.height() * 0.03),
                                TextField(
                                  decoration: InputDecoration(
                                    hintText: language.emailExample,
                                    labelText: language.email,
                                    border: const OutlineInputBorder(
                                      borderRadius: BorderRadius.all(Radius.circular(10)),
                                      borderSide: BorderSide(
                                        color: Colors.red,
                                        width: 2.0,
                                      ),
                                    ),
                                    suffixIcon: Icon(Icons.mail),
                                  ),
                                ),
                                SizedBox(height: context.height() * 0.03),
                                Padding(
                                  padding: EdgeInsets.all(paddingSize),
                                  child: AppButton(
                                    onTap: () async {
                                      await clickSignInByPhoneEmail(phoneNumController.text);

                                      if(appStore.isLoading==false){
                                        push(
                                          CheckCode(
                                              isPhone: true, phoneOrEmailInfo: phoneNumController.text),
                                        );
                                      }

                                    },
                                    text: language.continueWord,
                                    color: primaryColor,
                                    textColor: Colors.white,
                                    width: context.width(),
                                  ),
                                ),





                              ])))))),
    );
  }
}
