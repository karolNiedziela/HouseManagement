import 'package:intl/intl.dart';

class Bill {
  String key;
  String name;
  String serviceProvider;
  double amount;
  DateTime dateOfPayment;
  bool isPaid;
  String userUId;

  Bill(
      {required this.key,
      required this.name,
      required this.serviceProvider,
      required this.amount,
      required this.dateOfPayment,
      required this.userUId,
      this.isPaid = false});

  factory Bill.fromMap(Map<String, dynamic> map) => Bill(
      key: map['key'],
      name: map['name'],
      serviceProvider: map['serviceProvider'],
      amount: double.parse("${map['amount']}"),
      dateOfPayment: DateTime.parse(map['dateOfPayment']),
      userUId: map['userUId'],
      isPaid: map['isPaid']);

  Map<String, dynamic> toMap() {
    return {
      'key': key,
      'name': name,
      'serviceProvider': serviceProvider,
      'amount': amount,
      'dateOfPayment': DateFormat('yyyy-MM-dd').format(dateOfPayment),
      'userUId': userUId,
      'isPaid': isPaid
    };
  }
}
