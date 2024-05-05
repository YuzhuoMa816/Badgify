import 'package:flutter/material.dart';

import '../main.dart';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class PrivacyPolicyDialog extends StatefulWidget {
  @override
  _PrivacyPolicyDialogState createState() => _PrivacyPolicyDialogState();
}

class _PrivacyPolicyDialogState extends State<PrivacyPolicyDialog> {
  bool agreed = false;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('Privacy Policy'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Privacy policy text here...'),
          SizedBox(height: 10),
          Row(
            children: [
              Checkbox(
                value: agreed,
                onChanged: (value) {
                  setState(() {
                    agreed = value ?? false;
                  });
                },
              ),
              const Text('I agree', softWrap: true,),
            ],
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () {
            if (agreed) {
              Navigator.of(context).pop(true); // Returning true if user agreed
            } else {
              ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                content: Text(language.agreePolicyFirst),
              ));
            }
          },
          child: Text('OK'),
        ),
      ],
    );
  }
}

class AgreementModal {
  static void showAgreementDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          content: Text(language.agreementText),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text(language.close),
            ),
          ],
        );
      },
    );
  }

  static Future<bool> showPrivacyPolicyDialog(BuildContext context) async {
    return await showDialog<bool>(
      context: context,
      builder: (BuildContext context) {
        return PrivacyPolicyDialog();
      },
    ) ?? false;
  }

  static void showAgreePolicyDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          content: Text(language.agreePolicyFirst),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text(language.close),
            ),
          ],
        );
      },
    );
  }
}
