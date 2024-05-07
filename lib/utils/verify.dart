class VerifyValidate {

  String checkValidPhone(String inputText) {
    if (checkAUPhoneIsValid(inputText)) {
      return "Phone";
    }
    return "Invalid";
  }

  bool checkAUPhoneIsValid(String inputText) {
    if (inputText.isEmpty) {
      return false;
    }
    // remove space
    inputText = inputText.replaceAll(' ', '');

    if (inputText.contains(RegExp(r'[^0-9+]'))) {
      return false;
    }

    // only store in +61 format
    if (inputText.startsWith('+61')) {
      inputText = inputText.replaceAll(RegExp(r'\D'), '');
      if (inputText.length == 12) {
        return true;
      }
    }
    if (inputText.startsWith('0')) {
      if (inputText.length == 10) {
        return true;
      }
    }
    if (inputText.startsWith('61')) {
      if (inputText.length == 11) {
        return true;
      }
    }

    return false;
  }

}
