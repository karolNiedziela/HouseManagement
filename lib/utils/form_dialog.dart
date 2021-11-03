import 'package:flutter/material.dart';

class FormDialog {
  static void showFormDialog(
      {required BuildContext context,
      required List<Widget> formContent,
      required Key key,
      String? dialogHeader}) {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            scrollable: true,
            title: const Center(child: Text('Shopping list')),
            content: Form(
                key: key,
                child: Column(
                  children: formContent,
                )),
          );
        });
  }
}
