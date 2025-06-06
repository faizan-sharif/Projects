import 'package:flutter/widgets.dart';

class Responsiveness {
  static bool isSmallScreen(double width) {
    return width < 600;
  }

  static getWidth(BuildContext context) {
    return MediaQuery.of(context).size.width;
  }

  static getHeight(BuildContext context) {
    return MediaQuery.of(context).size.height;
  }
}
