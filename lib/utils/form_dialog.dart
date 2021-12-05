import 'package:flutter/material.dart';

class FormDialog {
  static void showFormDialog(
      {required BuildContext context,
      required List<Widget> formContent,
      required Key key,
      required String dialogHeader}) {
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            backgroundColor: Theme.of(context).scaffoldBackgroundColor,
            scrollable: true,
            title: Center(
                child: Text(
              dialogHeader,
              style: TextStyle(
                  color: Theme.of(context).textTheme.bodyText1!.color),
            )),
            content: Form(
                key: key,
                child: Column(
                  children: formContent,
                )),
          );
        });
  }

  static void showConfirmDeleteDialog(
      {required BuildContext context,
      Function? onYesPressed,
      String text = ''}) {
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            backgroundColor: Theme.of(context).scaffoldBackgroundColor,
            title: Text('Potwierdź',
                style: TextStyle(
                    color: Theme.of(context).textTheme.bodyText1!.color)),
            content: text.isEmpty
                ? Text('Jesteś pewien, że chcesz usunąć?',
                    style: TextStyle(
                        color: Theme.of(context).textTheme.bodyText1!.color))
                : Text(text,
                    style: TextStyle(
                        color: Theme.of(context).textTheme.bodyText1!.color)),
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
                    style: TextStyle(color: Colors.red),
                  )),
              TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: const Text(
                    'Nie',
                  ))
            ],
          );
        });
  }
}
