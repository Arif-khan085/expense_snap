import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class IncomeScreen extends StatefulWidget {
  const IncomeScreen({super.key});

  @override
  State<IncomeScreen> createState() => _IncomeScreenState();
}

class _IncomeScreenState extends State<IncomeScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _sourceController = TextEditingController();
  final TextEditingController _amountController = TextEditingController();
  final TextEditingController _noteController = TextEditingController();

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final String _uid = FirebaseAuth.instance.currentUser?.uid ?? "demo_user";

  bool _loading = false;

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

  void _saveIncome() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _loading = true);

    try {
      await addIncome(
        source: _sourceController.text.trim(),
        amount: double.parse(_amountController.text.trim()),
        note: _noteController.text.trim(),
      );

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Income Added Successfully!")),
      );

      _sourceController.clear();
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

  Stream<QuerySnapshot> getIncome() {
    return _firestore
        .collection('users')
        .doc(_uid)
        .collection('income')
        .orderBy('timestamp', descending: true)
        .snapshots();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Add Income")),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: _sourceController,
                decoration: const InputDecoration(
                  labelText: "Income Source",
                  border: OutlineInputBorder(),
                ),
                validator: (v) => v!.isEmpty ? "Enter income source" : null,
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
                onPressed: _saveIncome,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green,
                  minimumSize: const Size(double.infinity, 50),
                ),
                child: const Text(
                  "Add Income",
                  style: TextStyle(color: Colors.white, fontSize: 16),
                ),
              ),
              const SizedBox(height: 25),
              const Divider(),
              const Text(
                "Income History",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 10),
              StreamBuilder<QuerySnapshot>(
                stream: getIncome(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const CircularProgressIndicator();
                  }

                  if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                    return const Text("No income records found");
                  }

                  return ListView(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    children: snapshot.data!.docs.map((doc) {
                      final data = doc.data() as Map<String, dynamic>;
                      return ListTile(
                        title: Text(data['source']),
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
