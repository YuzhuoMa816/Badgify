


class PhoneNumberFormatter {
  String formatAUPhoneNumber(String phoneNumber) {
    phoneNumber = phoneNumber.replaceAll(' ', '');

    if (phoneNumber.startsWith('0')) {
      phoneNumber = '+61' + phoneNumber.substring(1);
    }
    if (phoneNumber.startsWith('61')) {
      phoneNumber = '+' + phoneNumber;
    }

    return phoneNumber;
  }
}
