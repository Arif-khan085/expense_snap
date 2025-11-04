import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class LoanScreen extends StatefulWidget {
  const LoanScreen({super.key});

  @override
  State<LoanScreen> createState() => _LoanScreenState();
}

class _LoanScreenState extends State<LoanScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _lenderController = TextEditingController();
  final TextEditingController _amountController = TextEditingController();
  final TextEditingController _dueDateController = TextEditingController();
  final TextEditingController _statusController = TextEditingController();

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final String _uid = FirebaseAuth.instance.currentUser?.uid ?? "demo_user";

  bool _loading = false;

  // 🔹 Add Loan to Firestore
  Future<void> addLoan({
    required String lender,
    required double amount,
    required String dueDate,
    required String status,
  }) async {
    await _firestore.collection('users').doc(_uid).collection('loans').add({
      'lender': lender,
      'amount': amount,
      'dueDate': dueDate,
      'status': status,
      'timestamp': FieldValue.serverTimestamp(),
    });
    print("✅ Loan added successfully to Firestore for UID: $_uid");
  }

  // 🔹 Get Loan Stream
  Stream<QuerySnapshot> getLoans() {
    return _firestore
        .collection('users')
        .doc(_uid)
        .collection('loans')
        .orderBy('timestamp', descending: true)
        .snapshots();
  }

  // 🔹 Pick a date
  Future<void> _pickDate() async {
    DateTime? pickedDate = await showDatePicker(
      context: context,
      firstDate: DateTime.now(),
      lastDate: DateTime(2100),
      initialDate: DateTime.now(),
    );
    if (pickedDate != null) {
      _dueDateController.text =
      "${pickedDate.day}/${pickedDate.month}/${pickedDate.year}";
    }
  }

  // 🔹 Save Loan
  void _saveLoan() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _loading = true);
    try {
      // ✅ Create parent document if missing
      await _firestore.collection('users').doc(_uid).set({
        'createdAt': FieldValue.serverTimestamp(),
      }, SetOptions(merge: true));

      // ✅ Add Loan
      await addLoan(
        lender: _lenderController.text.trim(),
        amount: double.parse(_amountController.text.trim()),
        dueDate: _dueDateController.text.trim(),
        status: _statusController.text.trim().isEmpty
            ? "Pending"
            : _statusController.text.trim(),
      );

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Loan Added Successfully!")),
      );

      _lenderController.clear();
      _amountController.clear();
      _dueDateController.clear();
      _statusController.clear();
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error: ${e.toString()}")),
      );
    } finally {
      setState(() => _loading = false);
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Add Loan")),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: _lenderController,
                decoration: const InputDecoration(
                  labelText: "Lender Name",
                  border: OutlineInputBorder(),
                ),
                validator: (v) => v!.isEmpty ? "Enter lender name" : null,
              ),
              const SizedBox(height: 15),
              TextFormField(
                controller: _amountController,
                decoration: const InputDecoration(
                  labelText: "Loan Amount",
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.number,
                validator: (v) => v!.isEmpty ? "Enter amount" : null,
              ),
              const SizedBox(height: 15),
              TextFormField(
                controller: _dueDateController,
                readOnly: true,
                onTap: _pickDate,
                decoration: const InputDecoration(
                  labelText: "Due Date",
                  border: OutlineInputBorder(),
                  suffixIcon: Icon(Icons.calendar_today),
                ),
                validator: (v) => v!.isEmpty ? "Select due date" : null,
              ),
              const SizedBox(height: 15),
              TextFormField(
                controller: _statusController,
                decoration: const InputDecoration(
                  labelText: "Status (Paid / Pending)",
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 25),
              _loading
                  ? const CircularProgressIndicator()
                  : ElevatedButton(
                onPressed: _saveLoan,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.indigo,
                  minimumSize: const Size(double.infinity, 50),
                ),
                child: const Text(
                  "Add Loan",
                  style: TextStyle(color: Colors.white, fontSize: 16),
                ),
              ),
              const SizedBox(height: 25),
              const Divider(),
              const Text(
                "Loan History",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 10),
              StreamBuilder<QuerySnapshot>(
                stream: getLoans(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const CircularProgressIndicator();
                  }
                  if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                    return const Text("No loan records found");
                  }

                  return ListView(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    children: snapshot.data!.docs.map((doc) {
                      final data = doc.data() as Map<String, dynamic>?;

                      // Handle null safety for each field
                      final lender = data?['lender'] ?? 'Unknown Lender';
                      final dueDate = data?['dueDate'] ?? 'No Date';
                      final status = data?['status'] ?? 'Pending';
                      final amount = data?['amount'] ?? 0;

                      return Card(
                        child: ListTile(
                          title: Text(lender),
                          subtitle: Text("Due: $dueDate\nStatus: $status"),
                          trailing: Text("\$${amount.toString()}"),
                        ),
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
