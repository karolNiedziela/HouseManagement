import 'package:flutter/material.dart';
import 'package:housemanagement/utils/form_dialog.dart';

class TrailingPopupMenuWidget extends StatefulWidget {
  final Function? editAction;
  final Function? deleteAction;
  const TrailingPopupMenuWidget({Key? key, this.editAction, this.deleteAction})
      : super(key: key);

  @override
  _TrailingPopupMenuWidgetState createState() =>
      _TrailingPopupMenuWidgetState();
}

class _TrailingPopupMenuWidgetState extends State<TrailingPopupMenuWidget> {
  @override
  Widget build(BuildContext context) {
    return PopupMenuButton(
      itemBuilder: (context) => <PopupMenuEntry>[
        const PopupMenuItem(child: Text('Edytuj')),
        PopupMenuItem(
          child: const Text('Usuń'),
          onTap: () {
            Future<void>.delayed(
                const Duration(),
                () => FormDialog.showConfirmDeleteDialog(
                    context: context, onYesPressed: widget.deleteAction));
          },
        )
      ],
    );
  }
}
