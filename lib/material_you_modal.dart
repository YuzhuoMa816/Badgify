
import 'dart:ui';
import 'package:badgify/main.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:badgify/utils/config.dart';
import 'package:badgify/utils/colors.dart';


Future<Color> getMaterialYouData() async {
  if (appStore.useMaterialYouTheme && await isAndroid12Above()) {
    primaryColor = await getMaterialYouPrimaryColor();
  } else {
    primaryColor = defaultPrimaryColor;
  }

  return primaryColor;
}
