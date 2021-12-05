import 'package:flutter/material.dart';
import 'package:housemanagement/core/light_theme_colors.dart';

class StartTitleWidget extends StatelessWidget {
  const StartTitleWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
        height: 250,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            Icon(
              Icons.home,
              size: 100.0,
              color: Theme.of(context).primaryColor,
            ),
            Text('House',
                style: TextStyle(
                    fontFamily: 'Montserrat',
                    fontSize: 40,
                    fontWeight: FontWeight.bold,
                    color: Theme.of(context).primaryColor,
                    letterSpacing: 2)),
            Text('Management',
                style: TextStyle(
                    fontFamily: 'Montserrat',
                    fontSize: 40,
                    color: Theme.of(context).primaryColor,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 2)),
          ],
        ));
  }
}
