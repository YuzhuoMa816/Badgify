import 'package:flutter/material.dart';

import '../main.dart';
class AgreementModal{
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
}
