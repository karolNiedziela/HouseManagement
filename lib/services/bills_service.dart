import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:housemanagement/models/bill.dart';
import 'package:housemanagement/services/auth_service.dart';
import 'package:intl/intl.dart';

class BillsService {
  final billsCollection = FirebaseFirestore.instance.collection('bills');
  final AuthService _authService = AuthService();

  Stream<List<Bill>> getAllBills(List<String> userUIds) {
    return billsCollection
        .where('userUId', whereIn: userUIds)
        .snapshots()
        .map(_billsListFromSnapshot);
  }

  Stream<List<Bill>> getBills(DateTime selectedDate) {
    return billsCollection
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

  Future addBill(String name, String serviceProvider, double amount,
      String dateOfPayment) async {
    var ref = billsCollection.doc();

    var userUId = _authService.uid;

    var bill = Bill(
        key: ref.id,
        name: name,
        serviceProvider: serviceProvider,
        amount: amount,
        userUId: userUId!,
        dateOfPayment: DateTime.parse(dateOfPayment));

    ref.set(bill.toMap());
  }

  Future<Bill> payOrUndoBill(String key, bool isPaid) async {
    var snapshot = await billsCollection.doc(key).get();

    var bill = Bill.fromMap(snapshot.data()!);

    if (isPaid) {
      bill.isPaid = false;
    } else {
      bill.isPaid = true;
    }

    await billsCollection.doc(key).update(bill.toMap());

    return bill;
  }

  Future<void> deleteBill(String key) async {
    await billsCollection.doc(key).delete();
  }

  Future<Map<String, double>> getMonthlyExpenses() async {
    var bills = (await billsCollection.where('isPaid', isEqualTo: true).where('dateOfPayment', isGreaterThanOrEqualTo: '2022-01-01').get())
        .docs
        .map((doc) => Bill.fromMap(doc.data()))
        .toList();
    var monthsToExpenses = <String, double>{};

    for (var bill in bills.where((bill) => bill.isPaid)) {
      var month = DateFormat.M().format(bill.dateOfPayment);
      var amountForBills =
          bills.fold<double>(0, (sum, bill) => sum + (bill.amount));
      if (monthsToExpenses.containsKey(month)) {
        monthsToExpenses[month] = monthsToExpenses[month]! + amountForBills;
      } else {
        monthsToExpenses[month] = amountForBills;
      }
    }

    return monthsToExpenses;
  }

  Future updateBill(String documentId, String name, String serviceProvider,
      double amount) async {
    await billsCollection.doc(documentId).update(
        {'name': name, 'serviceProvider': serviceProvider, 'amount': amount});
  }
}
