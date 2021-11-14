import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:housemanagement/models/bill.dart';
import 'package:intl/intl.dart';

class BillsService {
  final billsColection = FirebaseFirestore.instance.collection('bills');

  Stream<List<Bill>> getAllBills() {
    return billsColection.snapshots().map(_billsListFromSnapshot);
  }

  Stream<List<Bill>> getBills(DateTime selectedDate) {
    return billsColection
        .where('dateOfPayment',
            isEqualTo: DateFormat('yyyy-MM-dd').format(selectedDate))
        .snapshots()
        .map(_billsListFromSnapshot);
  }

  List<Bill> _billsListFromSnapshot(QuerySnapshot snapshot) {
    var bills = snapshot.docs
        .map((doc) => Bill.fromMap(doc.data() as Map<String, dynamic>))
        .toList();
    return bills;
  }

  Future<Bill> addBill(String name, String serviceProvider, double amount,
      String dateOfPayment) async {
    var ref = billsColection.doc();

    var bill = Bill(
        key: ref.id,
        name: name,
        serviceProvider: serviceProvider,
        amount: amount,
        dateOfPayment: DateTime.parse(dateOfPayment));

    ref.set(bill.toMap());

    return bill;
  }

  Future<Bill> payBill(String key) async {
    var snapshot = await billsColection.doc(key).get();

    var bill = Bill.fromMap(snapshot.data()!);

    bill.isPaid = true;

    await billsColection.doc(key).update(bill.toMap());

    return bill;
  }

  Future<void> deleteBill(String key) async {
    await billsColection.doc(key).delete();
  }
}
