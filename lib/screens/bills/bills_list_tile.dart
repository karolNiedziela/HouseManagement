import 'package:flutter/material.dart';
import 'package:housemanagement/core/colors.dart';
import 'package:housemanagement/models/bill.dart';
import 'package:housemanagement/services/bills_service.dart';
import 'package:housemanagement/utils/form_dialog.dart';
import 'package:housemanagement/widgets/popup_menu_widget.dart';
import 'package:intl/intl.dart';

class BillsListTile extends StatefulWidget {
  final Bill bill;

  const BillsListTile({Key? key, required this.bill}) : super(key: key);

  @override
  _BillsListTileState createState() => _BillsListTileState();
}

class _BillsListTileState extends State<BillsListTile> {
  final BillsService _billsService = BillsService();

  @override
  Widget build(BuildContext context) {
    return Card(
      color: widget.bill.isPaid ? AppColors.primaryColorLight : null,
      child: ListTile(
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[..._buildColumnInListView(widget.bill)],
        ),
        subtitle: Text(DateFormat("EEEE, dd MMMM, yyyy", 'pl_PL')
            .format(widget.bill.dateOfPayment)),
        trailing: PopupMenuWidget(
          deleteAction: () async {
            await _billsService.deleteBill(widget.bill.key);
            setState(() {});
          },
          additionalPopupMenuItems: [
            AdditionalPopupMenuItem(
                onTap: () {
                  FormDialog.showConfirmDeleteDialog(
                      context: context,
                      onYesPressed: () async {
                        await _billsService.payBill(widget.bill.key);
                      },
                      text: "Czy na pewno chcesz zmienić status na zapłacony?");
                },
                text: 'Zapłać')
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
