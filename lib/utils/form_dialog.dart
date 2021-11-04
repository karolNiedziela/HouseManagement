import 'package:flutter/material.dart';

class FormDialog {
  static void showFormDialog(
      {required BuildContext context,
      required List<Widget> formContent,
      required Key key,
      required String dialogHeader}) {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            scrollable: true,
            title: Center(child: Text(dialogHeader)),
            content: Form(
                key: key,
                child: Column(
                  children: formContent,
                )),
          );
        });
  }

  static void showConfirmDeleteDialog(
      {required BuildContext context, Function? onYesPressed}) {
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: const Text('Potwierdź'),
            content: const Text('Jesteś pewien, że chcesz usunąć?'),
            actions: [
              TextButton(
                  onPressed: () {
                    if (onYesPressed != null) {
                      onYesPressed.call();
                    }
                    Navigator.of(context).pop();
                  },
                  child: const Text(
                    'Tak',
                    style: TextStyle(color: Colors.red, fontSize: 15),
                  )),
              TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: const Text(
                    'Nie',
                    style: TextStyle(fontSize: 15),
                  ))
            ],
          );
        });
  }
}
