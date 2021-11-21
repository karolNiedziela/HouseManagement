import 'package:flutter/material.dart';
import 'package:housemanagement/core/colors.dart';

class StartTitleWidget extends StatelessWidget {
  const StartTitleWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
        height: 250,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: const <Widget>[
            Icon(
              Icons.home,
              size: 100.0,
              color: AppColors.primaryColor,
            ),
            Text('House',
                style: TextStyle(
                    fontFamily: 'Montserrat',
                    fontSize: 40,
                    fontWeight: FontWeight.bold,
                    color: AppColors.primaryColor,
                    letterSpacing: 2)),
            Text('Management',
                style: TextStyle(
                    fontFamily: 'Montserrat',
                    fontSize: 40,
                    color: AppColors.primaryColor,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 2)),
          ],
        ));
  }
}
