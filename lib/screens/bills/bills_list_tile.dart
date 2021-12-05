import 'package:flutter/material.dart';
import 'package:housemanagement/models/bill.dart';
import 'package:housemanagement/services/bills_service.dart';
import 'package:housemanagement/shared/shared_styles.dart';
import 'package:housemanagement/utils/form_dialog.dart';
import 'package:housemanagement/widgets/buttons/submit_button_widget.dart';
import 'package:housemanagement/widgets/popup_menu_widget.dart';
import 'package:housemanagement/widgets/textFormFields/base_text_form_field_widget.dart';
import 'package:housemanagement/widgets/textFormFields/positive_number_text_form_field_widget.dart';
import 'package:intl/intl.dart';

class BillsListTile extends StatefulWidget {
  final Bill bill;

  const BillsListTile({Key? key, required this.bill}) : super(key: key);

  @override
  _BillsListTileState createState() => _BillsListTileState();
}

class _BillsListTileState extends State<BillsListTile> {
  final BillsService _billsService = BillsService();

  final billNameEditingController = TextEditingController();
  final serviceProviderEditingController = TextEditingController();
  final dateOfPaymentEditingController = TextEditingController();
  final amountEditingController = TextEditingController();
  final _editFormKey = GlobalKey<FormState>();
  BaseTextFormFieldWidget? billNameField;
  BaseTextFormFieldWidget? serviceProviderNameField;
  Padding? dateofPaymentField;
  PositiveNumberTextFormFieldWidget? amountField;
  Material? editButton;

  @override
  Widget build(BuildContext context) {
    billNameField = BaseTextFormFieldWidget(
      controller: billNameEditingController,
      hintText: 'Tytuł',
      prefixIcon: Icons.list,
      textInputAction: TextInputAction.next,
      validator: (value) {
        if (value!.isEmpty) {
          return "Wprowadź tytuł.";
        }

        return null;
      },
    );

    serviceProviderNameField = BaseTextFormFieldWidget(
      controller: serviceProviderEditingController,
      hintText: 'Dostawca usługi',
      prefixIcon: Icons.list,
      textInputAction: TextInputAction.next,
      validator: (value) {
        if (value!.isEmpty) {
          return "Wprowadź dostawcę usługi.";
        }

        return null;
      },
    );

    dateofPaymentField = Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: TextFormField(
        autofocus: false,
        controller: dateOfPaymentEditingController,
        decoration:
            getInputDecoration(context, Icons.calendar_today, 'Data zapłaty'),
        readOnly: true,
      ),
    );

    amountField = PositiveNumberTextFormFieldWidget(
        controller: amountEditingController,
        hintText: 'Wysokość opłaty',
        iconData: Icons.price_change);

    editButton = getSubmitButton(SubmitButtonWidget(
      onPressed: () async {
        if (_editFormKey.currentState!.validate()) {
          await _billsService.updateBill(
              widget.bill.key,
              billNameEditingController.text,
              serviceProviderEditingController.text,
              double.parse(amountEditingController.text));
          Navigator.of(context).pop();
        }
      },
      displayButtonText: 'Dodaj',
      context: context,
    ));

    return Card(
      color: widget.bill.isPaid
          ? Theme.of(context).bottomNavigationBarTheme.backgroundColor
          : null,
      child: ListTile(
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[..._buildColumnInListView(widget.bill)],
        ),
        subtitle: Text(DateFormat("EEEE, dd MMMM, yyyy", 'pl_PL')
            .format(widget.bill.dateOfPayment)),
        trailing: _buildTrailing(widget.bill),
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

  Widget _buildTrailing(Bill bill) {
    if (bill.isPaid) {
      return PopupMenuWidget(
        isEditVisible: false,
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
                      await _billsService.payOrUndoBill(
                          widget.bill.key, widget.bill.isPaid);
                    },
                    text: "Czy na pewno chcesz zmienić status na nieopłacony?");
              },
              text: 'Cofnij opłatę')
        ],
      );
    }

    return PopupMenuWidget(
      editAction: () {
        setState(() {
          billNameEditingController.text = bill.name;
          serviceProviderEditingController.text = bill.serviceProvider;
          dateOfPaymentEditingController.text =
              DateFormat('yyyy-MM-dd').format(bill.dateOfPayment);
          amountEditingController.text = bill.amount.toString();
        });

        FormDialog.showFormDialog(
            context: context,
            formContent: [
              billNameField!,
              serviceProviderNameField!,
              dateofPaymentField!,
              amountField!,
              editButton!
            ],
            key: _editFormKey,
            dialogHeader: "Edytuj");
      },
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
                    await _billsService.payOrUndoBill(
                        widget.bill.key, widget.bill.isPaid);
                  },
                  text: "Czy na pewno chcesz zmienić status na zapłacony?");
            },
            text: 'Zapłać')
      ],
    );
  }
}
