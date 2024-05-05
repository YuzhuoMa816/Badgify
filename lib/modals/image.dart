import 'package:flutter/cupertino.dart';
import 'package:nb_utils/nb_utils.dart';

class Logo extends StatelessWidget {
  const Logo({super.key});


  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;

    double logoHeight = screenWidth * 0.15; // 15% of screen width
    double logoWidth = screenWidth * 0.25; // 25% of screen width

    return Image.asset(
      'assets/badgify_logo_long.png',
      height: logoHeight,
      width: logoWidth,
    );
  }


}


class BottomImage extends StatelessWidget {
  final String imagePath;

  const BottomImage({
    required this.imagePath,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Image.asset(
      imagePath,
      height: context.height()*0.23,
      width: context.width(),
      fit: BoxFit.fitWidth,
    );
  }

}
