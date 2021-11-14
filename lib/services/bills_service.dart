import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:housemanagement/models/bill.dart';

class BillsService {
  final billsColection = FirebaseFirestore.instance.collection('bills');

  Stream<List<Bill>> get bills {
    return billsColection.snapshots().map(_billsListFromSnapshot);
  }

  List<Bill> _billsListFromSnapshot(QuerySnapshot snapshot) {
    var bills = snapshot.docs
        .map((doc) => Bill.fromMap(doc.data() as Map<String, dynamic>))
        .toList();
    return bills;
  }

  Future<List<Bill>> getBills() async {
    var snapshots = await billsColection.get();

    List<Bill> bills =
        snapshots.docs.map((doc) => Bill.fromMap(doc.data())).toList();

    return bills;
  }

  Future<Bill> addBill(String name, String serviceProvider, double amount,
      String dateOfPayment) async {
    var bill = Bill(
        name: name,
        serviceProvider: serviceProvider,
        amount: amount,
        dateOfPayment: DateTime.parse(dateOfPayment));

    await billsColection.doc().set(bill.toMap());

    return bill;
  }
}
