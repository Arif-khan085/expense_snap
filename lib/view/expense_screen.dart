import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class ExpenseScreen extends StatefulWidget {
  const ExpenseScreen({super.key});

  @override
  State<ExpenseScreen> createState() => _ExpenseScreenState();
}

class _ExpenseScreenState extends State<ExpenseScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _amountController = TextEditingController();
  final TextEditingController _noteController = TextEditingController();

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final String _uid = FirebaseAuth.instance.currentUser?.uid ?? "demo_user";

  bool _loading = false;

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

  void _saveExpense() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _loading = true);

    try {
      await addExpense(
        title: _titleController.text.trim(),
        amount: double.parse(_amountController.text.trim()),
        note: _noteController.text.trim(),
      );

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Expense Added Successfully!")),
      );

      _titleController.clear();
      _amountController.clear();
      _noteController.clear();
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error: ${e.toString()}")),
      );
    } finally {
      setState(() => _loading = false);
    }
  }

  Stream<QuerySnapshot> getExpenses() {
    return _firestore
        .collection('users')
        .doc(_uid)
        .collection('expenses')
        .orderBy('timestamp', descending: true)
        .snapshots();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Add Expense")),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: _titleController,
                decoration: const InputDecoration(
                  labelText: "Expense Title",
                  border: OutlineInputBorder(),
                ),
                validator: (v) => v!.isEmpty ? "Enter expense title" : null,
              ),
              const SizedBox(height: 15),
              TextFormField(
                controller: _amountController,
                decoration: const InputDecoration(
                  labelText: "Amount",
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.number,
                validator: (v) => v!.isEmpty ? "Enter amount" : null,
              ),
              const SizedBox(height: 15),
              TextFormField(
                controller: _noteController,
                decoration: const InputDecoration(
                  labelText: "Note (optional)",
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 25),
              _loading
                  ? const CircularProgressIndicator()
                  : ElevatedButton(
                onPressed: _saveExpense,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue,
                  minimumSize: const Size(double.infinity, 50),
                ),
                child: const Text(
                  "Add Expense",
                  style: TextStyle(color: Colors.white, fontSize: 16),
                ),
              ),
              const SizedBox(height: 25),
              const Divider(),
              const SizedBox(height: 10),
              const Text(
                "Expense List",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 10),
              StreamBuilder<QuerySnapshot>(
                stream: getExpenses(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const CircularProgressIndicator();
                  }

                  if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                    return const Text("No expenses found");
                  }

                  return ListView(
                    shrinkWrap: true,
                    children: snapshot.data!.docs.map((doc) {
                      final data = doc.data() as Map<String, dynamic>;
                      return ListTile(
                        title: Text(data['title']),
                        subtitle: Text("Note: ${data['note'] ?? '-'}"),
                        trailing: Text("\$${data['amount']}"),
                      );
                    }).toList(),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
