import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:housemanagement/dataSources/bill_data_source.dart';
import 'package:housemanagement/models/bill.dart';
import 'package:housemanagement/screens/bills/bills_list_tile.dart';
import 'package:housemanagement/services/bills_service.dart';
import 'package:housemanagement/shared/shared_styles.dart';
import 'package:housemanagement/utils/form_dialog.dart';
import 'package:housemanagement/widgets/buttons/submit_button_widget.dart';
import 'package:housemanagement/widgets/drawer_widget.dart';
import 'package:housemanagement/widgets/textFormFields/name_text_form_field_widget.dart';
import 'package:housemanagement/widgets/textFormFields/positive_number_text_form_field_widget.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';
import 'package:intl/intl.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class BillsScreen extends StatefulWidget {
  const BillsScreen({Key? key}) : super(key: key);

  @override
  _BillsScreenState createState() => _BillsScreenState();
}

class _BillsScreenState extends State<BillsScreen> {
  final BillsService _billsService = BillsService();
  bool isInitialLoaded = false;
  List<Bill> _bills = <Bill>[];
  BillDataSource? events;
  final _formKey = GlobalKey<FormState>();

  final billNameEditingController = TextEditingController();
  final serviceProviderEditingController = TextEditingController();
  final dateOfPaymentEditingController = TextEditingController();
  final amountEditingController = TextEditingController();

  @override
  void initState() {
    _billsService.getBills().then(
        (bills) => SchedulerBinding.instance!.addPostFrameCallback((timeStamp) {
              setState(() {});
            }));

    FirebaseFirestore.instance.collection('bills').snapshots().listen((event) {
      for (var element in event.docChanges) {
        if (element.type == DocumentChangeType.added) {
          print('added');

          Bill bill = Bill.fromMap(element.doc.data()!);
          setState(() {
            events!.appointments!.add(bill);
            events!.notifyListeners(CalendarDataSourceAction.add, [bill]);
          });
        } else if (element.type == DocumentChangeType.modified) {
          Bill bill = Bill.fromMap(element.doc.data()!);

          setState(() {
            // int index = events!.appointments!.indexWhere((element) => bill.key == element.doc.id)
            // TODO:
          });
        } else if (element.type == DocumentChangeType.removed) {}
      }
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    isInitialLoaded = true;

    final billNameField = NameTextFormFieldWidget(
      controller: billNameEditingController,
      hintText: 'Nazwa',
      iconData: Icons.list,
    );

    final serviceProviderNameField = NameTextFormFieldWidget(
      controller: serviceProviderEditingController,
      hintText: 'Dostawca usługi',
      iconData: Icons.list,
    );

    final dateOfPaymentField = Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: TextFormField(
        autofocus: false,
        controller: dateOfPaymentEditingController,
        decoration: getInputDecoration(Icons.calendar_today, 'Data zapłaty'),
        readOnly: true,
      ),
    );

    final amountField = PositiveNumberTextFormFieldWidget(
        controller: amountEditingController,
        hintText: 'Wysokość opłaty',
        iconData: Icons.price_change);

    final addButton = getSubmitButton(SubmitButtonWidget(
        onPressed: () async {
          if (_formKey.currentState!.validate()) {
            var bill = await _billsService.addBill(
                billNameEditingController.text,
                serviceProviderEditingController.text,
                double.parse(amountEditingController.text),
                dateOfPaymentEditingController.text);
            Navigator.of(context).pop();

            setState(() {
              _bills.add(bill);
            });
          }
        },
        displayButtonText: 'Dodaj'));

    return Scaffold(
        appBar: AppBar(
          title: const Text('Rachunki'),
          centerTitle: true,
        ),
        resizeToAvoidBottomInset: false,
        drawer: const DrawerWidget(),
        body: StreamBuilder(
            stream: _billsService.bills,
            builder: (context, AsyncSnapshot<List<Bill>> snapshot) {
              if (snapshot.hasData) {
                return Column(
                  children: <Widget>[
                    Expanded(
                      flex: 6,
                      child: SfCalendar(
                        view: CalendarView.month,
                        showNavigationArrow: true,
                        showDatePickerButton: true,
                        dataSource: BillDataSource(snapshot.data!),
                        monthCellBuilder: monthCellBuilder,
                        monthViewSettings: const MonthViewSettings(
                          appointmentDisplayMode:
                              MonthAppointmentDisplayMode.none,
                        ),
                        onTap: calendarTapped,
                        onLongPress: (calendarLongPressDetails) {
                          setState(() {
                            dateOfPaymentEditingController.text =
                                DateFormat('yyyy-MM-dd')
                                    .format(calendarLongPressDetails.date!);
                          });

                          FormDialog.showFormDialog(
                              context: context,
                              formContent: [
                                billNameField,
                                serviceProviderNameField,
                                amountField,
                                dateOfPaymentField,
                                addButton
                              ],
                              key: _formKey,
                              dialogHeader: 'Rachunek');
                        },
                      ),
                    ),
                    Expanded(
                        flex: 3,
                        child: Container(
                            color: Colors.white,
                            child: ListView.builder(
                              itemBuilder: (BuildContext context, int index) {
                                return BillsListTile(bill: _bills[index]);
                              },
                              itemCount: _bills.length,
                            )))
                  ],
                );
              }
              return const Text('no data');
            }),
        floatingActionButton: FloatingActionButton(
          child: const Text(''),
          backgroundColor: Colors.transparent,
          elevation: 0,
          onPressed: () {},
        ));
  }

  void calendarTapped(CalendarTapDetails calendarTapDetails) {
    if (calendarTapDetails.targetElement == CalendarElement.calendarCell) {
      setState(() {
        _bills = calendarTapDetails.appointments!
            .map((appointment) => appointment as Bill)
            .toList();
      });
    }
  }

  Widget monthCellBuilder(BuildContext context, MonthCellDetails details) {
    Padding padding;
    if (details.appointments.isNotEmpty) {
      var bills = details.appointments
          .map((appointment) => appointment as Bill)
          .toList();

      if (bills.any((bill) => bill.isPaid == false)) {
        padding = Padding(
          padding: const EdgeInsets.only(top: 2.0),
          child: Container(
            decoration:
                BoxDecoration(border: Border.all(color: Colors.black12)),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Text(details.date.day.toString()),
                const Icon(
                  Icons.announcement,
                  color: Colors.red,
                )
              ],
            ),
          ),
        );
      } else {
        padding = Padding(
          padding: const EdgeInsets.only(top: 2.0),
          child: Container(
            decoration:
                BoxDecoration(border: Border.all(color: Colors.black12)),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Text(details.date.day.toString()),
                const Icon(
                  Icons.check,
                  color: Colors.green,
                )
              ],
            ),
          ),
        );
      }
    } else {
      padding = Padding(
          padding: const EdgeInsets.only(top: 2.0),
          child: Container(
              decoration:
                  BoxDecoration(border: Border.all(color: Colors.black12)),
              child: Column(
                  children: <Widget>[Text(details.date.day.toString())])));
    }

    return Container(
        decoration: BoxDecoration(
            border: Border.all(color: Colors.black12, width: 0.5),
            borderRadius: BorderRadius.circular(1)),
        child: padding);
  }
}
