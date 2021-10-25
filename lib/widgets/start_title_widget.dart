import 'package:flutter/material.dart';

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
              color: Colors.indigo,
            ),
            Text('House',
                style: TextStyle(
                    fontFamily: 'Montserrat',
                    fontSize: 40,
                    fontWeight: FontWeight.bold,
                    color: Colors.indigo,
                    letterSpacing: 2)),
            Text('Management',
                style: TextStyle(
                    fontFamily: 'Montserrat',
                    fontSize: 40,
                    color: Colors.indigo,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 2)),
          ],
        ));
  }
}
