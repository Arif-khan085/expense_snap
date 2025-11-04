import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class FirestoreService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // 🔸 Get Current User ID
  String get _uid {
    final user = _auth.currentUser;
    if (user == null) throw Exception("User not logged in");
    return user.uid;
  }

  // -------------------------------------------------
  // 🔹 TRANSACTIONS
  // -------------------------------------------------
  Future<void> addTransaction({
    required String title,
    required double amount,
    required String category,
  }) async {
    await _firestore
        .collection('users')
        .doc(_uid)
        .collection('transactions')
        .add({
      'title': title,
      'amount': amount,
      'category': category,
      'timestamp': FieldValue.serverTimestamp(),
    });
  }

  Stream<QuerySnapshot> getTransactions() {
    return _firestore
        .collection('users')
        .doc(_uid)
        .collection('transactions')
        .orderBy('timestamp', descending: true)
        .snapshots();
  }

  // -------------------------------------------------
  // 🔹 EXPENSES
  // -------------------------------------------------
  Future<void> addExpense({
    required String title,
    required double amount,
    required String note,
  }) async {
    await _firestore
        .collection('users')
        .doc(_uid)
        .collection('expenses')
        .add({
      'title': title,
      'amount': amount,
      'note': note,
      'timestamp': FieldValue.serverTimestamp(),
    });
  }

  Stream<QuerySnapshot> getExpenses() {
    return _firestore
        .collection('users')
        .doc(_uid)
        .collection('expenses')
        .orderBy('timestamp', descending: true)
        .snapshots();
  }

  // -------------------------------------------------
  // 🔹 INCOME
  // -------------------------------------------------
  Future<void> addIncome({
    required String source,
    required double amount,
    required String note,
  }) async {
    await _firestore
        .collection('users')
        .doc(_uid)
        .collection('income')
        .add({
      'source': source,
      'amount': amount,
      'note': note,
      'timestamp': FieldValue.serverTimestamp(),
    });
  }

  Stream<QuerySnapshot> getIncome() {
    return _firestore
        .collection('users')
        .doc(_uid)
        .collection('income')
        .orderBy('timestamp', descending: true)
        .snapshots();
  }

  // -------------------------------------------------
  // 🔹 LOANS
  // -------------------------------------------------
  Future<void> addLoan({
    required String lender,
    required double amount,
    required String status, // e.g., Paid / Pending
  }) async {
    await _firestore
        .collection('users')
        .doc(_uid)
        .collection('loans')
        .add({
      'lender': lender,
      'amount': amount,
      'status': status,
      'timestamp': FieldValue.serverTimestamp(),
    });
  }

  Stream<QuerySnapshot> getLoans() {
    return _firestore
        .collection('users')
        .doc(_uid)
        .collection('loans')
        .orderBy('timestamp', descending: true)
        .snapshots();
  }

  // -------------------------------------------------
  // 🔹 DELETE (Reusable for all)
  // -------------------------------------------------
  Future<void> deleteItem({
    required String collection,
    required String docId,
  }) async {
    await _firestore
        .collection('users')
        .doc(_uid)
        .collection(collection)
        .doc(docId)
        .delete();
  }
}
