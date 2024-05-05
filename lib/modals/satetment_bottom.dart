import 'package:badgify/modals/statement.dart';
import 'package:flutter/material.dart';

import '../main.dart';
import '../utils/colors.dart';

class InfoCollectionStatement extends StatefulWidget {
  const InfoCollectionStatement({Key? key}) : super(key: key);

  @override
  _InfoCollectionStatementState createState() => _InfoCollectionStatementState();
}

class _InfoCollectionStatementState extends State<InfoCollectionStatement> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Divider(
          color: Colors.grey,
          thickness: MediaQuery.of(context).size.height * 0.001,
          height: MediaQuery.of(context).size.height * 0.05,
          indent: 0.0,
          endIndent: 0.0,
        ),
        Center(
          child: GestureDetector(
            onTap: () {
              AgreementModal.showAgreementDialog(context);
            },
            child: Text(
              language.infoCollectionStatement,
              style: TextStyle(fontSize: 10.0, color: primaryColor),
            ),
          ),
        ),
      ],
    );
  }
}
