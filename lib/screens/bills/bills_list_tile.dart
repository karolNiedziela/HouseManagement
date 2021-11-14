import 'package:flutter/material.dart';
import 'package:housemanagement/models/bill.dart';
import 'package:housemanagement/widgets/popup_menu_widget.dart';

class BillsListTile extends StatefulWidget {
  final Bill bill;

  const BillsListTile({Key? key, required this.bill}) : super(key: key);

  @override
  _BillsListTileState createState() => _BillsListTileState();
}

class _BillsListTileState extends State<BillsListTile> {
  @override
  Widget build(BuildContext context) {
    return Card(
      color: widget.bill.isPaid ? Colors.indigo[100] : null,
      child: ListTile(
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[..._buildColumnInListView(widget.bill)],
        ),
        trailing: PopupMenuWidget(
          additionalPopupMenuItems: [
            AdditionalPopupMenuItem(onTap: () {}, text: 'Zapłać')
          ],
        ),
      ),
    );
  }

  List<Widget> _buildColumnInListView(Bill bill) {
    var widgets = <Widget>[];
    if (bill.isPaid) {
      widgets.add(Text(bill.name,
          style: const TextStyle(decoration: TextDecoration.lineThrough)));
      widgets.add(Text(bill.amount.toString(),
          style: const TextStyle(decoration: TextDecoration.lineThrough)));

      return widgets;
    }

    widgets.add(Text(bill.name));
    widgets.add(Text(bill.amount.toString()));

    return widgets;
  }
}
