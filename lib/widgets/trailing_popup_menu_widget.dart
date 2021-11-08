import 'package:flutter/material.dart';
import 'package:housemanagement/utils/form_dialog.dart';

class TrailingPopupMenuWidget extends StatefulWidget {
  final List<AdditionalPopupMenuItem>? additionalPopupMenuItems;
  final Function? editAction;
  final bool isEditVisible;
  final Function? deleteAction;
  const TrailingPopupMenuWidget(
      {Key? key,
      this.editAction,
      this.isEditVisible = true,
      this.deleteAction,
      this.additionalPopupMenuItems})
      : super(key: key);

  @override
  _TrailingPopupMenuWidgetState createState() =>
      _TrailingPopupMenuWidgetState();
}

class _TrailingPopupMenuWidgetState extends State<TrailingPopupMenuWidget> {
  @override
  Widget build(BuildContext context) {
    return PopupMenuButton(
      itemBuilder: (context) =>
          <PopupMenuEntry>[...getDefaultMenuItems(), ...getAdditionalItems()],
    );
  }

  List<PopupMenuItem> getDefaultMenuItems() {
    var defaultPopupMenuItems = <PopupMenuItem>[];
    if (widget.isEditVisible) {
      defaultPopupMenuItems.add(PopupMenuItem(
          child: const Text('Edytuj'),
          onTap: () =>
           widget.editAction
          ));
    }

    defaultPopupMenuItems.add(PopupMenuItem(
      child: const Text('Usuń'),
      onTap: () {
        Future<void>.delayed(
            const Duration(),
            () => FormDialog.showConfirmDeleteDialog(
                context: context, onYesPressed: widget.deleteAction));
      },
    ));

    return defaultPopupMenuItems;
  }

  List<PopupMenuItem> getAdditionalItems() {
    if (widget.additionalPopupMenuItems != null) {
      return widget.additionalPopupMenuItems!
          .map((additionalPopupMenuItem) => PopupMenuItem(
                child: Text(additionalPopupMenuItem.text),
                onTap: () {
                  Future<void>.delayed(const Duration(),
                      () => additionalPopupMenuItem.onTap.call());
                },
              ))
          .toList();
    }

    return <PopupMenuItem>[];
  }
}

class AdditionalPopupMenuItem {
  final Function() onTap;
  final String text;

  AdditionalPopupMenuItem({required this.onTap, required this.text});
}
