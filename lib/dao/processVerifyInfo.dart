import 'dart:async';
import 'dart:ui';

class Verity{

  // 0 for invalid, 1 for phone, 2 for Email
  int checkPhoneOrEmail(String inputText){
    if (inputText.contains('@') && inputText.contains('.')){
      return 2;
    }else if(checkAUPhoneIsValid(inputText)){
      return 1;
    }
    return 0;
  }



  bool checkAUPhoneIsValid(String inputText) {
    if (inputText.isEmpty) {
      return false;
    }
    // remove space
    inputText = inputText.replaceAll(' ', '');

    if(inputText.contains(RegExp(r'[^0-9+]'))){
      return false;
    }

    // only store in +61 format
    if (inputText.startsWith('+61')){
      inputText = inputText.replaceAll(RegExp(r'\D'), '');
      if (inputText.length == 12){
        return true;
      }
    }
    if(inputText.startsWith('0')){
      if (inputText.length == 10){
        return true;
      }
    }
    if (inputText.startsWith('61')){
      if (inputText.length == 11){
        return true;
      }
    }

    return false;
  }

}

