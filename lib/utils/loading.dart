import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:housemanagement/core/colors.dart';

class Loading extends StatelessWidget {
  const Loading({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
        color: AppColors.primaryColor,
        child: const Center(
            child:
                SpinKitThreeBounce(color: AppColors.whiteColor, size: 50.0)));
  }
}
