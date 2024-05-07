import 'package:badgify/pages/login/select_service_provider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:nb_utils/nb_utils.dart';

import '../../main.dart';
import '../../modals/custom_app_bar.dart';
import '../../modals/image.dart';
import '../../modals/satetment_bottom.dart';
import '../../utils/colors.dart';
import 'collect_all_info.dart';

class CheckServiceProvider extends StatefulWidget {
  const CheckServiceProvider({super.key});

  @override
  State<CheckServiceProvider> createState() => _CheckServiceProviderState();
}

class _CheckServiceProviderState extends State<CheckServiceProvider> {
  @override
  Widget build(BuildContext context) {
    double paddingSize = context.height() * 0.01;

    return Scaffold(
          appBar: AppBar(
            leading: IconButton(
              icon: const Icon(Icons.arrow_back),
              onPressed: ()  {
                appStore.userModel.isServiceProvider = false;
                Navigator.of(context).pop();

              },
            ),
            title: const Text(''),
            centerTitle: true,
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
                          // Logo pic
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
                            language.areYouSerPro,
                            textAlign: TextAlign.center,
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 15,
                            ),
                          ),
                          Text(
                            language.workSpecies,
                            textAlign: TextAlign.center,
                            style: const TextStyle(
                              fontSize: 12,
                            ),
                          ),
                          SizedBox(height: context.height() * 0.05),
                          Padding(
                            padding: EdgeInsets.all(paddingSize),
                            child: AppButton(
                              onTap: () async {
                                appStore.userModel.isServiceProvider=true;
                                push(SelectServiceProvider());
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
                                appStore.userModel.isServiceProvider=false;
                                push(const CollectAllInfo());
                              },
                              text: language.no,
                              color: Colors.white,
                              textColor: primaryColor,
                              width: context.width(),
                            ),
                          ),
                          SizedBox(height: context.height() * 0.01),
                          const BottomImage(
                            imagePath: 'assets/signin_pic2.png',
                          ),

                          const InfoCollectionStatement(),
                        ],
                      ),
                    ))),
          ),
        ));
  }
}
