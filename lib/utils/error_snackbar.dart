import 'package:flutter/material.dart';
import 'package:housemanagement/core/base_colors.dart';
import 'package:housemanagement/core/font_sizes.dart';

class ErrorSnackBar {
  static void showError(BuildContext context, String message) {
    final snackBar = SnackBar(
      content: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Flexible(
              child: Text(message.toString(),
                  style: const TextStyle(
                    fontSize: AppFontSizes.big,
                  )),
            ),
            const SizedBox(width: 20),
            InkWell(
              onTap: () {
                ScaffoldMessenger.of(context).removeCurrentSnackBar();
              },
              child: const Icon(Icons.close, color: AppBaseColors.whiteColor),
            )
          ]),
    );
    ScaffoldMessenger.of(context).removeCurrentSnackBar();
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }
}
