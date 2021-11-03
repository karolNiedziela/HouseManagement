import 'package:flutter/material.dart';

class ErrorSnackBar {
  static void showError(BuildContext context, String message) {
    final snackBar = SnackBar(
      content: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Flexible(
              child: Text(message.toString(),
                  style: const TextStyle(
                    fontSize: 17,
                  )),
            ),
            const SizedBox(width: 20),
            InkWell(
              onTap: () {
                ScaffoldMessenger.of(context).removeCurrentSnackBar();
              },
              child: const Icon(Icons.close, color: Colors.white),
            )
          ]),
    );
    ScaffoldMessenger.of(context).removeCurrentSnackBar();
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }
}
