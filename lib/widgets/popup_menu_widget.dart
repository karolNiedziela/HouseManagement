import 'package:flutter/material.dart';
import 'package:housemanagement/utils/form_dialog.dart';

class PopupMenuWidget extends StatefulWidget {
  final VoidCallback? editAction;
  final bool isEditVisible;
  final VoidCallback? deleteAction;
  final List<AdditionalPopupMenuItem>? additionalPopupMenuItems;
  final bool isAppBar;
  const PopupMenuWidget(
      {Key? key,
      this.editAction,
      this.isEditVisible = true,
      this.deleteAction,
      this.additionalPopupMenuItems,
      this.isAppBar = false})
      : super(key: key);

  @override
  _PopupMenuWidgetState createState() => _PopupMenuWidgetState();
}

class _PopupMenuWidgetState extends State<PopupMenuWidget> {
  @override
  Widget build(BuildContext context) {
    return PopupMenuButton(
      icon: widget.isAppBar
          ? const Icon(
              Icons.more_vert,
              color: Colors.white,
            )
          : Icon(Icons.more_vert,
              color: Theme.of(context).textTheme.bodyText1!.color),
      itemBuilder: (context) => <PopupMenuEntry>[
        ...getAdditionalItems(),
        ...getDefaultMenuItems(),
      ],
    );
  }

  List<PopupMenuItem> getDefaultMenuItems() {
    var defaultPopupMenuItems = <PopupMenuItem>[];
    if (widget.isEditVisible) {
      defaultPopupMenuItems.add(PopupMenuItem(
          child: const Text('Edytuj'),
          onTap: () {
            Future<void>.delayed(
                const Duration(), () => widget.editAction!.call());
          }));
    }

    defaultPopupMenuItems.add(PopupMenuItem(
      child: const Text('Usuń'),
      onTap: () {
        Future<void>.delayed(
            const Duration(),
            () => FormDialog.showConfirmDeleteDialog(
                context: context, onYesPressed: widget.deleteAction!));
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
