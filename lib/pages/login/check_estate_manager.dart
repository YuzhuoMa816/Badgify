import 'package:badgify/pages/login/check_service_provider.dart';
import 'package:badgify/pages/login/select_agent_manager.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:nb_utils/nb_utils.dart';

import '../../main.dart';
import '../../modals/custom_app_bar.dart';
import '../../modals/image.dart';
import '../../modals/satetment_bottom.dart';
import '../../utils/colors.dart';

class CheckEstateManager extends StatefulWidget {
  const CheckEstateManager({Key? key}) : super(key: key);

  @override
  State<CheckEstateManager> createState() => _CheckEstateManagerState();
}

class _CheckEstateManagerState extends State<CheckEstateManager> {
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
                  Text(
                    language.areYouAgent,
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 15,
                    ),
                  ),
                  SizedBox(height: context.height() * 0.05),
                  Padding(
                    padding: EdgeInsets.all(paddingSize),
                    child: AppButton(
                      onTap: () async {
                        push(SelectRealEstate());
                      },
                      text: language.yes,
                      color: primaryColor,
                      textColor: Colors.white,
                      width: context.width(),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.all(paddingSize),
                    child: AppButton(
                      onTap: () async {
                        push(const CheckServiceProvider());
                      },
                      text: language.no,
                      color: Colors.white,
                      textColor: primaryColor,
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
