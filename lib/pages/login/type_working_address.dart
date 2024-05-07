import 'package:badgify/pages/login/collect_all_info.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:nb_utils/nb_utils.dart';

import '../../main.dart';
import '../../modals/custom_app_bar.dart';
import '../../modals/image.dart';
import '../../modals/satetment_bottom.dart';
import '../../utils/colors.dart';

class TypeWorkingAddress extends StatefulWidget {
  const TypeWorkingAddress({super.key});

  @override
  State<TypeWorkingAddress> createState() => _TypeWorkingAddressState();
}

class _TypeWorkingAddressState extends State<TypeWorkingAddress> {
  final GlobalKey<FormState> _typeWorkingAddressFormKey = GlobalKey<FormState>();
  TextEditingController workingPlaceController = TextEditingController();

  @override
  Widget build(BuildContext context) {

    double paddingSize = context.height() * 0.01;
    String? _workPlace;


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
              child: Form(
                key: _typeWorkingAddressFormKey,
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
                    TextFormField(
                      onChanged: (value) {
                        setState(() {
                          _workPlace = value;
                        });
                      },
                      controller: workingPlaceController,
                      decoration: InputDecoration(
                        hintText: language.lJHooker,
                        labelText: language.iWorkIn,
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
                          return language.pleaseEnterWorkPlace;
                        }
                        return null;
                      },
                    ),
                    SizedBox(height: context.height() * 0.1),
                    Padding(
                      padding: EdgeInsets.all(paddingSize),
                      child: AppButton(
                        onTap: () async {
                          if (_typeWorkingAddressFormKey.currentState!.validate()) {
                            appStore.userModel.agentWorkingCompany =
                                workingPlaceController.text;
                            push(const CollectAllInfo());
                          }else{
                            print("Empty form");
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
