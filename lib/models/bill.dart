import 'package:intl/intl.dart';

class Bill {
  String name;
  String serviceProvider;
  double amount;
  DateTime dateOfPayment;
  bool isPaid;

  Bill(
      {required this.name,
      required this.serviceProvider,
      required this.amount,
      required this.dateOfPayment,
      this.isPaid = false});

  factory Bill.fromMap(Map<String, dynamic> map) => Bill(
      name: map['name'],
      serviceProvider: map['serviceProvider'],
      amount: double.parse("${map['amount']}"),
      dateOfPayment: DateTime.parse(map['dateOfPayment']),
      isPaid: map['isPaid']);

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'serviceProvider': serviceProvider,
      'amount': amount,
      'dateOfPayment': DateFormat('yyyy-MM-dd').format(dateOfPayment),
      'isPaid': isPaid
    };
  }
}
