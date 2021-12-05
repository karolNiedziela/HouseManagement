import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:housemanagement/core/base_colors.dart';
import 'package:housemanagement/core/light_theme_colors.dart';

class Loading extends StatelessWidget {
  const Loading({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
        color: AppLightThemeColors.primaryColor,
        child: const Center(
            child: SpinKitThreeBounce(
                color: AppBaseColors.whiteColor, size: 50.0)));
  }
}
