//
// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';
//
// class CustomTextField extends StatelessWidget {
//   const CustomTextField({super.key});
//
//   final FocusNode textFieldFocusNode;
//
//
//   @override
//   Widget build(BuildContext context) {
//     return TextFormField(
//       onTap: () {
//         textFieldFocusNode.requestFocus();
//       },
//       onChanged: (value) {
//         setState(() {
//           _phoneEmail = value;
//         });
//       },
//       controller: signInPhoneEmailController,
//       decoration: InputDecoration(
//         hintText: language.enterYourPhoneEmail,
//         border: OutlineInputBorder(
//           borderSide: const BorderSide(
//               color: Colors.black87, width: 1.0),
//           borderRadius: BorderRadius.circular(10.0),
//         ),
//       ),
//       validator: (value) {
//         if (value == null || value.isEmpty) {
//           print("Empty!!!");
//           return "input the email or phone number";
//         }
//         return null;
//       },
//       onSaved: (value) {
//         _phoneEmail = value;
//       },
//     );
//   }
// }
