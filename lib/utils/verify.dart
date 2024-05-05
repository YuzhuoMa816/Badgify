class VerifyValidate {
  // 0 for invalid, 1 for phone, 2 for Email
  String checkPhoneOrEmail(String inputText) {
    if (inputText.contains('@') && inputText.contains('.')) {
      return "Email";
    } else if (checkAUPhoneIsValid(inputText)) {
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

  String reformatPhone(String inputText) {
    // remove space
    inputText = inputText.replaceAll(' ', '');

    // after the checkAUPhoneIsValid, phone format can only start with 61, 0, +61
    if (inputText.startsWith('0')) {
      return "+61${inputText.substring(1)}";
    } else if (inputText.startsWith('61')) {
      return "+$inputText";
    }
    return inputText;
  }
}
