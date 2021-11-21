import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:housemanagement/core/colors.dart';

class LoadingElement extends StatelessWidget {
  const LoadingElement({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const Center(
        child: SpinKitThreeBounce(color: AppColors.primaryColor, size: 50.0));
  }
}
