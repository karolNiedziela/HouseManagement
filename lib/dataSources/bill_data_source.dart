import 'package:flutter/material.dart';
import 'package:housemanagement/models/bill.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';

class BillDataSource extends CalendarDataSource<Bill> {
  BillDataSource(List<Bill> bills) {
    appointments = bills;
  }

  @override
  String getSubject(int index) {
    return _getBillData(index).name;
  }

  @override
  DateTime getStartTime(int index) {
    var dateOfPayment = _getBillData(index).dateOfPayment;

    return DateTime(dateOfPayment.year, dateOfPayment.month, dateOfPayment.day);
  }

  @override
  DateTime getEndTime(int index) {
    var dateOfPayment = _getBillData(index).dateOfPayment;

    return DateTime(dateOfPayment.year, dateOfPayment.month, dateOfPayment.day);
  }

  @override
  Color getColor(int index) {
    var bill = _getBillData(index);

    if (bill.isPaid) {
      return Colors.green;
    }

    return Colors.red;
  }

  @override
  bool isAllDay(int index) {
    return true;
  }

  Bill _getBillData(int index) {
    final dynamic bill = appointments![index];
    late final Bill billData;
    if (bill is Bill) {
      billData = bill;
    }

    return billData;
  }
}
