import 'package:badgify/pages/login/collect_all_info.dart';
import 'package:badgify/pages/login/type_title.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:nb_utils/nb_utils.dart';

import '../../main.dart';
import '../../modals/image.dart';
import '../../modals/radio_button.dart';
import '../../modals/satetment_bottom.dart';
import '../../utils/colors.dart';

class SelectServiceProvider extends StatefulWidget {
  const SelectServiceProvider({super.key});

  @override
  State<SelectServiceProvider> createState() => _SelectServiceProviderState();
}

class _SelectServiceProviderState extends State<SelectServiceProvider> {
  @override
  Widget build(BuildContext context) {
    String selectedOption = language.photographer;
    double paddingSize = context.height() * 0.01;

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: ()  {
            appStore.userModel.serviceProviderOccupation = '';
            Navigator.of(context).pop();

          },
        ),
        title: const Text(''),
        centerTitle: true,
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
                    padding: EdgeInsets.all(0),
                    child: RadioButtonGroup<String>(
                      options: [
                        language.photographer,
                        language.homeStylist,
                        language.other
                      ],
                      selectedOption: language.photographer,
                      onChanged: (value) {
                        selectedOption = value;
                      },
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.all(paddingSize),
                    child: AppButton(
                      onTap: () async {
                        if (selectedOption == "other") {
                          push(const TypeTitle());
                        } else {
                          appStore.userModel.serviceProviderOccupation = selectedOption;
                          push(const CollectAllInfo());
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
      bottomNavigationBar: const Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          BottomImage(
            imagePath: 'assets/signin_pic2.png',
          ),
          InfoCollectionStatement(),
        ],
      ),
    );
  }
}
