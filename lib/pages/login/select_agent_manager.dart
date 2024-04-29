import 'package:badgify/pages/login/type_working_address.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:nb_utils/nb_utils.dart';

import '../../main.dart';
import '../../modals/custom_app_bar.dart';
import '../../modals/image.dart';
import '../../modals/radio_button.dart';
import '../../modals/satetment_bottom.dart';
import '../../utils/colors.dart';

class SelectRealEstate extends StatefulWidget {
  const SelectRealEstate({super.key});

  @override
  State<SelectRealEstate> createState() => _SelectRealEstateState();
}

class _SelectRealEstateState extends State<SelectRealEstate> {
  @override
  Widget build(BuildContext context) {
    double paddingSize = context.height() * 0.01;

    return Scaffold(
      appBar: CustomAppBar(
        title: '',
        isDarkMode: appStore.isDarkMode,
      ),
      body: SingleChildScrollView(
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

                  Padding(
                    padding:  EdgeInsets.all(0),
                    child: RadioButtonGroup<String>(
                      options: [language.realEstateAgent, language.propertyManager],
                      selectedOption: language.realEstateAgent,
                      onChanged: (value) {
                        print('Selected option: $value');
                      },
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.all(paddingSize),
                    child: AppButton(
                      onTap: () async {
                        push(TypeWorkingAddress());
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
      bottomNavigationBar: const Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          BottomImage(
            imagePath: 'assets/signin_pic1.png',
          ),
          InfoCollectionStatement(),
        ],
      ),
    );
  }
}
